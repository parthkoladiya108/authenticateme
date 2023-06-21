import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';
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
  AuthController authenticationController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Colors.blue,
                    Colors.red.withOpacity(0.8),
                    Colors.red
                  ]),
            ),
          ),
          title: const Text("Odoo Authentication via Secured Device"),
        ),
        backgroundColor: Colors.white,
        body: GetBuilder<AuthController>(
            initState: (state) => Future.delayed(Duration.zero, () {
                  authenticationController.getipAddress();
                }),
            builder: (authController) => SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
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
                                margin: const EdgeInsets.only(
                                    left: 25, right: 25, top: 50),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Form(
                                  key: authController.formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            top: 16,
                                            bottom: 4,
                                            right: 16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Your Device ID :- ${authController.ipaddress}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ).paddingOnly(top: 0),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: authController
                                                            .ipaddress
                                                            .trim()));
                                                // copied successfully
                                              },
                                              child: const Icon(
                                                Icons.copy,
                                                size: 23,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, top: 16, bottom: 4),
                                        child: Text('Database url',
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
                                          controller:
                                              authController.dbUrlController,
                                          isShowBorder: true,
                                          headingText: 'Database url',
                                          hintText: "Database url",
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your database url here';
                                            }
                                            return null;
                                          },
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, top: 16, bottom: 4),
                                        child: Text('Database name',
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
                                          controller:
                                              authController.dbNameController,
                                          isShowBorder: true,
                                          headingText: 'Database name',
                                          hintText: "Database name",
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your database name here';
                                            }
                                            return null;
                                          },
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, top: 16, bottom: 4),
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
                                          controller:
                                              authController.userNameController,
                                          isShowBorder: true,
                                          headingText: 'User name',
                                          hintText: "User name",
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your user name here';
                                            }
                                            return null;
                                          },
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, top: 16, bottom: 4),
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
                                          controller:
                                              authController.passwordController,
                                          obscureText:
                                              authController.obscureText,
                                          suffixIconWidget: authController
                                                  .obscureText
                                              ? const Icon(
                                                  Icons.visibility_off_outlined,
                                                  color: Colors.black)
                                              : const Icon(
                                                  Icons.visibility_outlined,
                                                  color: Colors.black,
                                                ),
                                          suffixIconOnPress: () {
                                            authController.obscureText =
                                                !authController.obscureText;
                                            authController.update();
                                          },
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
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.teal)),
                                            onPressed: () async {
                                              if (primaryFocus != null) {
                                                primaryFocus!.unfocus();
                                              }
                                              if (authController
                                                  .formKey.currentState!
                                                  .validate()) {
                                                await authController
                                                    .checkMethod(
                                                  authController
                                                      .userNameController.text,
                                                  authController
                                                      .passwordController.text,
                                                );
                                              }
                                            },
                                            child: const Text('Authenticate'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: authController.isLoading,
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withOpacity(0.4),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: Colors.redAccent,
                            ))),
                      ),
                      Visibility(
                        visible: (!authController.isLoading &&
                            authController.isPassed),
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white.withOpacity(0.5),
                            child: Center(
                              child: Image.asset(
                                "assets/confirm.gif",
                                height: 125.0,
                                width: 125.0,
                              ),
                            )),
                      )
                    ],
                  ),
                )));
  }
}
