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

  List<dynamic> players = [
    {
      'name': 'u1',
      'point': '1000',
    },
    {
      'name': 'u2',
      'point': '1000',
    },
    {
      'name': 'u3',
      'point': '1000',
    },
    {
      'name': 'u4',
      'point': '1000',
    },
    {
      'name': 'u5',
      'point': '1000',
    },
    {
      'name': 'u6',
      'point': '1000',
    },
    {
      'name': 'u7',
      'point': '1000',
    },
    {
      'name': 'u8',
      'point': '1000',
    },
    {
      'name': 'u9',
      'point': '1000',
    },
    {
      'name': 'u10',
      'point': '1000',
    },
    {
      'name': 'u11',
      'point': '1000',
    },
    {
      'name': 'u12',
      'point': '1000',
    },
    {
      'name': 'u13',
      'point': '1000',
    },
    {
      'name': 'u14',
      'point': '1000',
    },
    {
      'name': 'u15',
      'point': '1000',
    },
  ];

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
                  Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xffFF7986),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/profile.png',
                          scale: Sizes.size2,
                        ),
                        Gaps.v10,
                        const Text(
                          "1000 points",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.size24,
                          ),
                        ),
                        Gaps.v12,
                        // const Text(
                        //   "1위",
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: Sizes.size16,
                        //     color: Colors.yellowAccent,
                        //   ),
                        // ),
                        // Icon(Ico)
                        const Text(
                          "3213 양은석",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.size20,
                          ),
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

// class RankScreen extends StatefulWidget {
//   String? studentNumber;
//   String? name;
//   String? point;
//   RankScreen({
//     super.key,
//     required this.studentNumber,
//     required this.name,
//     required this.point,
//   });

//   @override
//   _RankScreenState createState() => _RankScreenState();
// }

// class _RankScreenState extends State<RankScreen> {
//   List<String> users = [
//     'User 1',
//     'User 2',
//     'User 3',
//     'User 4', 'User 1',
//     'User 2',
//     'User 3',
//     'User 4', 'User 1',
//     'User 2',
//     'User 3',
//     'User 4', 'User 1',
//     'User 2',
//     'User 3',
//     'User 4', 'User 1',
//     'User 2',
//     'User 3',
//     'User 4', 'User 1',
//     'User 2',
//     'User 3',
//     'User 4',
//     // Add more users as needed
//   ];

//   int highlightedUser = 6;

//   final ScrollController _scrollController = ScrollController();

//   bool showUserDetails = false;

//   bool isLogined = false;

//   void getPoint() async {
//     final reference = FirebaseDatabase.instance.ref();

//     DataSnapshot snapshot =
//         await reference.child('user/${widget.studentNumber}/point').get();
//     widget.point = snapshot.value.toString();
//     setState(() {});
//   }

//   void onLogoutTap() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   void logout() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.clear();
//   }

//   void onLoginTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => const SignUpScreen(),
//       ),
//       (route) => false,
//     );
//   }

//   void onBetHistoryTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => BetHistoryScreen(
//           studentNumber: widget.studentNumber,
//           name: widget.name,
//           point: widget.point,
//         ),
//       ),
//       (route) => false,
//     );
//   }

//   void onBetTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => BetScreen(
//           studentNumber: widget.studentNumber,
//           name: widget.name,
//           point: widget.point,
//         ),
//       ),
//       (route) => false,
//     );
//   }

//   void onRankTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => RankScreen(
//           studentNumber: widget.studentNumber,
//           name: widget.name,
//           point: widget.point,
//         ),
//       ),
//       (route) => false,
//     );
//   }

//   void onLockedTap() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Gaps.v20,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "비회원은 ",
//                     style: TextStyle(
//                       fontSize: Sizes.size16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "사용할 수 없는 기능",
//                     style: TextStyle(
//                       color: Theme.of(context).primaryColor,
//                       fontSize: Sizes.size16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Text(
//                     "입니다",
//                     style: TextStyle(
//                       fontSize: Sizes.size16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               Gaps.v40,
//               const Text(
//                 textAlign: TextAlign.start,
//                 "계정을 만들고 싶다면 ? ",
//                 style: TextStyle(
//                   fontSize: Sizes.size14,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 15.0,
//                   right: 15.0,
//                   bottom: 15.0,
//                   top: 10,
//                 ),
//                 child: GestureDetector(
//                   onTap: onLoginTap,
//                   child: FormButton(
//                     disabled: false,
//                     text: "회원가입/로그인하기",
//                     widthSize: MediaQuery.of(context).size.width,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void onScaffoldTap() {
//     FocusScope.of(context).unfocus();
//   }

//   void onVoteTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MakeQuestionScreen(
//           studentNumber: widget.studentNumber,
//           name: widget.name,
//           point: widget.point,
//         ),
//       ),
//       (route) => false,
//     );
//   }

//   void onVoteCheckTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => VoteCheckScreen(
//           studentNumber: widget.studentNumber,
//           name: widget.name,
//           point: widget.point,
//         ),
//       ),
//       (route) => false,
//     );
//   }

//   void onLiveTap() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LiveSituation(
//           studentNumber: widget.studentNumber,
//           name: widget.name,
//           point: widget.point,
//         ),
//       ),
//       (route) => false,
//     );
//   }

