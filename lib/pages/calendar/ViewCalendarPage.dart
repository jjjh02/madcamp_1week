import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'package:madcamp_1week/pages/calendar/ViewEventInfoPage.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class Event {
  final String title;
  final String time;
  final String who;

  Event(this.title, this.time, this.who);

  // Convert an Event object to a Map object
  Map<String, dynamic> toJson() => {
        'title': title,
        'time': time,
        'who': who,
      };

  // Create an Event object from a Map object
  factory Event.fromJson(Map<String, dynamic> jsonData) {
    return Event(
      jsonData['title'],
      jsonData['time'],
      jsonData['who'],
    );
  }
}

// CustomDropdownButton 위젯 정의
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
    // 초기값 설정 (필요한 경우)
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
        _events = decodedJson.map((key, value) => MapEntry(DateTime.parse(key), value.map<Event>((e) => Event.fromJson(e)).toList()));
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
      appBar: AppBar(
        title: Text('캘린더'),
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      // 저장된 약속 시간과 만날 사람을 캘린더 하단에 보여줌
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('일정: ${event?.title ?? "N/A"}'),
                            SizedBox(width: 60),
                            Text('시간: ${event?.time ?? "N/A"}'),
                            SizedBox(width: 60),
                            // Text('사람: ${event?.who ?? "N/A"}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEvent(_selectedDay!, event),
                        ),
                        onTap: () {
                // 여기에 Navigator.push를 사용하여 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewEventInfoPage(
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
        title: Text("일정 추가"),
        content: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "일정 이름"),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: "약속 시간"),
            ),
            CustomDropdownButton(
          contactNames: contactNames,
          onSelected: (newValue) {
            ///////////////////////////////////////////// newValue 처리
            _selectedContact = newValue;
            //print('Selected value = $newValue');
          },
        ),]),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Add"),
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
          ),
        ],
      ),
    );
  },
  child: Icon(Icons.add),
),
      
    );
  }
}

