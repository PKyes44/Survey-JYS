import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/vote_check_screen.dart';
import 'package:survey_jys/screens/vote_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};
  Map<dynamic, dynamic> userData = {};
  Map<dynamic, dynamic> detailData = {};

  String nickname = '';

  String name = '';
  String point = '';
  String studentNumber = '';

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        name = detailData[formData['studentNumber']]['name'].toString();
        point = detailData[formData['studentNumber']]['point'].toString();
        studentNumber = formData['studentNumber'].toString();

        clearData();
        _saveData();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MakeQuestionScreen(
              studentNumber: studentNumber,
              name: name,
              point: point,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  // 데이터를 저장하는 함수
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('studentNumber', studentNumber);
    prefs.setString('name', name);
    prefs.setString('point', point);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '저장완료 : $studentNumber-$name-$point',
        ),
      ), // 저장 완료 메시지 출력
    );
    print(
        "Generate token Completed studentNum: $studentNumber name: $name point: $point");
  }

  @override
  void initState() {
    var readData = readUserData();
    readData.then((value) {
      var tempData = value;
      for (var key in tempData.keys) {
        Map<dynamic, dynamic> temp = value[key] as Map<dynamic, dynamic>;
        userData[key.toString()] = temp['password'];

        var details = {
          'point': temp['point'],
          'name': temp['name'],
        };
        detailData[key.toString()] = details;
      }
      setState(() {});
      print('userData : $userData');
    });
    // TODO: implement initState
    super.initState();
  }

  void clearData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  Future<Map<Object?, Object?>> readUserData() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await reference.child('user/').get();
    return snapshot.value as Map<Object?, Object?>;
  }

  bool matchNickname(String nickname) {
    if (!userData.containsKey(nickname)) {
      return false;
    }
    return true;
  }

  bool matchPassword(String password) {
    if (!userData.containsValue(password)) {
      return false;
    }
    return true;
  }

  bool matchData(String password) {
    if (userData[nickname] == password) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: InputDecoration(
                  hintText: '학번을 입력해주세요',
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
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "학번을 입력해주세요";
                  }
                  if (!matchNickname(value.toString())) {
                    return "잘못된 학번입니다";
                  }
                  nickname = value.toString();
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['studentNumber'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력해주세요',
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
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "비밀번호를 입력해주세요";
                  }
                  if (!matchPassword(value.toString()) ||
                      !matchData(value.toString())) {
                    return "잘못된 비밀번호입니다.";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: FormButton(
                  widthSize: MediaQuery.of(context).size.width,
                  disabled: false,
                  text: "Log in",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
