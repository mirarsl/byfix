import 'package:byfix/models/app_bar.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/drawer.dart';
import 'package:byfix/models/page_button.dart';
import 'package:byfix/views/pages/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  final ScrollController _scrollController = ScrollController();
  bool _hideAppBar = true;
  bool isScrollingDown = false;

  late PageController _pageController;
  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          setState(() {
            isScrollingDown = true;
            _hideAppBar = false;
          });
        }
      } else {
        if (isScrollingDown) {
          setState(() {
            isScrollingDown = false;
            _hideAppBar = true;
          });
        }
      }
    });

    _pageController = PageController(initialPage: _page);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: kSecColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 0.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      drawer: MyDrawer(),
      child: Scaffold(
        appBar: MyAppBar(
          controller: _scrollController,
          hideAppBar: _hideAppBar,
          actionList: const [],
          drawer: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kSecColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PageButton(
                      id: 0,
                      page: _page,
                      title: "Market",
                      onPress: () {
                        setState(() {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.bounceIn,
                          );
                        });
                      },
                    ),
                    PageButton(
                      id: 1,
                      page: _page,
                      onPress: () {
                        setState(() {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.bounceIn,
                          );
                        });
                      },
                      title: "Aracım",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ShopPage(scrollController: _scrollController),
                    ListView(
                      controller: _scrollController,
                      children: [
                        SizedBox(
                          height: 1200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text("BYFIX TEST"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/rgb');
                                  },
                                  child: const Text("RGB"),
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
            ],
          ),
        ),
      ),
    );
  }
}
