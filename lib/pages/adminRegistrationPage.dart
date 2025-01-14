import 'package:flutter/material.dart';
import 'authorisationPage.dart';
import '../localStorage.dart';
import '../requests/registerUser.dart';

class AdminRegistrationPage extends StatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String status = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration for admins"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Flexible(
              flex: 1,
              child: Text(
                "Username",
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
              child: Text("Password",
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
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
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
              child: ElevatedButton(
                  onPressed: () async {
                    String username = usernameController.text;
                    String password = passwordController.text;
                    Map<String, dynamic> data = await registerUser(
                        username, password, 2);
                    setState(() {
                      status = data["status"];
                      if (status == 'ok') {
                        putToTheStorage("username", username);
                        putToTheStorage('password', password);
                      }
                    });
                  },
                  child: const Text("Save")),
            ),
            Flexible(
                flex: 1,
                child: InkWell(
                  child: const Text("Already have an account?"),
                  onTap: () => {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const LoginPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  },
                )),
            Flexible(flex: 4, child: Container()),
          ],
        ),
      ),
    );
  }
}
