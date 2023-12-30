import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String time; // 약속 시간 추가
  final String who; // 만날 사람 추가

  Event(this.title, this.time, this.who);

  @override
  String toString() => title;
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
  Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
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
  }

  void _deleteEvent(DateTime day, Event event) {
    setState(() {
      _events[day]?.remove(event);
      if (_events[day]?.isEmpty ?? true) {
        _events.remove(day);
      }
    });
    _selectedEvents?.value = _getEventsForDay(day);
  }

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
                            Text('사람: ${event?.who ?? "N/A"}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEvent(_selectedDay!, event),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 30.0, // 원하는 너비
        height: 30.0, // 원하는 높이
        child: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("일정 추가"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "일정 이름"),
                    onSubmitted: (value) {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      _addOrUpdateEvent(value, "", ""); // _addOrUpdateEvent 함수에 이벤트 이름과 시간 전달
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                  ),

                  TextField(
                    decoration: InputDecoration(labelText: "약속 시간"),
                    onSubmitted: (value) {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      _addOrUpdateEvent("", value, ""); // _addOrUpdateEvent 함수에 시간 전달
                    },
                    textAlign: TextAlign.center,
                  ),

                  TextField(
                    decoration: InputDecoration(labelText: "만날 사람"),
                    onSubmitted: (value) {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      _addOrUpdateEvent("", "", value); // _addOrUpdateEvent 함수에 만날 사람 전달
                    },
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(), //이벤트 추가 팝업화면
                ),
              ],
            ),
          ),
          child: Icon(Icons.add), //우측 하단 추가 버튼
        ),
      ),
    );
  }
}
