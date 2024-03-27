// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/authentication/login_screen.dart';
import 'package:survey_jys/authentication/sign_up_screen.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/history_screen.dart';
import 'package:survey_jys/screens/live_situation.dart';
import 'package:survey_jys/screens/rank_screen.dart';
import 'package:survey_jys/screens/vote_check_screen.dart';
import 'package:survey_jys/screens/vote_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BetScreen extends StatefulWidget {
  String? studentNumber;
  String? name;
  String? point;
  BetScreen({
    super.key,
    required this.studentNumber,
    required this.name,
    required this.point,
  });

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  final TextEditingController _bettingPoint1Controller =
      TextEditingController();
  final TextEditingController _bettingPoint2Controller =
      TextEditingController();
  final TextEditingController _bettingPoint3Controller =
      TextEditingController();
  bool showUserDetails = false;
  bool isLogined = false;

  Map<dynamic, dynamic> gameData = {};
  Map<dynamic, dynamic> teamData = {};
  Map<dynamic, dynamic> betData = {};
  Map<dynamic, dynamic> isGameOverData = {};

  int _bettingPoint1 = 0;
  int _bettingPoint2 = 0;
  int _bettingPoint3 = 0;

  var top1 = 0;
  var top2 = 0;
  var top3 = 0;
  List<int> topList = [];

  bool isBetPointError = false;
  bool isBetError = false;
  bool isGameOver = false;

  void readBetData() async {
    final reference = FirebaseDatabase.instance.ref();

    DataSnapshot snapshot = await reference.child('game/').get();
    if (snapshot.value == null) {
      return;
    }
    gameData = snapshot.value as Map<dynamic, dynamic>;

    snapshot = await reference.child('team/').get();
    if (snapshot.value == null) {
      return;
    }
    teamData = snapshot.value as Map<dynamic, dynamic>;
    setState(() {});

    try {
      snapshot =
          await reference.child('user/${widget.studentNumber}/bet').get();
      betData = snapshot.value as Map<dynamic, dynamic>;
      setState(() {});
    } catch (e) {
      setState(() {});
      return;
    }
    return;
  }

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
    if (widget.studentNumber != null &&
        widget.name != null &&
        widget.point != null) {
      isLogined = true;
    }

    readBetData();

    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('isGameOver/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      isGameOverData = data as Map<dynamic, dynamic>;
      setState(() {});
    });

    starCountRef =
        FirebaseDatabase.instance.ref('user/${widget.studentNumber}/bet/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      betData = data as Map<dynamic, dynamic>;
      setState(() {});
    });

    starCountRef =
        FirebaseDatabase.instance.ref('user/${widget.studentNumber}/point');
    starCountRef.onValue.listen((DatabaseEvent event) {
      widget.point = event.snapshot.value.toString();
      setState(() {});
    });

    _bettingPoint1Controller.addListener(() {
      if (_bettingPoint1Controller.text.isEmpty) {
        return;
      }
      setState(() {
        _bettingPoint1 = int.parse(_bettingPoint1Controller.text);
      });
    });
    _bettingPoint2Controller.addListener(() {
      if (_bettingPoint2Controller.text.isEmpty) {
        return;
      }
      setState(() {
        _bettingPoint2 = int.parse(_bettingPoint2Controller.text);
      });
    });
    _bettingPoint3Controller.addListener(() {
      if (_bettingPoint3Controller.text.isEmpty) {
        return;
      }
      setState(() {
        _bettingPoint3 = int.parse(_bettingPoint3Controller.text);
      });
    });
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
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

  void onLoginTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SignUpScreen(),
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
          title: const Text(
            'BIG이벤트 투표하기',
            style: TextStyle(
              fontFamily: 'NanumSquare',
            ),
          ),
          onTap: onVoteTap,
          trailing: const Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.listCheck),
          iconColor: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          title: const Text(
            'BIG이벤트 투표 확인',
            style: TextStyle(
              fontFamily: 'NanumSquare',
            ),
          ),
          onTap: onVoteCheckTap,
          trailing: const Icon(Icons.navigate_next),
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.satellite),
          iconColor: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          title: const Text(
            'BIG이벤트 투표 현황',
            style: TextStyle(
              fontFamily: 'NanumSquare',
            ),
          ),
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
              fontFamily: 'NanumSquare',
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
              fontFamily: 'NanumSquare',
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
              fontFamily: 'NanumSquare',
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

  int getWinningOdd({
    required String player,
    required var classNum,
  }) {
    try {
      int win = teamData[player][classNum]['win'];
      int lose = teamData[player][classNum]['lose'];

      double winningOdd = (win / (win + lose)) * 100;
      return winningOdd.floor();
    } catch (e) {
      return 0;
    }
  }

  void clickedClass({
    required var player,
    required var classNum,
    required StateSetter setDialog,
  }) {
    if (topList.contains(classNum)) {
      print("ClassNum: $classNum");
      print(topList);
      if (top3 == classNum) {
        top3 = 0;
      } else if (top2 == classNum) {
        top2 = 0;
      } else if (top1 == classNum) {
        top1 = 0;
      }
    } else if (top1 == 0 || (top2 != 0 && top3 != 0)) {
      top1 = classNum;
      print("top1: $top1");
    } else if (top2 == 0 || (top3 != 0 && top1 != 0)) {
      top2 = classNum;
      print("top2: $top2");
    } else if (top3 == 0 || (top1 != 0 && top3 != 0)) {
      top3 = classNum;
      print("top2: $top3");
    }
    topList = [top1, top2, top3];
    setDialog(() {});
    print("top1 = $top1\ntop2 = $top2\ntop3 = $top3");
  }

  Column showTeams({
    required StateSetter state,
    required int classNum,
    required String player,
  }) {
    bool disabled = true;
    if (top1 == classNum || top2 == classNum || top3 == classNum) {
      disabled = false;
    } else {
      disabled = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => clickedClass(
            classNum: classNum,
            player: player,
            setDialog: state,
          ),
          child: SizedBox(
            width: (MediaQuery.of(context).size.width - 60) / 5,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  Sizes.size5,
                ),
                color: disabled
                    ? Colors.grey.shade300
                    : Theme.of(context).primaryColor,
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(microseconds: 300),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: disabled ? Colors.grey.shade400 : Colors.white,
                ),
                child: Text(
                  '$classNum반',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Gaps.v4,
        Text(
          "${(teamData[player][classNum]['lose'] + teamData[player][classNum]['win'])}전 ${teamData[player][classNum]['win']}승 ${teamData[player][classNum]['lose']}패",
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: Sizes.size12,
          ),
        ),
        Gaps.v4,
        Text(
          "승률 ${getWinningOdd(player: player, classNum: classNum)}%",
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: Sizes.size12,
          ),
        ),
        Gaps.v16,
      ],
    );
  }

  bool bettingPointValid() {
    if (_bettingPoint1 + _bettingPoint2 + _bettingPoint3 >
        int.parse(widget.point!)) {
      return false;
    }
    return true;
  }

  String? isBettingValid(int value) {
    if (_bettingPoint1 + _bettingPoint2 + _bettingPoint3 >
        int.parse(widget.point!)) {
      if (value == 0) {
        return null;
      }
      return "현재 가진 포인트를 초과할 수 없습니다";
    }
    return null;
  }

  Column setBetSheet({
    required StateSetter setDialog,
    required String player,
    required var top,
  }) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 16,
          width: (MediaQuery.of(context).size.width - 60) / 5,
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 300,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Sizes.size5,
              ),
              color: (top == 0)
                  ? Colors.grey.shade300
                  : Theme.of(context).primaryColor,
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(microseconds: 300),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: (top == 0) ? Colors.grey.shade400 : Colors.white,
              ),
              child: Text(
                (top == 0) ? "미선택" : "${top.toString()}반",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onBetModalTap({
    required var game,
    required var player,
  }) {
    _bettingPoint1 = 0;
    _bettingPoint2 = 0;
    _bettingPoint3 = 0;

    setState(() {});

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (
          BuildContext context,
          StateSetter setDialog,
        ) {
          return Dialog(
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gaps.v10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          game,
                          style: const TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      player,
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.v4,
                    const Text(
                      "최대 3팀까지 선택할 수 있습니다",
                      style: TextStyle(
                          fontSize: Sizes.size12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                      textAlign: TextAlign.start,
                    ),
                    Gaps.v10,
                    for (int row = 0; row < 2; row++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int classNum = 1; classNum < 5; classNum++)
                            showTeams(
                              player: player,
                              classNum: classNum + (row * 4),
                              state: setDialog,
                            ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          setBetSheet(
                            top: top1,
                            player: player,
                            setDialog: setDialog,
                          ),
                          Gaps.h10,
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSaved: (newValue) {
                                if (newValue == null || newValue.isEmpty) {
                                  return;
                                }
                                _bettingPoint1 = int.parse(newValue);
                                setDialog(() {});
                                setState(() {});
                              },
                              validator: (value) {
                                if (int.parse(value!) >
                                    int.parse(widget.point!)) {
                                  return "현재 가진 포인트를 초과할 수 없습니다";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: _bettingPoint1Controller,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                errorText: isBettingValid(
                                  _bettingPoint1,
                                ),
                                hintText: "베팅 포인트 입력",
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          setBetSheet(
                            top: top2,
                            player: player,
                            setDialog: setDialog,
                          ),
                          Gaps.h10,
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSaved: (newValue) {
                                if (newValue == null || newValue.isEmpty) {
                                  return;
                                }
                                _bettingPoint1 = int.parse(newValue);
                                setDialog(() {});
                                setState(() {});
                              },
                              validator: (value) {
                                if (int.parse(value!) >
                                    int.parse(widget.point!)) {
                                  return "현재 가진 포인트를 초과할 수 없습니다";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: _bettingPoint2Controller,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                errorText: isBettingValid(
                                  _bettingPoint2,
                                ),
                                hintText: "베팅 포인트 입력",
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          setBetSheet(
                            top: top3,
                            player: player,
                            setDialog: setDialog,
                          ),
                          Gaps.h10,
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSaved: (newValue) {
                                if (newValue == null || newValue.isEmpty) {
                                  return;
                                }
                                _bettingPoint1 = int.parse(newValue);
                                setDialog(() {});
                                setState(() {});
                              },
                              validator: (value) {
                                if (int.parse(value!) >
                                    int.parse(widget.point!)) {
                                  return "현재 가진 포인트를 초과할 수 없습니다";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: _bettingPoint3Controller,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                errorText: isBettingValid(
                                  _bettingPoint3,
                                ),
                                hintText: "베팅 포인트 입력",
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
                          ),
                        ],
                      ),
                    ),
                    Gaps.v10,
                    Text("현재 포인트 : ${widget.point}"),
                    Text(
                      "베팅 후 잔여 포인트 : ${int.parse(widget.point!) - _bettingPoint1 - _bettingPoint2 - _bettingPoint3}",
                    ),
                    isBetError
                        ? Text(
                            '※ 최소 한 팀 이상 선택해주세요',
                            style: TextStyle(
                              color: Colors.red.shade800,
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    isBetPointError
                        ? Text(
                            '※ 선택한 팀에 포인트를 베팅해주세요',
                            style: TextStyle(
                              color: Colors.red.shade800,
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        bottom: 15.0,
                        top: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              top1 = 0;
                              top2 = 0;
                              top3 = 0;
                              topList = [];
                              _bettingPoint1 = 0;
                              _bettingPoint2 = 0;
                              _bettingPoint3 = 0;
                              _bettingPoint1Controller.text = "";
                              _bettingPoint2Controller.text = "";
                              _bettingPoint3Controller.text = "";
                              isBetError = false;
                              isGameOver = false;
                              isBetPointError = false;
                              Navigator.of(context).pop();
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 300,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size16,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.size5,
                                    ),
                                    color: Colors.grey.shade300),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(microseconds: 300),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade400,
                                  ),
                                  child: const Text(
                                    "취소",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onBettingTap(
                              setDialog: setDialog,
                              game: game,
                              player: player,
                            ),
                            child: FormButton(
                              disabled: false,
                              text: "베팅하기",
                              widthSize:
                                  MediaQuery.of(context).size.width / 3.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onBettingTap({
    required var game,
    required var player,
    required StateSetter setDialog,
  }) {
    if ((top1 == 0 && _bettingPoint1 == 0) &&
        (top2 == 0 && _bettingPoint2 == 0) &&
        (top3 == 0 && _bettingPoint3 == 0)) {
      isBetError = true;
      setState(() {});
      setDialog(() {});
      return;
    } else {
      isBetError = false;
      setState(() {});
      setDialog(() {});
    }

    if ((top1 != 0 && _bettingPoint1 == 0) ||
        (top2 != 0 && _bettingPoint2 == 0) ||
        (top3 != 0 && _bettingPoint3 == 0)) {
      isBetPointError = true;
      setDialog(() {});
      setState(() {});
      return;
    } else {
      isBetPointError = false;
      setDialog(() {});
      setState(() {});
    }
    if (!bettingPointValid()) {
      return;
    }

    betDataSave(game: game, player: player, setDialog: setDialog);

    top1 = 0;
    top2 = 0;
    top3 = 0;
    topList = [];
    _bettingPoint1 = 0;
    _bettingPoint2 = 0;
    _bettingPoint3 = 0;
    _bettingPoint1Controller.text = "";
    _bettingPoint2Controller.text = "";
    _bettingPoint3Controller.text = "";
    isBetError = false;
    isBetPointError = false;

    Navigator.pop(context);
  }

  void betDataSave({
    required var game,
    required var player,
    required StateSetter setDialog,
  }) async {
    var playerInner = {
      "$top1반": _bettingPoint1,
      "$top2반": _bettingPoint2,
      "$top3반": _bettingPoint3,
    };

    FirebaseDatabase ref = FirebaseDatabase.instance;
    await ref
        .ref()
        .child('user/${widget.studentNumber}/bet/$game/$player')
        .set(playerInner);

    await ref.ref().child('user/${widget.studentNumber}/point').set(
        int.parse(widget.point!) -
            _bettingPoint1 -
            _bettingPoint2 -
            _bettingPoint3);  
  }

  Column showGames({
    required var game,
    required var player,
  }) {
    print("game: $game\nplayer: $player");

    bool isBet = false;
    try {
      if (betData[game][player] != null) {
        isBet = true;
      } else {
        isBet = false;
      }
    } catch (e) {
      isBet = false;
    }

    try {
      if (isGameOverData[game][player]['isOver'] == true) {
        isGameOver = true;
      } else {
        isGameOver = false;
      }
    } catch (e) {
      isGameOver = false;
    }

    setState(() {});

    return Column(
      children: [
        GestureDetector(
          onTap: isGameOver
              ? () {}
              : isBet
                  ? () {}
                  : () => onBetModalTap(
                        game: game,
                        player: player,
                      ),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size14,
                vertical: Sizes.size14,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: Sizes.size1,
                ),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            game,
                            style: const TextStyle(
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            player,
                            style: const TextStyle(
                                fontSize: Sizes.size12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width / 4,
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Sizes.size5,
                            ),
                            color: isGameOver
                                ? Colors.black
                                : isBet
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isGameOver
                                    ? "게임 종료"
                                    : isBet
                                        ? '베팅 완료'
                                        : "미참여",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Gaps.v10,
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
            backgroundColor: const Color(0xffFF5959),
            title: const Text(
              "세부종목 베팅",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w500,
                fontFamily: 'JalnanGothic',
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
              readBetData();

              getPoint();
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size20,
                      vertical: Sizes.size16,
                    ),
                    child: Column(
                      children: [
                        for (var game in gameData.keys)
                          for (var player in gameData[game].keys)
                            showGames(game: game, player: player),
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
