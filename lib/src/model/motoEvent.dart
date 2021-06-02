import 'package:BkMoodCalendar/src/model/calendar_service.dart';
import 'package:BkMoodCalendar/src/model/luogo.dart';
import 'package:BkMoodCalendar/src/model/fotografo.dart';

class MotoEvent {
  String oraInizio;
  String oraFine;
  Luogo luogo;
  Fotografo fotografo;
  CalendarService calendarService;
  MotoEvent(this.luogo);

  MotoEvent.fromJson(Map<String, dynamic> json) {
    oraInizio = json['oraInizio'];
    oraFine = json['oraFine'];
    luogo = json['luogo'] != null ? Luogo.fromJson(json['luogo']) : null;
    fotografo = json['fotografo'] != null
        ? Fotografo.fromJson(json['fotografo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['oraInizio'] = oraInizio;
    data['oraFine'] = oraFine;
    if (luogo != null) {
      data['luogo'] = luogo.toJson();
    }
    if (fotografo != null) {
      data['fotografo'] = fotografo.toJson();
    }
    return data;
  }
}
