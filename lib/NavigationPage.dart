import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/calendar/ViewCalendarPage.dart';
import 'package:madcamp_1week/pages/contact/ViewContactPage.dart';
import 'package:madcamp_1week/pages/gallery/ViewGalleryPage.dart';

class NavigationPageWidget extends StatefulWidget {
  const NavigationPageWidget({super.key});
  @override
  _NavigationPageWidgetState createState() => _NavigationPageWidgetState();
}

class _NavigationPageWidgetState extends State<NavigationPageWidget> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ViewContactPageWidget(),
      ViewGalleryPageWidget(),
      ViewCalendarPageWidget(),
    ];
    return Scaffold(
        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Text("연락처"),
                label: "연락처",
              ),
              BottomNavigationBarItem(
                icon: Text("갤러리"),
                label: "갤러리",
              ),
              BottomNavigationBarItem(
                icon: Text("캘린더"),
                label: "캘린더",
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xffFF5C39),
            unselectedItemColor: const Color(0xff757575),
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(fontFamily: "SUITE"),
          ),
        ));
  }
}
