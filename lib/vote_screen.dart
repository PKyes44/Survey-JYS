import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:survey_jys/constants/gaps.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/vote_check_screen.dart';
import 'package:survey_jys/widgets/form_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class MakeQuestionScreen extends StatefulWidget {
  const MakeQuestionScreen({super.key});

  @override
  State<MakeQuestionScreen> createState() => _MakeQuestionScreenState();
}

class _MakeQuestionScreenState extends State<MakeQuestionScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int DBtop1 = 0;
  int DBtop2 = 0;
  int DBtop3 = 0;
  List<int> dodgeBallRank = [];
  int top1 = 0;
  int top2 = 0;
  int top3 = 0;
  List<int> finalRank = [];

  int schoolNumber = 0;

  bool isErrorDodgeBall = false;
  bool isErrorFinal = false;

  String userId = 'user1';

  List<Map<dynamic, dynamic>?> storyData = List.empty(growable: true);
  List<bool> checkList = List.empty(growable: true);
  int? storyIndex;
  Map<String, String> questionData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getStoryList();
  }

  void onTapDodgeBallRank(int classNum) {
    if (dodgeBallRank.contains(classNum)) {
      print("DBClassNum: $classNum");
      print(dodgeBallRank);
      if (DBtop3 == classNum) {
        DBtop3 = 0;
      } else if (DBtop2 == classNum) {
        DBtop2 = 0;
      } else if (DBtop1 == classNum) {
        DBtop1 = 0;
      }
    } else if (DBtop1 == 0 || (DBtop2 != 0 && DBtop3 != 0)) {
      DBtop1 = classNum;
      print("DBtop1: $DBtop1");
    } else if (DBtop2 == 0 || (DBtop3 != 0 && DBtop1 != 0)) {
      DBtop2 = classNum;
      print("DBtop2: $DBtop2");
    } else if (DBtop3 == 0 || (DBtop1 != 0 && DBtop3 != 0)) {
      DBtop3 = classNum;
      print("DBtop2: $DBtop3");
    }
    dodgeBallRank = [DBtop1, DBtop2, DBtop3];
    setState(() {});
    print("DBtop1 = $DBtop1\nDBtop2 = $DBtop2\nDBtop3 = $DBtop3");
  }

  void onTapFinalRank(int classNum) {
    if (finalRank.contains(classNum)) {
      print("ClassNum: $classNum");
      print(finalRank);
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
    finalRank = [top1, top2, top3];
    setState(() {});
    print("top1 = $top1\ntop2 = $top2\ntop3 = $top3");
  }

  void onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void onVoteCheckTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VoteCheckScreen(),
      ),
    );
  }

  void writeVotes() {
    var dodgeBallVoteList = dodgeBallRank;
    var finalVoteList = finalRank;

    var voteData = {
      "dodgeBall": dodgeBallVoteList,
      "final": finalVoteList,
    };

    DatabaseReference ref = FirebaseDatabase.instance.ref('$schoolNumber');
    ref.set(voteData);
  }

  void onSubmit() {
    print("dodgeBallRank : $dodgeBallRank\nfinalRank: $finalRank");
    if (dodgeBallRank.contains(0) ||
        finalRank.contains(0) ||
        dodgeBallRank.isEmpty ||
        finalRank.isEmpty) {
      if (dodgeBallRank.contains(0) || dodgeBallRank.isEmpty) {
        isErrorDodgeBall = true;
      }
      if (finalRank.contains(0) || finalRank.isEmpty) {
        isErrorFinal = true;
      }
      setState(() {});
      return;
    }
    setState(() {
      isErrorDodgeBall = false;
      isErrorFinal = false;
    });

    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        writeVotes();
        onVoteCheckTap();
      }
    }
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
            child: ListView(
              children: [
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.checkToSlot),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: const Text('투표하기'),
                  onTap: () {},
                  trailing: const Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.listCheck),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: const Text('투표 확인'),
                  onTap: onVoteCheckTap,
                  trailing: const Icon(Icons.navigate_next),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
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
                                  "학번을 입력해주세요",
                                  style: TextStyle(
                                    fontSize: Sizes.size20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gaps.v10,
                                TextFormField(
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
                                    schoolNumber =
                                        int.parse(newValue.toString());
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                Gaps.v16,
                                const Text(
                                  "피구 종목 승자예측",
                                  style: TextStyle(
                                    fontSize: Sizes.size20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "Top3 안에 들 것 같은 반을 선택해주세요 !",
                                  style: TextStyle(
                                    fontSize: Sizes.size14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                isErrorDodgeBall
                                    ? Column(
                                        children: [
                                          Text(
                                            '※ Top3를 선택해주십시오',
                                            style: TextStyle(
                                              color: Colors.red.shade800,
                                            ),
                                          ),
                                          Gaps.v10,
                                        ],
                                      )
                                    : const Text(''),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(11),
                                      child: FormButton(
                                        disabled: DBtop1 == 11 ||
                                                DBtop2 == 11 ||
                                                DBtop3 == 11
                                            ? false
                                            : true,
                                        text: '1 - 1',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(12),
                                      child: FormButton(
                                        disabled: DBtop1 == 12 ||
                                                DBtop2 == 12 ||
                                                DBtop3 == 12
                                            ? false
                                            : true,
                                        text: '1 - 2',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(13),
                                      child: FormButton(
                                        disabled: DBtop1 == 13 ||
                                                DBtop2 == 13 ||
                                                DBtop3 == 13
                                            ? false
                                            : true,
                                        text: '1 - 3',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(14),
                                      child: FormButton(
                                        disabled: DBtop1 == 14 ||
                                                DBtop2 == 14 ||
                                                DBtop3 == 14
                                            ? false
                                            : true,
                                        text: '1 - 4',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(15),
                                      child: FormButton(
                                        disabled: DBtop1 == 15 ||
                                                DBtop2 == 15 ||
                                                DBtop3 == 15
                                            ? false
                                            : true,
                                        text: '1 - 5',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(16),
                                      child: FormButton(
                                        disabled: DBtop1 == 16 ||
                                                DBtop2 == 16 ||
                                                DBtop3 == 16
                                            ? false
                                            : true,
                                        text: '1 - 6',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(17),
                                      child: FormButton(
                                        disabled: DBtop1 == 17 ||
                                                DBtop2 == 17 ||
                                                DBtop3 == 17
                                            ? false
                                            : true,
                                        text: '1 - 7',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(18),
                                      child: FormButton(
                                        disabled: DBtop1 == 18 ||
                                                DBtop2 == 18 ||
                                                DBtop3 == 18
                                            ? false
                                            : true,
                                        text: '1 - 8',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(21),
                                      child: FormButton(
                                        disabled: DBtop1 == 21 ||
                                                DBtop2 == 21 ||
                                                DBtop3 == 21
                                            ? false
                                            : true,
                                        text: '2 - 1',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(22),
                                      child: FormButton(
                                        disabled: DBtop1 == 22 ||
                                                DBtop2 == 22 ||
                                                DBtop3 == 22
                                            ? false
                                            : true,
                                        text: '2 - 2',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(23),
                                      child: FormButton(
                                        disabled: DBtop1 == 23 ||
                                                DBtop2 == 23 ||
                                                DBtop3 == 23
                                            ? false
                                            : true,
                                        text: '2 - 3',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(24),
                                      child: FormButton(
                                        disabled: DBtop1 == 24 ||
                                                DBtop2 == 24 ||
                                                DBtop3 == 24
                                            ? false
                                            : true,
                                        text: '2 - 4',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(25),
                                      child: FormButton(
                                        disabled: DBtop1 == 25 ||
                                                DBtop2 == 25 ||
                                                DBtop3 == 25
                                            ? false
                                            : true,
                                        text: '2 - 5',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(26),
                                      child: FormButton(
                                        disabled: DBtop1 == 26 ||
                                                DBtop2 == 26 ||
                                                DBtop3 == 26
                                            ? false
                                            : true,
                                        text: '2 - 6',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(27),
                                      child: FormButton(
                                        disabled: DBtop1 == 27 ||
                                                DBtop2 == 27 ||
                                                DBtop3 == 27
                                            ? false
                                            : true,
                                        text: '2 - 7',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(28),
                                      child: FormButton(
                                        disabled: DBtop1 == 28 ||
                                                DBtop2 == 28 ||
                                                DBtop3 == 28
                                            ? false
                                            : true,
                                        text: '2 - 8',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(31),
                                      child: FormButton(
                                        disabled: DBtop1 == 31 ||
                                                DBtop2 == 31 ||
                                                DBtop3 == 31
                                            ? false
                                            : true,
                                        text: '3 - 1',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(32),
                                      child: FormButton(
                                        disabled: DBtop1 == 32 ||
                                                DBtop2 == 32 ||
                                                DBtop3 == 32
                                            ? false
                                            : true,
                                        text: '3 - 2',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(33),
                                      child: FormButton(
                                        disabled: DBtop1 == 33 ||
                                                DBtop2 == 33 ||
                                                DBtop3 == 33
                                            ? false
                                            : true,
                                        text: '3 - 3',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(34),
                                      child: FormButton(
                                        disabled: DBtop1 == 34 ||
                                                DBtop2 == 34 ||
                                                DBtop3 == 34
                                            ? false
                                            : true,
                                        text: '3 - 4',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(35),
                                      child: FormButton(
                                        disabled: DBtop1 == 35 ||
                                                DBtop2 == 35 ||
                                                DBtop3 == 35
                                            ? false
                                            : true,
                                        text: '3 - 5',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(36),
                                      child: FormButton(
                                        disabled: DBtop1 == 36 ||
                                                DBtop2 == 36 ||
                                                DBtop3 == 36
                                            ? false
                                            : true,
                                        text: '3 - 6',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(37),
                                      child: FormButton(
                                        disabled: DBtop1 == 37 ||
                                                DBtop2 == 37 ||
                                                DBtop3 == 37
                                            ? false
                                            : true,
                                        text: '3 - 7',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapDodgeBallRank(38),
                                      child: FormButton(
                                        disabled: DBtop1 == 38 ||
                                                DBtop2 == 38 ||
                                                DBtop3 == 38
                                            ? false
                                            : true,
                                        text: '3 - 8',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
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
                                const Text(
                                  "Top3 안에 들 것 같은 반을 선택해주세요 !",
                                  style: TextStyle(
                                    fontSize: Sizes.size14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                isErrorFinal
                                    ? Column(
                                        children: [
                                          Text(
                                            '※ Top3를 선택해주십시오',
                                            style: TextStyle(
                                              color: Colors.red.shade800,
                                            ),
                                          ),
                                          Gaps.v10,
                                        ],
                                      )
                                    : const Text(''),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(11),
                                      child: FormButton(
                                        disabled: top1 == 11 ||
                                                top2 == 11 ||
                                                top3 == 11
                                            ? false
                                            : true,
                                        text: '1 - 1',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(12),
                                      child: FormButton(
                                        disabled: top1 == 12 ||
                                                top2 == 12 ||
                                                top3 == 12
                                            ? false
                                            : true,
                                        text: '1 - 2',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(13),
                                      child: FormButton(
                                        disabled: top1 == 13 ||
                                                top2 == 13 ||
                                                top3 == 13
                                            ? false
                                            : true,
                                        text: '1 - 3',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(14),
                                      child: FormButton(
                                        disabled: top1 == 14 ||
                                                top2 == 14 ||
                                                top3 == 14
                                            ? false
                                            : true,
                                        text: '1 - 4',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(15),
                                      child: FormButton(
                                        disabled: top1 == 15 ||
                                                top2 == 15 ||
                                                top3 == 15
                                            ? false
                                            : true,
                                        text: '1 - 5',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(16),
                                      child: FormButton(
                                        disabled: top1 == 16 ||
                                                top2 == 16 ||
                                                top3 == 16
                                            ? false
                                            : true,
                                        text: '1 - 6',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(17),
                                      child: FormButton(
                                        disabled: top1 == 17 ||
                                                top2 == 17 ||
                                                top3 == 17
                                            ? false
                                            : true,
                                        text: '1 - 7',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(18),
                                      child: FormButton(
                                        disabled: top1 == 18 ||
                                                top2 == 18 ||
                                                top3 == 18
                                            ? false
                                            : true,
                                        text: '1 - 8',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(21),
                                      child: FormButton(
                                        disabled: top1 == 21 ||
                                                top2 == 21 ||
                                                top3 == 21
                                            ? false
                                            : true,
                                        text: '2 - 1',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(22),
                                      child: FormButton(
                                        disabled: top1 == 22 ||
                                                top2 == 22 ||
                                                top3 == 22
                                            ? false
                                            : true,
                                        text: '2 - 2',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(23),
                                      child: FormButton(
                                        disabled: top1 == 23 ||
                                                top2 == 23 ||
                                                top3 == 23
                                            ? false
                                            : true,
                                        text: '2 - 3',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(24),
                                      child: FormButton(
                                        disabled: top1 == 24 ||
                                                top2 == 24 ||
                                                top3 == 24
                                            ? false
                                            : true,
                                        text: '2 - 4',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(25),
                                      child: FormButton(
                                        disabled: top1 == 25 ||
                                                top2 == 25 ||
                                                top3 == 25
                                            ? false
                                            : true,
                                        text: '2 - 5',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(26),
                                      child: FormButton(
                                        disabled: top1 == 26 ||
                                                top2 == 26 ||
                                                top3 == 26
                                            ? false
                                            : true,
                                        text: '2 - 6',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(27),
                                      child: FormButton(
                                        disabled: top1 == 27 ||
                                                top2 == 27 ||
                                                top3 == 27
                                            ? false
                                            : true,
                                        text: '2 - 7',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(28),
                                      child: FormButton(
                                        disabled: top1 == 28 ||
                                                top2 == 28 ||
                                                top3 == 28
                                            ? false
                                            : true,
                                        text: '2 - 8',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(31),
                                      child: FormButton(
                                        disabled: top1 == 31 ||
                                                top2 == 31 ||
                                                top3 == 31
                                            ? false
                                            : true,
                                        text: '3 - 1',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(32),
                                      child: FormButton(
                                        disabled: top1 == 32 ||
                                                top2 == 32 ||
                                                top3 == 32
                                            ? false
                                            : true,
                                        text: '3 - 2',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(33),
                                      child: FormButton(
                                        disabled: top1 == 33 ||
                                                top2 == 33 ||
                                                top3 == 33
                                            ? false
                                            : true,
                                        text: '3 - 3',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(34),
                                      child: FormButton(
                                        disabled: top1 == 34 ||
                                                top2 == 34 ||
                                                top3 == 34
                                            ? false
                                            : true,
                                        text: '3 - 4',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(35),
                                      child: FormButton(
                                        disabled: top1 == 35 ||
                                                top2 == 35 ||
                                                top3 == 35
                                            ? false
                                            : true,
                                        text: '3 - 5',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(36),
                                      child: FormButton(
                                        disabled: top1 == 36 ||
                                                top2 == 36 ||
                                                top3 == 36
                                            ? false
                                            : true,
                                        text: '3 - 6',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(37),
                                      child: FormButton(
                                        disabled: top1 == 37 ||
                                                top2 == 37 ||
                                                top3 == 37
                                            ? false
                                            : true,
                                        text: '3 - 7',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onTapFinalRank(38),
                                      child: FormButton(
                                        disabled: top1 == 38 ||
                                                top2 == 38 ||
                                                top3 == 38
                                            ? false
                                            : true,
                                        text: '3 - 8',
                                        widthSize:
                                            (MediaQuery.of(context).size.width -
                                                    60) /
                                                4,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v16,
                                GestureDetector(
                                  onTap: onSubmit,
                                  child: FormButton(
                                    disabled: false,
                                    text: "Add",
                                    widthSize:
                                        MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
