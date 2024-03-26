// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/authentication/login_screen.dart';
import 'package:survey_jys/authentication/sign_up_screen.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/bet_screen.dart';
import 'package:survey_jys/screens/history_screen.dart';
import 'package:survey_jys/screens/live_situation.dart';
import 'package:survey_jys/screens/rank_screen.dart';
import 'package:survey_jys/screens/vote_check_screen.dart';
import 'package:survey_jys/screens/vote_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BetHistoryScreen extends StatefulWidget {
  String? studentNumber;
  String? name;
  String? point;
  BetHistoryScreen({
    super.key,
    required this.studentNumber,
    required this.name,
    required this.point,
  });

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  bool showUserDetails = false;
  bool isLogined = false;

  Map<dynamic, dynamic> gameData = {};
  Map<dynamic, dynamic> teamData = {};
  Map<dynamic, dynamic> betData = {};

  List<int> topList = [];
  List<int> betPointList = [];

  void readBetData() async {
    final reference = FirebaseDatabase.instance.ref();

    DataSnapshot snapshot = await reference.child('game/').get();
    if (snapshot.value == null) {
      return;
    }
    gameData = snapshot.value as Map<dynamic, dynamic>;

    try {
      snapshot =
          await reference.child('user/${widget.studentNumber}/bet').get();
      betData = snapshot.value as Map<dynamic, dynamic>;
    } catch (e) {
      setState(() {});
      return;
    }
    setState(() {});
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

  Column showTeams({
    required StateSetter state,
    required String game,
    required int classNum,
    required String player,
  }) {
    bool disabled = true;
    if (betData[game][player].containsKey(classNum.toString())) {
      disabled = false;
    } else {
      disabled = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
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
        Gaps.v16,
      ],
    );
  }

  Column setBetSheet({
    required StateSetter setDialog,
    required String player,
    required var top,
    required int point,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  color: (top == null)
                      ? Colors.grey.shade300
                      : Theme.of(context).primaryColor,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(microseconds: 300),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: (top == null) ? Colors.grey.shade400 : Colors.white,
                  ),
                  child: Text(
                    (top == null) ? "미선택" : "${top.toString()}반",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Gaps.h10,
            Text(
              "$point Point",
              style: const TextStyle(
                fontSize: Sizes.size16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void onBetModalTap({
    required var game,
    required var player,
  }) {
    for (var betClass in betData[game][player].keys) {
      if (betData[game][player][betClass] <= 0) {
        continue;
      } else {
        topList.add(int.parse(betClass.substring(0, 1)));
        betPointList.add(betData[game][player][betClass]);
      }
    }

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
                              game: game,
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
                            top: topList[0],
                            point: betPointList[0],
                            player: player,
                            setDialog: setDialog,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          (topList.length >= 2)
                              ? setBetSheet(
                                  top: topList[1],
                                  point: betPointList[1],
                                  player: player,
                                  setDialog: setDialog,
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          (topList.length >= 3)
                              ? setBetSheet(
                                  top: topList[2],
                                  point: betPointList[2],
                                  player: player,
                                  setDialog: setDialog,
                                )
                              : const SizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                    Text(
                      "현재 포인트 : ${widget.point}",
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.v16,
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        bottom: 15.0,
                        top: 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          topList = [];
                          betPointList = [];
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: FormButton(
                          disabled: false,
                          text: "확인",
                          widthSize: MediaQuery.of(context).size.width,
                        ),
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

    return Column(
      children: [
        GestureDetector(
          onTap: isBet
              ? () => onBetModalTap(
                    game: game,
                    player: player,
                  )
              : () {},
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
                            color: isBet
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isBet ? '전적 보기' : "미참여",
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
            title: const Text(
              "내 베팅 내역 확인",
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
