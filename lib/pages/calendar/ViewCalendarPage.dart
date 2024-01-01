import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'package:madcamp_1week/pages/calendar/ViewEventInfoPage.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Event class 정의
class Event {
  final String title;
  final String time;
  final String who;

  Event(this.title, this.time, this.who);

  // Convert an Event object to a Map object
  // Event object를 Map object로 변환 (Map: '키:값' 쌍의 목록을 가지는 형태)
  Map<String, dynamic> toJson() => {
        'title': title,
        'time': time,
        'who': who,
      };

  // Create an Event object from a Map object
  // Map object를 Event object로 변환
  factory Event.fromJson(Map<String, dynamic> jsonData) {
    return Event(
      jsonData['title'],
      jsonData['time'],
      jsonData['who'],
    );
  }
}

// CustomDropdownButton 위젯 정의
// _selectedContact를 위한 드롭다운
class CustomDropdownButton extends StatefulWidget {
  final List<String> contactNames;
  final Function(String?) onSelected;

  CustomDropdownButton({Key? key, required this.contactNames, required this.onSelected}) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _selectedValue = widget.contactNames.isNotEmpty ? widget.contactNames[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedValue,
      items: widget.contactNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue;
        });
        widget.onSelected(newValue); // 콜백 함수 호출
      },
    );
  }
}

// Calendar 정의
class ViewCalendarPageWidget extends StatefulWidget {
  const ViewCalendarPageWidget({Key? key}) : super(key: key);

  @override
  State<ViewCalendarPageWidget> createState() => _ViewCalendarPageWidgetState();
}

class _ViewCalendarPageWidgetState extends State<ViewCalendarPageWidget> {
  ValueNotifier<List<Event>>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final titleController = TextEditingController();
    final timeController = TextEditingController();

  String? _selectedContact;
  Map<DateTime, List<Event>> _events = {};

    Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/events.json');
  }

   Future<File> _writeEvents() async {
    final file = await _localFile;
    // Convert each event to a map and then to a JSON string
    String jsonEvents = jsonEncode(_events.map((key, value) => MapEntry(key.toIso8601String(), value.map((e) => e.toJson()).toList())));
    return file.writeAsString(jsonEvents);
  }

  Future<void> _loadEvents() async {
    try {
      final file = await _localFile;
      String jsonEvents = await file.readAsString();
      Map<String, dynamic> decodedJson = jsonDecode(jsonEvents);
      setState(() {
        // _events: 모든 일정정보를 담는 list
        _events = decodedJson.map((key, value) => MapEntry(DateTime.parse(key), value.map<Event>((e) => Event.fromJson(e)).toList()));
        // allDates: _event에 있는 모든 날짜를 담는 list
        //List<DateTime> allDates = _events.keys.toList();
        //print('allDates: $allDates');
      });
    } catch (e) {
      // If encountering an error, return an empty map
      _events = {};
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _loadEvents(); 
  }
  

  @override
  void dispose() {
    _selectedEvents?.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _selectedEvents?.value = _getEventsForDay(selectedDay);
  }

  void _addOrUpdateEvent(String title, String time, String who) {
  final event = Event(title, time, who);

  if (_selectedDay != null) {
    _events[_selectedDay!] = (_events[_selectedDay] ?? [])..add(event);
    _selectedEvents?.value = _getEventsForDay(_selectedDay!);
  }
  _writeEvents();
}

  void _deleteEvent(DateTime day, Event event) {
    setState(() {
      _events[day]?.remove(event);
      if (_events[day]?.isEmpty ?? true) {
        _events.remove(day);
      }
    });
    _selectedEvents?.value = _getEventsForDay(day);
    _writeEvents();
  }

  
  List<String> contactNames = contacts.map((contact) => contact.name).toList();
  
  String? _selectedValue ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('만남 저장소'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
    selectedDecoration: BoxDecoration(
      color: Color.fromARGB(255, 54, 118, 177), // 선택된 날짜의 배경색
      shape: BoxShape.circle, // 선택된 날짜의 모양 (사각형)
     // 선택된 날짜의 둥근 모서리
    ),
    selectedTextStyle: TextStyle(
      color: Colors.white, // 선택된 날짜의 텍스트 색상
    ),
  ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents!,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];

                    return Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 0.0,
                      ),
                      decoration: BoxDecoration(
                        //border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      // 저장된 약속 시간과 만날 사람을 캘린더 하단에 보여줌
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //SizedBox(width: 10),
                            Padding(
    padding: EdgeInsets.only(top: 4), // 상단 여백을 추가하여 원을 아래로 내림
    child: Container(
      width: 15, // 원의 지름
      height: 15, // 원의 지름
      decoration: BoxDecoration(
        shape: BoxShape.circle, // 원 모양으로 설정
        color: Color.fromARGB(255, 54, 118, 177), // 원의 색상 설정
      ),
    ),
  ),
  SizedBox(width: 20),
                            Text('${event?.time ?? "N/A"}'),
                            SizedBox(width: 30),
                            Text('${event?.title ?? "N/A"}'),
                            SizedBox(width: 100),
                            // Text('사람: ${event?.who ?? "N/A"}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _deleteEvent(_selectedDay!, event),
                        ),
                        onTap: () {
                // 여기에 Navigator.push를 사용하여 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewEventInfoPage(
                      date: _selectedDay,
                      title: event.title,
                      time: event.time,
                      people: event.who,
                    ),
                  ),
                );
              },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    
    //final whoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        // title: Text("일정 추가"),
        content: Container(
          height: 180,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "일정 이름", labelStyle: TextStyle(
      color: Colors.grey, // 여기에서 원하는 색상을 설정하세요.
    ),
    contentPadding: EdgeInsets.only(top: 8.0, bottom: 0.0),focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black), // 포커스 받았을 때의 색상을 보라색으로 설정
    ),),
                
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: "약속 시간", labelStyle: TextStyle(
      color: Colors.grey, // 여기에서 원하는 색상을 설정하세요.
    ),
    contentPadding: EdgeInsets.only(top: 8.0, bottom: 0.0),focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black), // 포커스 받았을 때의 색상을 보라색으로 설정
    ),),
    
              ),
              CustomDropdownButton(
            contactNames: contactNames,
            onSelected: (newValue) {
              ///////////////////////////////////////////// newValue 처리
              _selectedContact = newValue;
              //print('Selected value = $newValue');
            },
          ),]),
        ),
        actions: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: TextButton(
                  child: Text("추가"),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        timeController.text.isNotEmpty &&
                        _selectedContact != null) {
                      _addOrUpdateEvent(
                        titleController.text,
                        timeController.text,
                        _selectedContact!,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 13, 114, 208), // 추가 버튼의 배경색을 파랑으로 설정
                          //textStyle: TextStyle(color: Colors.white),// 텍스트 색상을 흰색으로 설정
                          shape: RoundedRectangleBorder( // 둥근 사각형 모양
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 20,),
              SizedBox(
                width: 120,
                child: TextButton(
                            child: Text("취소"),
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 취소 버튼의 배경색을 하얗게 설정
                                  foregroundColor: Colors.black, // 텍스트 색상을 검정으로 설정
                                  shape: RoundedRectangleBorder( // 둥근 사각형 모양
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: const Color.fromARGB(255, 203, 203, 203)), // 회색 테두리
                                  ),
                                ),
                          ),
              ),
            ],
          ),
          
        ],
      ),
    );
  },
  child: Icon(
              Icons.add,
              color: Color.fromRGBO(117, 117, 117, 1),
              size: 32,
            ),
            backgroundColor:  Color.fromRGBO(255, 255, 255, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
),
      
    );
  }
}

