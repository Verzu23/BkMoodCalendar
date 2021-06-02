import 'package:BkMoodCalendar/src/model/luogo.dart';
import 'package:BkMoodCalendar/src/model/fotografo.dart';

class MotoEvent {
  DateTime oraInizio;
  DateTime oraFine;
  Luogo luogo;
  Fotografo fotografo;

  MotoEvent(this.luogo);
}
