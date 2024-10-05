import 'package:flutter/material.dart';

import '../../../core/utils/const_value_manager.dart';
import '../../../core/utils/string_manager.dart';
import 'widgets/problems_listview_widget.dart';

class ProblemsScreen extends StatelessWidget {
  const ProblemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ConstValueManager.activitiesTabBar,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.problemsText.toUpperCase()),
          bottom: TabBar(
            tabs: [
              Tab(
                text: StringManager.allText,
              ),
              Tab(
                text: StringManager.solvedText,
              ),
              Tab(
                text: StringManager.unSolvedText,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProblemsListviewWidget(list: [1,2,3,4,5],),
            ProblemsListviewWidget(list: [1,5,4,6],),
            ProblemsListviewWidget(list: [1],)
          ],
        ),
      ),
    );

  }
}
