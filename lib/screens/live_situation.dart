import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:survey_jys/constants/sizes.dart';
import 'package:survey_jys/screens/vote_check_screen.dart';
import 'package:survey_jys/screens/vote_screen.dart';

class LiveSituation extends StatefulWidget {
  String studentNumber;
  LiveSituation({
    super.key,
    required this.studentNumber,
  });

  @override
  State<LiveSituation> createState() => _LiveSituationState();
}

class _LiveSituationState extends State<LiveSituation> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reset();
    readVoteData();
  }

  // 0: 1-1, 1: 1-2, 2: 1-3, 3: 1-4
  // 9
  // 17
  Map<int, int> dodgeBallData = {};
  Map<int, int> finalData = {};
  void reset() {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveSituation(
          studentNumber: widget.studentNumber,
        ),
      ),
    );
  }

  void onVoteCheckTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoteCheckScreen(
          studentNumber: widget.studentNumber,
        ),
      ),
    );
  }

  void onVoteTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakeQuestionScreen(
          studentNumber: widget.studentNumber,
        ),
      ),
    );
  }

  void readVoteData() async {
    final reference = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await reference.child('').get();

    var data = snapshot.value as Map<dynamic, dynamic>;
    for (var key in data.keys) {
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