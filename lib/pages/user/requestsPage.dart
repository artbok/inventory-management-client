import 'package:flutter/material.dart';
import '../../widgets/userNavigation.dart';
import '../../localStorage.dart';
import '../../requests/getItemsRequests.dart';
import 'requestItemPage.dart';
import 'requestCustomItemPage.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> {
  TextEditingController searchController = TextEditingController();

  Widget getItemWidget(String name, String status, int quantity) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color.fromARGB(255, 108, 243, 213),
                    Color.fromARGB(255, 113, 219, 196),
                    Color.fromARGB(255, 19, 200, 181),
                    Color.fromARGB(255, 33, 163, 163),
                    Color.fromARGB(255, 115, 117, 165)
                  ],
                  tileMode: TileMode.clamp),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: Text("$name     ${quantity}x"),
              subtitle: Text(status, style: const TextStyle(fontSize: 15)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    String owner = getValue("username");
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const Expanded(flex: 2, child: Text("Your inventory")),
            Expanded(flex: 2, child: Container()),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "search",
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                        color: const Color.fromARGB(255, 219, 240, 35),
                        child: TextFormField(controller: searchController)),
                  ],
                )),
            Expanded(flex: 1, child: Container()),
          ],
        )),
        body: Center(
            child: Row(children: [
          userNavigation(1, context),
          Expanded(
              child: FutureBuilder(
                  future: getItemsRequests(
                    owner,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      data = snapshot.data!["data"];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getItemWidget(data[i]["itemName"]!,
                            data[i]["status"]!, data[i]["quantity"]!));
                      }
                      return Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 6, 94, 209),
                                    Color.fromARGB(255, 32, 192, 93),
                                    Color.fromARGB(255, 6, 152, 209),
                                  ],
                                  tileMode: TileMode.clamp)),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Row(children: [
                                    Expanded(flex: 1, child: Container()),
                                    Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return requestCustomItemPage(
                                                        context, () {
                                                      setState(() {});
                                                    });
                                                  });
                                            },
                                            child: const Text("Request custom item"))),
                                    Expanded(flex: 1, child: Container()),
                                    Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation1,
                                                          animation2) =>
                                                      const RequestItemPage(),
                                                  transitionDuration:
                                                      Duration.zero,
                                                  reverseTransitionDuration:
                                                      Duration.zero,
                                                ),
                                              );
                                            },
                                            child: const Text(
                                                "Request item from the storage"))),
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                    )
                                  ])),
                              Expanded(
                                  flex: 6,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: items,
                                  ))),
                              Expanded(flex: 1, child: Container())
                            ],
                          ));
                    }
                  }))
        ])));
  }
}
