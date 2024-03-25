import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/authentication/login_screen.dart';
import 'package:survey_jys/authentication/sign_up_screen.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/bet_screen.dart';
import 'package:survey_jys/screens/history_screen.dart';
import 'package:survey_jys/screens/rank_screen.dart';
import 'package:survey_jys/screens/vote_check_screen.dart';
import 'package:survey_jys/screens/vote_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';

class LiveSituation extends StatefulWidget {
  String? studentNumber;
  String? name;
  String? point;
  LiveSituation({
    super.key,
    required this.studentNumber,
    required this.name,
    required this.point,
  });

  @override
  State<LiveSituation> createState() => _LiveSituationState();
}

class _LiveSituationState extends State<LiveSituation> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showUserDetails = false;

  void getPoint() async {
    final reference = FirebaseDatabase.instance.ref();

    DataSnapshot snapshot =
        await reference.child('user/${widget.studentNumber}/point').get();
    widget.point = snapshot.value.toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPoint();
    reset();
    readVoteData();

    if (widget.studentNumber != null &&
        widget.name != null &&
        widget.point != null) {
      isLogined = true;
    }
  }

  Map<int, int> dodgeBallData = {};
  Map<int, int> finalData = {};
  void reset() {
    
              getPoint();
    dodgeBallData = {
      11: 0,
      12: 0,
      13: 0,
      14: 0,
      15: 0,
      16: 0,
      17: 0,
      18: 0,
      21: 0,
      22: 0,
      23: 0,
      24: 0,
      25: 0,
      26: 0,
      27: 0,
      28: 0,
      31: 0,
      32: 0,
      33: 0,
      34: 0,
      35: 0,
      36: 0,
      37: 0,
      38: 0,
    };
    finalData = {
      11: 0,
      12: 0,
      13: 0,
      14: 0,
      15: 0,
      16: 0,
      17: 0,
      18: 0,
      21: 0,
      22: 0,
      23: 0,
      24: 0,
      25: 0,
      26: 0,
      27: 0,
      28: 0,
      31: 0,
      32: 0,
      33: 0,
      34: 0,
      35: 0,
      36: 0,
      37: 0,
      38: 0,
    };
    setState(() {});
  }

  bool isLogined = false;

  void onSubmit() {
    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
      }
    }
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
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

  void readVoteData() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await reference.child('').get();

    var data = snapshot.value as Map<dynamic, dynamic>;
    for (var key in data.keys) {
      if (key == 'user' || key == 'game' || key == 'team') {
        continue;
      }
      var value = data[key];
      for (int i = 0; i < 3; i++) {
        if (int.parse(key.substring(0, 1)) > 3) {
          continue;
        }
        if (int.parse(key.substring(1, 2)) < 1 ||
            int.parse(key.substring(1, 2)) > 8) {
          continue;
        }
        if (int.parse(key.substring(2, 4)) < 0 ||
            int.parse(key.substring(2, 4)) > 20) {
          continue;
        }
        dodgeBallData[int.parse(value['dodgeBall'][i].toString())] =
            dodgeBallData[int.parse(value['dodgeBall'][i].toString())]! +
                int.parse(
                  value['dodgeBall'][i].toString(),
                );
        finalData[int.parse(value['final'][i].toString())] =
            finalData[value['final'][i]]! +
                int.parse(
                  value['final'][i].toString(),
                );
      }
    }
    print("dodgeBallData: $dodgeBallData\nfinalData: $finalData");
    setState(() {});
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

  void onLoginTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SignUpScreen(),
      ),
      (route) => false,
    );
  }

  void onBetHistoryTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BetHistoryScreen(
          studentNumber: widget.studentNumber,
          name: widget.name,
          point: widget.point,
        ),
      ),
      (route) => false,
    );
  }

  void onBetTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BetScreen(
          studentNumber: widget.studentNumber,
          name: widget.name,
          point: widget.point,
        ),
      ),
      (route) => false,
    );
  }

  void onRankTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RankScreen(
          studentNumber: widget.studentNumber,
          name: widget.name,
          point: widget.point,
        ),
      ),
      (route) => false,
    );
  }

  void onLockedTap() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gaps.v20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "비회원은 ",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "사용할 수 없는 기능",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "입니다",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Gaps.v40,
              const Text(
                textAlign: TextAlign.start,
                "계정을 만들고 싶다면 ? ",
                style: TextStyle(
                  fontSize: Sizes.size14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  bottom: 15.0,
                  top: 10,
                ),
                child: GestureDetector(
                  onTap: onLoginTap,
                  child: FormButton(
                    disabled: false,
                    text: "회원가입/로그인하기",
                    widthSize: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerList() {
    return ListView(
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.checkToSlot),
          iconColor: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          title: const Text('BIG이벤트 투표하기'),
          onTap: onVoteTap,
          trailing: const Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.listCheck),
          iconColor: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          title: const Text('BIG이벤트 투표 확인'),
          onTap: onVoteCheckTap,
          trailing: const Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.satellite),
          iconColor: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          title: const Text('BIG이벤트 투표 현황'),
          onTap: onLiveTap,
          trailing: const Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.checkToSlot),
          trailing: isLogined
              ? const Icon(Icons.navigate_next)
              : const FaIcon(FontAwesomeIcons.lock, size: Sizes.size20),
          iconColor: isLogined ? Theme.of(context).primaryColor : Colors.grey,
          focusColor: Theme.of(context).primaryColor,
          title: Text(
            '세부종목 베팅하기',
            style: TextStyle(
              color: isLogined ? Colors.black : Colors.grey,
            ),
          ),
          onTap: isLogined ? onBetTap : onLockedTap,
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.folderOpen),
          trailing: isLogined
              ? const Icon(Icons.navigate_next)
              : const FaIcon(FontAwesomeIcons.lock, size: Sizes.size20),
          iconColor: isLogined ? Theme.of(context).primaryColor : Colors.grey,
          focusColor: Theme.of(context).primaryColor,
          title: Text(
            '베팅 내역 보기',
            style: TextStyle(
              color: isLogined ? Colors.black : Colors.grey,
            ),
          ),
          onTap: isLogined ? onBetHistoryTap : onLockedTap,
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.rankingStar),
          trailing: isLogined
              ? const Icon(Icons.navigate_next)
              : const FaIcon(FontAwesomeIcons.lock, size: Sizes.size20),
          iconColor: isLogined ? Theme.of(context).primaryColor : Colors.grey,
          focusColor: Theme.of(context).primaryColor,
          title: Text(
            '포인트 랭킹 현황',
            style: TextStyle(
              color: isLogined ? Colors.black : Colors.grey,
            ),
          ),
          onTap: isLogined ? onRankTap : onLockedTap,
        ),
      ],
    );
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

              reset();
              readVoteData();
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "반별 투표 현황",
                                  style: TextStyle(
                                    fontSize: Sizes.size20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                DataTable(
                                  columns: const [
                                    DataColumn(
                                      label: Expanded(
                                        child: Text("Class"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text("피구"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text("최종"),
                                      ),
                                    ),
                                  ],
                                  rows: [
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-1"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[11]! / 11).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[11]! / 11).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-2"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[12]! / 12).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[12]! / 12).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-3"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[13]! / 13).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[13]! / 13).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-4"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[14]! / 14).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[14]! / 14).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-5"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[15]! / 15).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[15]! / 15).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-6"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[16]! / 16).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[16]! / 16).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-7"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[17]! / 17).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[17]! / 17).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("1-8"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[18]! / 18).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[18]! / 18).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-1"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[21]! / 21).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[21]! / 21).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-2"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[22]! / 22).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[22]! / 22).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-3"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[23]! / 23).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[23]! / 23).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-4"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[24]! / 24).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[24]! / 24).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-5"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[25]! / 25).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[25]! / 25).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-6"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[26]! / 26).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[26]! / 26).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-7"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[27]! / 27).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[27]! / 27).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("2-8"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[28]! / 28).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[28]! / 28).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-1"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[31]! / 31).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[31]! / 31).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-2"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[32]! / 32).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[32]! / 32).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-3"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[33]! / 33).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[33]! / 33).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-4"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[34]! / 34).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[34]! / 34).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-5"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[35]! / 35).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[35]! / 35).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-6"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[36]! / 36).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[36]! / 36).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-7"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[37]! / 37).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[37]! / 37).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        const DataCell(
                                          Text("3-8"),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(dodgeBallData[38]! / 38).floor()}",
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            "${(finalData[38]! / 38).floor()}",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
}
