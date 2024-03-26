import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:survey_jys/authentication/login_screen.dart';
import 'package:survey_jys/authentication/sign_up_screen.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/bet_screen.dart';
import 'package:survey_jys/screens/history_screen.dart';
import 'package:survey_jys/screens/live_situation.dart';
import 'package:survey_jys/screens/vote_check_screen.dart';
import 'package:survey_jys/screens/vote_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankScreen extends StatefulWidget {
  String? studentNumber;
  String? name;
  String? point;
  RankScreen({
    super.key,
    required this.studentNumber,
    required this.name,
    required this.point,
  });

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  bool showUserDetails = false;
  bool isLogined = false;

  List<dynamic> imageUrls = [
    'assets/images/1stMedal.png',
    'assets/images/2ndMedal.png',
    'assets/images/3rdMedal.png',
  ];

  Map<dynamic, dynamic> playerData = {};

  int playerIndex = 0;
  List<String> playerList = [];

  void readPlayerData() async {
    final reference = FirebaseDatabase.instance.ref();

    DataSnapshot snapshot = await reference.child('user/').get();
    if (snapshot.value == null) {
      return;
    }
    playerData = snapshot.value as Map<dynamic, dynamic>;
    for (var player in playerData.keys) {
      playerIndex++;
      playerList.add(player);
    }
    quickSort(playerList, playerData, 0, playerList.length - 1);
    setState(() {});
    print('playerList: $playerList');
  }

  void quickSort(
      List<String> arr, Map<dynamic, dynamic> map, int low, int high) {
    if (low < high) {
      int pivotIndex = partition(arr, map, low, high);

      quickSort(arr, map, low, pivotIndex - 1);
      quickSort(arr, map, pivotIndex + 1, high);
    }
  }

  int partition(
      List<String> arr, Map<dynamic, dynamic> map, int low, int high) {
    String pivotKey = arr[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (map[arr[j]]!['point']! > map[pivotKey]!['point']!) {
        i++;
        swap(arr, i, j);
      }
    }

    swap(arr, i + 1, high);
    return i + 1;
  }

  void swap(List<String> arr, int i, int j) {
    String temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
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
    readPlayerData();
    super.initState();
    getPoint();
    if (widget.studentNumber != null &&
        widget.name != null &&
        widget.point != null) {
      isLogined = true;
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScaffoldTap,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "포인트 랭킹",
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
              getPoint();
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Gaps.v16,
                        const Text(
                          "전교생 TOP 3",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gaps.v12,
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Row(
                            children: [
                              for (int i = 0; i < 3; i++) showRank(i),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "내 랭킹 ",
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Text(
                              '${playerList.indexOf(widget.studentNumber!) + 1}',
                              style: TextStyle(
                                fontSize: Sizes.size16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const Text(
                              "등",
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Gaps.h32,
                            const Text(
                              "내 포인트",
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Text(
                              " ${widget.point}",
                              style: TextStyle(
                                fontSize: Sizes.size16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const Text(
                              "P",
                              style: TextStyle(
                                fontSize: Sizes.size16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  Column(
                    children: [
                      for (int i = 3; i < playerList.length; i++)
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size14,
                              vertical: Sizes.size14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: Sizes.size1,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${i + 1}위",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${playerList[i]} ${playerData[playerList[i]]['name']}",
                                      style: const TextStyle(
                                        fontSize: Sizes.size16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${playerData[playerList[i]]['point']}P",
                                    style: const TextStyle(
                                      color: Color(0xffFFB359),
                                      fontWeight: FontWeight.w700,
                                    ),
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
      ),
    );
  }

  Flexible showRank(int i) {
    if (i > playerList.length - 1) {
      return Flexible(
        child: Container(),
      );
    }
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Column(
        children: [
          Image.asset(
            imageUrls[i],
          ),
          Row(
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        playerList[i],
                        style: const TextStyle(
                          color: Color(0xffFF7986),
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size16 + Sizes.size2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        playerData[playerList[i]]['name'],
                        style: const TextStyle(
                          fontSize: Sizes.size16 + Sizes.size2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Text(
                  '${playerData[playerList[i]]['point'].toString()}P',
                  style: const TextStyle(
                    color: Color(0xffFFB359),
                    fontWeight: FontWeight.w500,
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
