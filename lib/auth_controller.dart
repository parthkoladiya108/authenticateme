import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:platform_device_id/platform_device_id.dart';

class AuthController extends GetxController {
  bool obscureText = true;
  bool isLoading = false;
  bool isPassed = false;
  String ipaddress = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      authenticateUser(userUsername, userPassword, ipAddress);
    } else {
      print('error line 02');
      isLoading = false;
      update();
    }
  }

  updateSettings(
      String userUsername, String userPassword, OdooClient client2) async {
    try {
      final client = OdooClient("https://security-v15.odoo.com");
      final user = await client.authenticate(
          "planetodooofficial-security-v15-production-7947598",
          userUsername,
          userPassword);

      final data2 = await client2.callKw({
        'model': 'res.users',
        'method': 'write',
        'args': [
          [user.userId],
          {
            'x_studio_authenticated_via_security_app': true,
            'x_studio_last_authenticated_datetime': DateTime.now().toString(),
            'x_studio_last_updated_ip': ipaddress.trim()
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
      final client = OdooClient("https://security-v15.odoo.com");

      final data = await client.authenticate(
          "planetodooofficial-security-v15-production-7947598",
          'admin',
          'admin');

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
      data2[0]['x_studio_mac_addresses'];
      List<String> xStudioMacAddress =
          data2[0]['x_studio_mac_addresses'].toString().split(',');

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
        "${e.runtimeType}",
        "Failed to authenticate device please check your credentials.",
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading = false;
      update();
    }
  }
}
