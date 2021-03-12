import 'package:nlidb/signup.dart';
import 'package:nlidb/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'components/FadeAnimation.dart';
import 'components/rounded_button.dart';
import 'constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                color: kPrimaryLightColor,
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.2,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                    1.3,
                    Text(
                      "WELCOME",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 2,
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  FadeAnimation(
                    1,
                    SvgPicture.asset(
                      "assets/images/welcome.svg",
                      height: size.height * 0.35,
//
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  FadeAnimation(
                    1.5,
                    RoundedButton(
                      text: "Login".toUpperCase(),
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  FadeAnimation(
                    2,
                    RoundedButton(
                      text: "Signup".toUpperCase(),
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