//   Widget _buildDrawerList() {
//     return ListView(
//       children: [
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.checkToSlot),
//           iconColor: Theme.of(context).primaryColor,
//           focusColor: Theme.of(context).primaryColor,
//           title: const Text('BIG이벤트 투표하기'),
//           onTap: onVoteTap,
//           trailing: const Icon(Icons.navigate_next),
//         ),
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.listCheck),
//           iconColor: Theme.of(context).primaryColor,
//           focusColor: Theme.of(context).primaryColor,
//           title: const Text('BIG이벤트 투표 확인'),
//           onTap: onVoteCheckTap,
//           trailing: const Icon(Icons.navigate_next),
//         ),
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.satellite),
//           iconColor: Theme.of(context).primaryColor,
//           focusColor: Theme.of(context).primaryColor,
//           title: const Text('BIG이벤트 투표 현황'),
//           onTap: onLiveTap,
//           trailing: const Icon(Icons.navigate_next),
//         ),
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.checkToSlot),
//           trailing: isLogined
//               ? const Icon(Icons.navigate_next)
//               : const FaIcon(FontAwesomeIcons.lock, size: Sizes.size20),
//           iconColor: isLogined ? Theme.of(context).primaryColor : Colors.grey,
//           focusColor: Theme.of(context).primaryColor,
//           title: Text(
//             '세부종목 베팅하기',
//             style: TextStyle(
//               color: isLogined ? Colors.black : Colors.grey,
//             ),
//           ),
//           onTap: isLogined ? onBetTap : onLockedTap,
//         ),
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.folderOpen),
//           trailing: isLogined
//               ? const Icon(Icons.navigate_next)
//               : const FaIcon(FontAwesomeIcons.lock, size: Sizes.size20),
//           iconColor: isLogined ? Theme.of(context).primaryColor : Colors.grey,
//           focusColor: Theme.of(context).primaryColor,
//           title: Text(
//             '베팅 내역 보기',
//             style: TextStyle(
//               color: isLogined ? Colors.black : Colors.grey,
//             ),
//           ),
//           onTap: isLogined ? onBetHistoryTap : onLockedTap,
//         ),
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.rankingStar),
//           trailing: isLogined
//               ? const Icon(Icons.navigate_next)
//               : const FaIcon(FontAwesomeIcons.lock, size: Sizes.size20),
//           iconColor: isLogined ? Theme.of(context).primaryColor : Colors.grey,
//           focusColor: Theme.of(context).primaryColor,
//           title: Text(
//             '포인트 랭킹 현황',
//             style: TextStyle(
//               color: isLogined ? Colors.black : Colors.grey,
//             ),
//           ),
//           onTap: isLogined ? onBetTap : onLockedTap,
//         ),
//       ],
//     );
//   }

//   Widget _buildUserDetail() {
//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(
//             left: 10,
//             right: 10,
//           ),
//           child: GestureDetector(
//             onTap: () {
//               logout();
//               onLogoutTap();
//             },
//             child: FormButton(
//               disabled: false,
//               text: "로그아웃하기",
//               widthSize: MediaQuery.of(context).size.width,
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     final screenSize = MediaQuery.of(context).size.height;
//     const itemHeight = 70.0;
//     final centerOffset = (screenSize - itemHeight) / 2;
//     final topItemIndex =
//         ((_scrollController.offset + centerOffset) / itemHeight).floor();
//     if (topItemIndex >= 0 && topItemIndex < users.length) {
//       setState(() {
//         highlightedUser = topItemIndex;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "장영실고등학교 체육대회 승자예측",
//             style: TextStyle(
//               fontSize: Sizes.size20,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           centerTitle: true,
//           elevation: 0.0,
//         ),
//         drawer: Drawer(
//           child: Column(
//             children: [
//               (widget.studentNumber != null &&
//                       widget.name != null &&
//                       widget.point != null)
//                   ? UserAccountsDrawerHeader(
//                       currentAccountPicture: const CircleAvatar(
//                         backgroundImage:
//                             AssetImage('assets/images/profile.png'),
//                       ),
//                       accountName: Text(
//                           '학번 ${widget.studentNumber} / 이름 ${widget.name}'),
//                       accountEmail: Text('Point : ${widget.point}'),
//                       onDetailsPressed: () {
//                         setState(() {
//                           showUserDetails = !showUserDetails;
//                         });
//                       },
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: onLoginTap,
//                         child: FormButton(
//                           disabled: false,
//                           text: "회원가입/로그인하기",
//                           widthSize: MediaQuery.of(context).size.width,
//                         ),
//                       ),
//                     ),
//               Expanded(
//                 child:
//                     showUserDetails ? _buildUserDetail() : _buildDrawerList(),
//               )
//             ],
//           ),
//         ),
//         body:
//             // RefreshIndicator(
//             //   onRefresh: () async {},
//             //   child: SingleChildScrollView(
//             //     child: Column(
//             //       children: [
//             // Container(
//             //   height: 1.0,
//             //   width: double.infinity,
//             //   color: Theme.of(context).primaryColor,
//             // ),
//             ListView.builder(
//           controller: _scrollController,
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             return Column(
//               children: [
//                 Container(
//                   height: 1.0,
//                   width: double.infinity,
//                   color: Theme.of(context).primaryColor,
//                 ),
//                 ListTile(
//                   title: Text(
//                     users[index],
//                     style: TextStyle(
//                       color: index == highlightedUser
//                           ? Colors.yellow
//                           : Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }
