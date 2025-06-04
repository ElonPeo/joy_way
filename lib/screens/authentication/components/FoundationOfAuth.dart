import 'package:flutter/material.dart';
import 'package:joy_way/config/GeneralSpecifications.dart';
import 'package:joy_way/screens/authentication/components/Login/LoginScreen.dart';
import 'package:joy_way/screens/authentication/components/RecoveryPassword/RecoveryPasswordScreen.dart';
import 'package:joy_way/screens/authentication/components/Register/RegisterScreen.dart';
import 'package:joy_way/widgets/AnimationContainer/FadeContainer.dart';
import 'StatusAndErrorMessages.dart';

class FoundationOfAuth extends StatefulWidget {
  @override
  State<FoundationOfAuth> createState() => _FoundationOfAuthState();
}

class _FoundationOfAuthState extends State<FoundationOfAuth> {
  bool goToHomePage = false;
  bool passwordRecoveryRequestsSuccessful = false;
  bool isUnsuccessful = false;
  bool showStatusAndErrorMessages = false;
  int type = 0;
  bool scaleForLoading = false;
  String messages = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      showStatusAndErrorMessages = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: specs.screenHeight,
        width: specs.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(143, 135, 241, 0.2),
              Color.fromRGBO(156, 204, 204, 0.2),
              Color.fromRGBO(242, 198, 245, 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(children: [
          FadeContainer(
            fatherHeight: specs.screenHeight,
            fatherWidth: specs.screenWidth,
            duration: Duration(milliseconds: 200),
            animation: showStatusAndErrorMessages,
              child: StatusAndErrorMessages(
                type: type,
                scaleLoading: scaleForLoading,
                goToHomePage: goToHomePage,
                messages: messages,
                passwordRecoveryRequestsSuccessful: passwordRecoveryRequestsSuccessful,
                onPasswordRecoveryRequest: (value) {
                  setState(() {
                    passwordRecoveryRequestsSuccessful = value;
                  });
                },
                isUnsuccessful: isUnsuccessful,
                onScaleLoading: (value) {
                  setState(() {
                    scaleForLoading = value;
                  });
                },
                onUnsuccessful: (value) {
                  setState(() {
                    isUnsuccessful = value;
                  });
                },
                onMessages: (value) {
                  setState(() {
                    messages = value;
                  });
                },
              ),
          ),
          if (type == 1)
            Container(
            height: specs.screenHeight,
            width: specs.screenWidth,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: RegisterScreen(
              type: type,
              scaleForLoading: scaleForLoading,
              messages: messages,
              onUnsuccessful: (value) {
                setState(() {
                  isUnsuccessful= value;
                });
              },
              onMessages: (value) {
                setState(() {
                  messages = value;
                });
              },
              onGotoHomePage: (value) {
                setState(() {
                  goToHomePage = value;
                });
              },
              onScaleChangedLoading: (value) {
                setState(() {
                  scaleForLoading = value;
                });
              },
              onTypeChanged: (value) {
                setState(() {
                  type = value;
                });
              },
            ),
          )
          else if(type == 2)
            Container(
              height: specs.screenHeight,
              width: specs.screenWidth,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: RecoveryPasswordScreen(
                type: type,
                scaleForLoading: scaleForLoading,
                messages: messages,
                onUnsuccessful: (value) {
                  setState(() {
                    isUnsuccessful= value;
                  });
                },
                onMessages: (value) {
                  setState(() {
                    messages = value;
                  });
                },
                onPasswordRecoveryRequest: (value) {
                  setState(() {
                    passwordRecoveryRequestsSuccessful = value;
                  });
                },
                onScaleChangedLoading: (value) {
                  setState(() {
                    scaleForLoading = value;
                  });
                },
                onTypeChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
            )
          else Container(
              height: specs.screenHeight,
              width: specs.screenWidth,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: LoginScreen(
                type: type,
                scaleForLoading: scaleForLoading,
                messages: messages,
                onUnsuccessful: (value) {
                  setState(() {
                    isUnsuccessful= value;
                  });
                },
                onMessages: (value) {
                  setState(() {
                    messages = value;
                  });
                },
                onGotoHomePage: (value) {
                  setState(() {
                    goToHomePage = value;
                  });
                },
                onScaleChangedLoading: (value) {
                  setState(() {
                    scaleForLoading = value;
                  });
                },
                onTypeChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
            ),

        ]),
      ),
    );
  }
}
