import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'app_constant/string.dart';

class AuthController extends GetxController {
  bool obscureText = true;
  bool isLoading = false;
  bool isPassed = false;
  String ipaddress = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dbNameController = TextEditingController();
  TextEditingController dbUrlController = TextEditingController();

  Future<String?> getipAddress() async {
    try {
      ipaddress = (await PlatformDeviceId.getDeviceId) ?? '';
      update();
      return ipaddress;
    } on PlatformException {
      ipaddress = 'Failed to get deviceId.';
      update();
      return ipaddress;
    }
  }

  checkMethod(
    String userUsername,
    String userPassword,
  ) async {
    isLoading = true;
    update();
    String? ipAddress = await getipAddress();
    if (ipAddress != null) {
      authenticateUser(userUsername, userPassword, ipaddress);
    } else {
      print('error line 02');
      isLoading = false;
      update();
    }
  }

  updateSettings(
      String userUsername, String userPassword, OdooClient client2) async {
    try {
      final client = OdooClient(dbUrlController.text);
      final user = await client.authenticate(
          dbNameController.text, userUsername, userPassword);

      final data2 = await client2.callKw({
        'model': 'res.users',
        'method': 'write',
        'args': [
          [user.userId],
          {
            appString.authenticatedViaSecurity: true.toString(),
            appString.lastUpdatedIp: ipaddress.trim()
          }
        ],
        'kwargs': {
          'context': {'bin_size': true},
        },
      });

      if (data2) {
        isPassed = true;
        isLoading = false;
        Future.delayed(const Duration(seconds: 1), () {
          isPassed = false;
          update();
        });

        update();
        Get.snackbar(
          "Successful",
          "Device authenticated successfully.",
          icon: const Icon(Icons.done, color: Colors.green),
          snackPosition: SnackPosition.BOTTOM,
        );

        update();
      } else {
        Get.snackbar(
          "Does not match",
          "Your device does not match any ip address.",
          icon: const Icon(Icons.error, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading = false;
        update();
      }
    } catch (e) {
      isPassed = false;

      Get.snackbar(
        "${e.runtimeType}",
        "Failed to authenticate device please check your credentials.",
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading = false;
      update();
    }
  }

  Future authenticateUser(
      String userUsername, String userPassword, String deviceMacAddress) async {
    try {
      final client = OdooClient(dbUrlController.text.trim());

      await client.authenticate(dbNameController.text.trim(),
          appString.adminUserName, appString.adminPassword);

      final data2 = await client.callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['login', '=', userUsername]
          ],
        },
      });

      data2[0][appString.macAddress];
      List<String> xStudioMacAddress =
          data2[0][appString.macAddress].toString().split(',');

      if (xStudioMacAddress.contains(deviceMacAddress.trim())) {
        isLoading = false;
        // client.close();
        update();
        await updateSettings(userUsername, userPassword, client);
        // isPassed = false;
        // update();
      } else {
        Get.snackbar(
          "Does not match",
          "Your device does not match any ip address.",
          icon: const Icon(Icons.error, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading = false;
        update();
      }
    } catch (e) {
      isPassed = false;

      Get.snackbar(
        "Failed to authenticate",
        "Failed to authenticate device please check your credentials.",
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading = false;
      update();
    }
  }
}
