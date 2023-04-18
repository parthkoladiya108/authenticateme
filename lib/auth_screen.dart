import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'fade_animation.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            )),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(left: 25, right: 25, top: 50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 16.0, top: 16, bottom: 4),
                            child: Text('url',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, bottom: 16),
                            child: StartUpTextFiled(
                              color: Colors.white,
                              fillColor: Colors.white,
                              headingTextColor: Colors.white,
                              isShowBorder: true,
                              controller: urlController,
                              headingText: 'url',
                              hintText: "url",
                              validator: (value) {
                                final urlPattern = RegExp(
                                  r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
                                  caseSensitive: false,
                                );
                                if (value!.isEmpty) {
                                  return 'Please enter your url here';
                                } else if (!urlPattern.hasMatch(value)) {
                                  return 'Please enter valid url';
                                }
                                return null;
                              },
                              textInputType: TextInputType.emailAddress,
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 16.0, top: 16, bottom: 4),
                            child: Text('User name',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, bottom: 16),
                            child: StartUpTextFiled(
                              color: Colors.white,
                              fillColor: Colors.white,
                              headingTextColor: Colors.white,
                              controller: userNameController,
                              isShowBorder: true,
                              headingText: 'User name',
                              hintText: "User name",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your user name here';
                                }
                                return null;
                              },
                              textInputType: TextInputType.emailAddress,
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 16.0, top: 16, bottom: 4),
                            child: Text('Password',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, bottom: 16),
                            child: StartUpTextFiled(
                              color: Colors.white,
                              fillColor: Colors.white,
                              controller: passwordController,
                              obscureText: true,
                              headingTextColor: Colors.white,
                              isShowBorder: true,
                              headingText: 'Password',
                              hintText: "Password",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Password here';
                                }
                                return null;
                              },
                              textInputType: TextInputType.emailAddress,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.teal)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await checkMethod(
                                        userNameController.text,
                                        passwordController.text,
                                        urlController.text);
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //       content: Text('Processing Data')),
                                    // );
                                  }
                                },
                                child: const Text('check'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  checkMethod(String userUsername, String userPassword, String url) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      authenticate_user(userUsername, userPassword,
          iosDeviceInfo.identifierForVendor!, url); // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      authenticate_user(userUsername, userPassword, androidDeviceInfo.id,
          url); // unique ID on Android
    } else if (Platform.isWindows) {
      final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;

      authenticate_user(userUsername, userPassword, windowsInfo.deviceId, url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error')),
      );
    }
  }

  Future authenticate_user(String userUsername, String userPassword,
      String deviceMacAddress, String url2) async {
    String url = url2;
    // "https://security-v15.odoo.com";
    String db = "planetodooofficial-security-v15-production-7947598";
    String username = userUsername;
    // "admin";
    String password = userPassword;
    //"admin";

    var response = await http.post(
      Uri.parse("$url/xmlrpc/2/common"),
      headers: {"Content-Type": "text/xml"},
      body: """
        <?xml version="1.0"?>
          <methodCall>
            <methodName>authenticate</methodName>
            <params>
              <param><string>$db</string></param>
              <param><string>$username</string></param>
              <param><string>$password</string></param>
              <param><struct/></param>
            </params>
          </methodCall>
      """,
    );

    var data = xml.XmlDocument.parse(response.body);
    var adminUid = data.findAllElements('int').first.text;
    print("admin_uid: $adminUid");

    if (adminUid == null) {
      //   return true;
      // } else {
      print("Admin password not setup");
      return false;
    }

    var modelsResponse = await http.post(
      Uri.parse("$url/xmlrpc/2/object"),
      headers: {"Content-Type": "text/xml"},
      body: """
        <?xml version="1.0"?>
          <methodCall>
            <methodName>execute_kw</methodName>
            <params>
              <param><string>$db</string></param>
              <param><int>$adminUid</int></param>
              <param><string>$password</string></param>
              <param><string>res.users</string></param>
              <param><string>search_read</string></param>
              <param>
                <array>
                  <array>
                    <string>login</string>
                    <string>=</string>
                    <string>$userUsername</string>
                  </array>
                </array>
              </param>
              <param>
                <struct>
                  <member>
                    <name>fields</name>
                    <value>
                      <array>
                        <string>name</string>
                        <string>x_studio_mac_addresses</string>
                      </array>
                    </value>
                  </member>
                </struct>
              </param>
            </params>
          </methodCall>
      """,
    );

    data = xml.XmlDocument.parse(modelsResponse.body);
    if (data.findAllElements('array').isNotEmpty) {
      var operations = data.findAllElements('array').last;

      var operationsList = operations.children.whereType<xml.XmlElement>();

      print("Length : ${operationsList.length}");

      if (operationsList.isNotEmpty) {
        var operation = operationsList.first;
        var userMacAddresses =
            operation.findElements("string").last.text.toString();

        var userMacAddressList = userMacAddresses.split(',');
        for (var each_mac_adress in userMacAddressList) {
          print("each_mac_adress: $each_mac_adress");

          if (each_mac_adress == deviceMacAddress) {
            print("each_mac_adress: $each_mac_adress");
            print("User Authenticated Sucessfully");
            return true;
          }
        }

        print("Device Not Authenticated");
      } else {
        print("Authentication Failed");
        return false;
      }
    } else {
      print("Authentication Failed");
      return false;
    }
  }
}
