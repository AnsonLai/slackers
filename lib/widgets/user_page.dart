import 'package:flutter/material.dart';

import 'package:Slackers/models/database.dart';
import 'package:Slackers/models/user.dart';
import 'package:Slackers/models/absence.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

Widget buildUserPageWidget(User user, Function dbChanged) {
  EventList<Event> _markedDateMap;

  return FutureBuilder(
    future: DatabaseClient.db.getAbsencesMapFromUser(user),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      EventList<Event> _markedDateMap = snapshot.data;
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CalendarCarousel<Event>(
                height: 420,
                markedDatesMap: _markedDateMap,
                markedDateIconMaxShown: 1,
                markedDateShowIcon: true,
                markedDateIconBuilder: (event) {
                  return event.icon;
                },
                onDayPressed: (DateTime date, List<Event> events) {
                  // TODO: Add/remove absences based on click
                },
                thisMonthDayBorderColor: Colors.grey,
                todayButtonColor: Colors.black.withOpacity(0.5),
                daysHaveCircularBorder: null,
              ),
              RaisedButton(
                  onPressed: () {
                    DatabaseClient.db.deleteUser(user);
                    dbChanged();
                  },
                  child: Text("DELETE USER")),
            ],
          ),
        ),
      );
    },
  );
}
