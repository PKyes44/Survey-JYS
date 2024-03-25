import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:survey_jys/authentication/name_screen.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/widgets/form_button.dart';

class PasswordScreen extends StatefulWidget {
  Map<String, dynamic> userData;
  PasswordScreen({
    super.key,
    required this.userData,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _password = "";
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool isPasswordValid() {
    return _password.isNotEmpty && _password.length > 5;
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void onSubmit() {
    if (!isPasswordValid()) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NameScreen(
          userData: {
            'studentNumber': widget.userData['studentNumber'],
            'password': _password,
          },
        ),
      ),
    );
  }

  void onClearTap() {
    _passwordController.clear();
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScaffoldTap,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Sign Up",
            style: TextStyle(),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size36,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,
              const Text(
                "비밀번호를 입력해주세요",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              const Text(
                "계정 생성 후 바꿀 수 없습니다",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
              ),
              Gaps.v16,
              TextFormField(
                onSaved: (newValue) {
                  _password = newValue.toString();
                },
                obscureText: obscureText,
                onEditingComplete: onSubmit,
                autocorrect: false,
                controller: _passwordController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onClearTap,
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                      Gaps.h16,
                      GestureDetector(
                        onTap: toggleObscureText,
                        child: FaIcon(
                          obscureText
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                    ],
                  ),
                  hintText: "비밀번호",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              Gaps.v10,
              const Text(
                "다음의 조건에 만족해야 합니다",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v10,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: Sizes.size20,
                    color: isPasswordValid() ? Colors.green : Colors.grey,
                  ),
                  Gaps.h5,
                  const Text("6글자 이상이며 20글자 이하여야 합니다"),
                ],
              ),
              Gaps.v16,
              GestureDetector(
                onTap: onSubmit,
                child: FormButton(
                  widthSize: MediaQuery.of(context).size.width,
                  disabled: !isPasswordValid(),
                  text: "다음",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
