import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:angular/core.dart';
import 'package:BkMoodCalendar/src/model/motoEvent.dart';
import 'luogo.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class CalendarService {
  final Client _http;
  static final _headers = {'Content-Type': 'application/json;charset=utf-8'};

  static const _baseUrl = 'http://127.0.0.1:4200/api/calendar';
  static const getPjOwnersUrl = '/getEvents/';

  CalendarService(this._http);

  //List<MotoEvent> getMotoEvents() {
  /*var events = <MotoEvent>[];
    var event1 = MotoEvent(Luogo('Passo Cisa', '', ''));
    event1.oraInizio = DateTime.now();
    var event2 = MotoEvent(Luogo('Passo Stelvio', '', ''));
    event2.oraInizio = DateTime(2021, 06, 28);
    events.add(event1);

    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    events.add(event2);
    return events;*/

  // }

  Future<List<MotoEvent>> getMotoEvents() async {
    try {
      final response =
          await _http.get(_baseUrl + getPjOwnersUrl, headers: _headers);
      List<dynamic> body = jsonDecode(response.body);
      var pjOwnersList = <MotoEvent>[];
      body.forEach((e) {
        var pjOwner = MotoEvent(e['idProjectOwner']);
        /* pjOwner.active = e['active'];
        pjOwner.name = e['name'];
        pjOwner.bomName = e['bomName'];
        pjOwner.filtrable = e['filtrable']; */
        pjOwnersList.add(pjOwner);
      });
      return pjOwnersList;
    } catch (e) {
      _handleError(e, 'getPjOwners');
      return null;
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1?.toString()?.split(' ')?.first ==
        (date2.toString()?.split(' ')?.first);
  }

  Exception _handleError(dynamic e, String function) {
    print(function +
        ' throw this error: ' +
        e.toString()); // for demo purposes only
    return Exception('Server error; cause: $e');
  }
}
