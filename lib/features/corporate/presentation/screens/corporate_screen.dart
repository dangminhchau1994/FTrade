import 'package:flutter/material.dart';

import '../widgets/dividend_list.dart';
import '../widgets/event_calendar.dart';
import '../widgets/insider_trade_list.dart';

class CorporateScreen extends StatelessWidget {
  const CorporateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Doanh nghiệp'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cổ tức'),
              Tab(text: 'Sự kiện'),
              Tab(text: 'Nội bộ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DividendList(),
            EventCalendar(),
            InsiderTradeList(),
          ],
        ),
      ),
    );
  }
}
