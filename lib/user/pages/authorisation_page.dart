import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/pages/storage_page.dart';
import 'package:inventory_managment/user/pages/user_storage_page.dart';
import 'package:inventory_managment/user/pages/registration_page.dart';
import 'package:inventory_managment/requests/auth_user.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/button.dart';
import 'package:inventory_managment/widgets/show_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String status = "";
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    Icon icon = const Icon(Icons.visibility_off);
    if (obscureText) {
      icon = const Icon(Icons.visibility);
    }
    return Scaffold(
        body: background1(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Flexible(
              child: Text(
                "Авторизация",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            Expanded(flex: 2, child: Container()),
            const Flexible(
              flex: 1,
              child: Text(
                "Имя пользователя",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 2, child: Container()),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      maxLength: 16,
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                    ),
                  ),
                  Flexible(flex: 2, child: Container())
                ],
              ),
            ),
            const Flexible(
              flex: 1,
              child: Text("Пароль",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      maxLength: 20,
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: icon,
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            }),
                        border: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: button(
                const Text(
                  "Войти",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  Map<String, dynamic> data =
                      await authUser(username, password);
                  setState(() {
                    status = data["status"];
                    if (status == 'ok') {
                      putToTheStorage("username", username);
                      putToTheStorage('password', password);
                      if (data["rightsLevel"] == 1) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const UserStoragePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const StoragePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    } else {
                      showIncorrectDataAlert(
                          context,
                          const Text(
                              "Пароль или Имя пользователя введены некорректно"));
                    }
                  });
                },
              ),
            ),
            Flexible(
                flex: 1,
                child: InkWell(
                  child: const Text(
                    "Нет аккаунта?",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const RegistrationPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  },
                )),
            Flexible(flex: 2, child: Container()),
            Flexible(
              flex: 1,
              child: Text(status),
            )
          ],
        ),
      ),
    ));
  }
}
