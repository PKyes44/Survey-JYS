import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/authentication/login_screen.dart';
import 'package:survey_jys/authentication/sign_up_screen.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/live_situation.dart';
import 'package:survey_jys/screens/vote_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VoteCheckScreen extends StatefulWidget {
  String? studentNumber;
  String? name;
  String? point;
  VoteCheckScreen({
    super.key,
    required this.studentNumber,
    required this.name,
    required this.point,
  });

  @override
  State<VoteCheckScreen> createState() => _VoteCheckScreenState();
}

class _VoteCheckScreenState extends State<VoteCheckScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController tec = TextEditingController();
  List<dynamic> dodgeBallData = [];
  List<dynamic> finalData = [];
  int searchSchoolNumber = 0;
  bool isCurrentData = false;

  var top1 = 0;
  var top2 = 0;
  var top3 = 0;
  var DBtop1 = 0;
  var DBtop2 = 0;
  var DBtop3 = 0;

  bool showUserDetails = false;

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void onVoteTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MakeQuestionScreen(
          studentNumber: widget.studentNumber,
          name: widget.name,
          point: widget.point,
        ),
      ),
      (route) => false,
    );
  }

  void onVoteCheckTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => VoteCheckScreen(
          studentNumber: widget.studentNumber,
          name: widget.name,
          point: widget.point,
        ),
      ),
      (route) => false,
    );
  }

  void onLiveTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LiveSituation(
          studentNumber: widget.studentNumber,
          name: widget.name,
          point: widget.point,
        ),
      ),
      (route) => false,
    );
  }

  void onSubmit() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        readVoteData();
      }
    }
  }

  void readVoteData() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await reference.child('$searchSchoolNumber').get();

    if (snapshot.value == null) {
      return;
    }
    try {
      final data = snapshot.value as Map<dynamic, dynamic>;
      dodgeBallData = data["dodgeBall"];
      finalData = data["final"];
      if (dodgeBallData.isEmpty && finalData.isEmpty) {
        return;
      } else {
        isCurrentData = true;
      }
      DBtop1 = dodgeBallData[0];
      DBtop2 = dodgeBallData[1];
      DBtop3 = dodgeBallData[2];

      top1 = finalData[0];
      top2 = finalData[1];
      top3 = finalData[2];

      setState(() {});
    } catch (e) {
      return;
    }
  }

  Widget _buildDrawerList() {
    return ListView(children: [
      ListTile(
        leading: const FaIcon(FontAwesomeIcons.checkToSlot),
        iconColor: Theme.of(context).primaryColor,
        focusColor: Theme.of(context).primaryColor,
        title: const Text('투표하기'),
        onTap: onVoteTap,
        trailing: const Icon(Icons.navigate_next),
      ),
      ListTile(
        leading: const FaIcon(FontAwesomeIcons.listCheck),
        iconColor: Theme.of(context).primaryColor,
        focusColor: Theme.of(context).primaryColor,
        title: const Text('투표 확인'),
        onTap: onVoteCheckTap,
        trailing: const Icon(Icons.navigate_next),
      ),
      ListTile(
        leading: const FaIcon(FontAwesomeIcons.satellite),
        iconColor: Theme.of(context).primaryColor,
        focusColor: Theme.of(context).primaryColor,
        title: const Text('실시간 현황'),
        onTap: onLiveTap,
        trailing: const Icon(Icons.navigate_next),
      ),
    ]);
  }

  Widget _buildUserDetail() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: GestureDetector(
            onTap: () {
              logout();
              onLogoutTap();
            },
            child: FormButton(
              disabled: false,
              text: "로그아웃하기",
              widthSize: MediaQuery.of(context).size.width,
            ),
          ),
        )
      ],
    );
  }

  void onLoginTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void onLogoutTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScaffoldTap,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "장영실고등학교 체육대회 승자예측",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          drawer: Drawer(
            child: Column(
              children: [
                (widget.studentNumber != null &&
                        widget.name != null &&
                        widget.point != null)
                    ? UserAccountsDrawerHeader(
                        currentAccountPicture: const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile.png'),
                        ),
                        accountName: Text(
                            '학번 ${widget.studentNumber} / 이름 ${widget.name}'),
                        accountEmail: Text('Point : ${widget.point}'),
                        onDetailsPressed: () {
                          setState(() {
                            showUserDetails = !showUserDetails;
                          });
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: onLoginTap,
                          child: FormButton(
                            disabled: false,
                            text: "회원가입/로그인하기",
                            widthSize: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                Expanded(
                  child:
                      showUserDetails ? _buildUserDetail() : _buildDrawerList(),
                )
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              dodgeBallData = [];
              finalData = [];
              searchSchoolNumber = 0;
              isCurrentData = false;

              top1 = 0;
              top2 = 0;
              top3 = 0;
              DBtop1 = 0;
              DBtop2 = 0;
              DBtop3 = 0;

              tec.text = "";
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size20,
                      vertical: Sizes.size16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "검색할 학생의 학번을 입력해주세요",
                                    style: TextStyle(
                                      fontSize: Sizes.size20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Gaps.v10,
                                  TextFormField(
                                    controller: tec,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.length != 4) {
                                        return "학번을 제대로 입력해주세요";
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      searchSchoolNumber =
                                          int.parse(newValue.toString());
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          Sizes.size10,
                                        ),
                                      ),
                                      labelText: "학번 ex) 3123",
                                      labelStyle: const TextStyle(
                                        fontSize: Sizes.size16,
                                      ),
                                    ),
                                  ),
                                  Gaps.v10,
                                  GestureDetector(
                                    onTap: onSubmit,
                                    child: FormButton(
                                      disabled: false,
                                      text: "검색하기",
                                      widthSize:
                                          MediaQuery.of(context).size.width,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Gaps.v10,
                            isCurrentData
                                ? showData()
                                : const Text("검색어 또는 데이터가 없습니다"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column showData() {
    tec.text = "";
    return Column(
      children: [
        Text(
          "학번 $searchSchoolNumber님의 승자예측 정보",
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: Sizes.size24,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gaps.v10,
        const Text(
          "피구 종목 승자예측",
          style: TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled:
                  DBtop1 == 11 || DBtop2 == 11 || DBtop3 == 11 ? false : true,
              text: '1 - 1',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 12 || DBtop2 == 12 || DBtop3 == 12 ? false : true,
              text: '1 - 2',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 13 || DBtop2 == 13 || DBtop3 == 13 ? false : true,
              text: '1 - 3',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 14 || DBtop2 == 14 || DBtop3 == 14 ? false : true,
              text: '1 - 4',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled:
                  DBtop1 == 15 || DBtop2 == 15 || DBtop3 == 15 ? false : true,
              text: '1 - 5',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 16 || DBtop2 == 16 || DBtop3 == 16 ? false : true,
              text: '1 - 6',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 17 || DBtop2 == 17 || DBtop3 == 17 ? false : true,
              text: '1 - 7',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 18 || DBtop2 == 18 || DBtop3 == 18 ? false : true,
              text: '1 - 8',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled:
                  DBtop1 == 21 || DBtop2 == 21 || DBtop3 == 21 ? false : true,
              text: '2 - 1',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 22 || DBtop2 == 22 || DBtop3 == 22 ? false : true,
              text: '2 - 2',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 23 || DBtop2 == 23 || DBtop3 == 23 ? false : true,
              text: '2 - 3',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 24 || DBtop2 == 24 || DBtop3 == 24 ? false : true,
              text: '2 - 4',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled:
                  DBtop1 == 25 || DBtop2 == 25 || DBtop3 == 25 ? false : true,
              text: '2 - 5',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 26 || DBtop2 == 26 || DBtop3 == 26 ? false : true,
              text: '2 - 6',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 27 || DBtop2 == 27 || DBtop3 == 27 ? false : true,
              text: '2 - 7',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 28 || DBtop2 == 28 || DBtop3 == 28 ? false : true,
              text: '2 - 8',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled:
                  DBtop1 == 31 || DBtop2 == 31 || DBtop3 == 31 ? false : true,
              text: '3 - 1',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 32 || DBtop2 == 32 || DBtop3 == 32 ? false : true,
              text: '3 - 2',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 33 || DBtop2 == 33 || DBtop3 == 33 ? false : true,
              text: '3 - 3',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 34 || DBtop2 == 34 || DBtop3 == 34 ? false : true,
              text: '3 - 4',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled:
                  DBtop1 == 35 || DBtop2 == 35 || DBtop3 == 35 ? false : true,
              text: '3 - 5',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 36 || DBtop2 == 36 || DBtop3 == 36 ? false : true,
              text: '3 - 6',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 37 || DBtop2 == 37 || DBtop3 == 37 ? false : true,
              text: '3 - 7',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled:
                  DBtop1 == 38 || DBtop2 == 38 || DBtop3 == 38 ? false : true,
              text: '3 - 8',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v16,
        const Text(
          "최종 승자 예측",
          style: TextStyle(
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled: top1 == 11 || top2 == 11 || top3 == 11 ? false : true,
              text: '1 - 1',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 12 || top2 == 12 || top3 == 12 ? false : true,
              text: '1 - 2',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 13 || top2 == 13 || top3 == 13 ? false : true,
              text: '1 - 3',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 14 || top2 == 14 || top3 == 14 ? false : true,
              text: '1 - 4',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled: top1 == 15 || top2 == 15 || top3 == 15 ? false : true,
              text: '1 - 5',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 16 || top2 == 16 || top3 == 16 ? false : true,
              text: '1 - 6',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 17 || top2 == 17 || top3 == 17 ? false : true,
              text: '1 - 7',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 18 || top2 == 18 || top3 == 18 ? false : true,
              text: '1 - 8',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled: top1 == 21 || top2 == 21 || top3 == 21 ? false : true,
              text: '2 - 1',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 22 || top2 == 22 || top3 == 22 ? false : true,
              text: '2 - 2',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 23 || top2 == 23 || top3 == 23 ? false : true,
              text: '2 - 3',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 24 || top2 == 24 || top3 == 24 ? false : true,
              text: '2 - 4',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled: top1 == 25 || top2 == 25 || top3 == 25 ? false : true,
              text: '2 - 5',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 26 || top2 == 26 || top3 == 26 ? false : true,
              text: '2 - 6',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 27 || top2 == 27 || top3 == 27 ? false : true,
              text: '2 - 7',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 28 || top2 == 28 || top3 == 28 ? false : true,
              text: '2 - 8',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled: top1 == 31 || top2 == 31 || top3 == 31 ? false : true,
              text: '3 - 1',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 32 || top2 == 32 || top3 == 32 ? false : true,
              text: '3 - 2',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 33 || top2 == 33 || top3 == 33 ? false : true,
              text: '3 - 3',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 34 || top2 == 34 || top3 == 34 ? false : true,
              text: '3 - 4',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
        Gaps.v10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FormButton(
              disabled: top1 == 35 || top2 == 35 || top3 == 35 ? false : true,
              text: '3 - 5',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 36 || top2 == 36 || top3 == 36 ? false : true,
              text: '3 - 6',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 37 || top2 == 37 || top3 == 37 ? false : true,
              text: '3 - 7',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
            FormButton(
              disabled: top1 == 38 || top2 == 38 || top3 == 38 ? false : true,
              text: '3 - 8',
              widthSize: (MediaQuery.of(context).size.width - 60) / 4,
            ),
          ],
        ),
      ],
    );
  }
}
