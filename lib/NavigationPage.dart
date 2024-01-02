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
      MyImagePicker(),
      //ViewGalleryPageWidget(),
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
                icon: Icon(Icons.people),
                label: "인연",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.image),
                label: "장면",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: "만남",
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xff62838C),
            unselectedItemColor: const Color(0xff757575),
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(fontFamily: "SUITE"),
          ),
        ));
  }
}
