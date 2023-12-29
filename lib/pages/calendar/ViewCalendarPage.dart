import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final String description;
  final DateTime date;

  Event(this.title, this.description, this.date);

  @override
  String toString() => '$title - $description on ${date.toLocal()}';
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

  void _addEvent(String title, String description, String dateString) {
  DateTime? eventDate = DateTime.tryParse(dateString);
  if (eventDate == null || title.isEmpty || description.isEmpty) {
    // 날짜 파싱 실패 혹은 제목/설명이 비어있으면 이벤트를 추가하지 않음.
    return;
  }

  final event = Event(title, description, eventDate);

  setState(() {
    _events[eventDate] = (_events[eventDate] ?? [])..add(event);
    if (_selectedDay != null && isSameDay(_selectedDay!, eventDate)) {
      _selectedEvents?.value = _getEventsForDay(_selectedDay!);
    }
  });
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
        title: Text('TableCalendar - Events'),
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
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text('${value[index]}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteEvent(_selectedDay!, value[index]),
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
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    String title = '';
    String description = '';
    String date = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min, // 컨텐츠 크기에 맞게 Column 크기 조정
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Title"),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: InputDecoration(hintText: "description"),
              onChanged: (value) => description = value,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Date (e.g., YYYY-MM-DD)"),
              onChanged: (value) => date = value,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Add"),
            onPressed: () {
              // 여기서 입력받은 데이터 처리
              _addEvent(title, description, date);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  },
  child: Icon(Icons.add),
)
    );
  }
}