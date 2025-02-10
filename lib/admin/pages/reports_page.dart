import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/requests/get_reports.dart';
import 'package:inventory_managment/widgets/page_changer.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  List<String> users = [];

  Widget reportItem(String text, String date) {
    return wrappedItem(ListTile(
      title: Row(children: [
        Expanded(child: Text(text, maxLines: 400, overflow: TextOverflow.ellipsis)),
      ]),
      subtitle: Text(date, style: const TextStyle(color: Colors.grey, fontSize: 10),),
    ));
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return scaffoldWithAdminNavigation(
        4,
        context,
        FutureBuilder(
            future: getReports(currentPage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text('ошибка: ${snapshot.error}');
              } else {
                totalPages = snapshot.data!["totalPages"];
                data = snapshot.data!["data"];
                List<Widget> items = [];
                for (int i = 0; i < data.length; i++) {
                  items.add(reportItem(data[i]["text"]!, data[i]["date"]!), );
                }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          flex: 7,
                          child: SingleChildScrollView(
                              child: Column(
                            children: items,
                          ))),
                      Expanded(
                          flex: 1,
                          child: pageChanger(
                              currentPage, totalPages, nextPage, previousPage))
                    ]);
              }
            }));
  }
}
