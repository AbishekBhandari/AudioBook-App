import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart' as colors;
import 'detail_audio_page.dart';
import 'my_tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<dynamic> popularBooks = [];
  List books = [];
  ScrollController? _scrollController;
  TabController? _tabController;
  ReadData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) {
      setState(() {
        popularBooks = json.decode(s);
      });
    });
    await DefaultAssetBundle.of(context)
        .loadString("json/books.json")
        .then((s) {
      setState(() {
        books = json.decode(s);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: colors.background,
        child: SafeArea(
            child: Scaffold(
                body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageIcon(AssetImage('img/menu.png'),
                      size: 24, color: Colors.black),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Icon(Icons.notifications),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "Popular Audio Books",
                      style: TextStyle(fontSize: 30),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 180,
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: -20,
                  right: 0,
                  child: Container(
                      height: 180,
                      child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          itemCount:
                              popularBooks == null ? 0 : popularBooks.length,
                          itemBuilder: (_, i) {
                            return Container(
                              height: 180,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: AssetImage(popularBooks[i]["img"]),
                                    fit: BoxFit.fill),
                              ),
                            );
                          })),
                ),
              ]),
            ),
            Expanded(
                child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool isScroll) {
                return [
                  SliverAppBar(
                      backgroundColor: colors.sliverBackground,
                      pinned: true,
                      bottom: PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: Container(
                              margin: EdgeInsets.only(bottom: 20, left: 10),
                              child: TabBar(
                                tabs: [
                                  AppTabs(
                                      color: colors.menu1Color, text: "New"),
                                  AppTabs(
                                      color: colors.menu2Color,
                                      text: "Popular"),
                                  AppTabs(
                                      color: colors.menu3Color,
                                      text: "Trending"),
                                ],
                                indicatorPadding: EdgeInsets.all(0),
                                indicatorSize: TabBarIndicatorSize.label,
                                labelPadding: EdgeInsets.only(right: 10),
                                controller: _tabController,
                                isScrollable: true,
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 7,
                                          offset: Offset(0, 0))
                                    ]),
                              ))))
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                      itemCount: books == null ? 0 : books.length,
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailAudioPage(book: books[i]);
                            }));
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: colors.tabVarViewColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(0, 0),
                                            color: Colors.grey.withOpacity(0.2))
                                      ]),
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 120,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        books[i]["img"])),
                                              )),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.star,
                                                      size: 24,
                                                      color: colors.starColor),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    books[i]["rating"],
                                                    style: TextStyle(
                                                        color:
                                                            colors.menu2Color),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                books[i]["title"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                books[i]["text"],
                                                style: TextStyle(
                                                    color: colors.subTitleText,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          )
                                        ],
                                      )))),
                        );
                      }),
                  Material(
                      child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
                    title: Text("No Content"),
                  )),
                  Material(
                      child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                    ),
                    title: Text("No Content"),
                  ))
                ],
              ),
            )),
          ],
        ))));
  }
}
