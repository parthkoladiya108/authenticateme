import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

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
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      ipaddress = androidInfo.id;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      ipaddress = iosInfo.identifierForVendor!;
      return iosInfo.identifierForVendor;
    } else if (Platform.isWindows) {
      final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      ipaddress = windowsInfo.deviceId;
      return windowsInfo.deviceId;
    } else {
      throw UnsupportedError('This platform is not supported.');
    }
    update();
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

  Future authenticateUser(
      String userUsername, String userPassword, String deviceMacAddress) async {
    try {
      final client = OdooClient("https://security-v15.odoo.com");

      final data = await client.authenticate(
          "planetodooofficial-security-v15-production-7947598",
          userUsername,
          userPassword);

      final data2 = await client.callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['login', '=', userUsername]
          ],
          'fields': ['name', 'x_studio_mac_addresses'],
        },
      });
      data2[0]['x_studio_mac_addresses'];
      List<String> xStudioMacAddress =
          data2[0]['x_studio_mac_addresses'].toString().split(',');

      if (xStudioMacAddress.contains(deviceMacAddress)) {
        isPassed = true;
        isLoading = false;
        update();

        Get.snackbar(
          "Successful",
          "Device authenticated successfully.",
          icon: Icon(Icons.done, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
        Future.delayed(const Duration(seconds: 2), () {
          isPassed = false;
          update();
        });
      } else {
        Get.snackbar(
          "Does not match",
          "Your device does not match any ip address.",
          icon: Icon(Icons.error, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading = false;
        update();
      }
    } catch (e) {
      // print("---------------------------------------------");
      // e.printError();
      // print("---------------------------------------------");
      // var data = e;

      Get.snackbar(
        "${e.runtimeType}",
        "Failed to authenticate device please check your credentials.",
        icon: Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading = false;
      update();
    }
  }
}
