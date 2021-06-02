import 'dart:async';

import 'package:BkMoodCalendar/src/model/motoEvent.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../model/calendar_service.dart';

@Component(
  selector: 'calendar',
  styleUrls: ['calendar_component.css'],
  templateUrl: 'calendar_component.html',
  directives: [
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [windowBindings, ClassProvider(CalendarService)],
)
class Calendar implements OnInit {
  CalendarService calendarService;
  int beforeTheFirst = 0;
  List<DateTime> days = [];
  int afterTheLast = 0;
  DateTime selectedMonth;
  String month = '';
  List<String> weekDays = [];
  int xStart = 0;
  int xEnd = 0;
  //int tollerance = 250;
  List<MotoEvent> motoEvents = <MotoEvent>[];

  String language = 'it_IT';

  Calendar(this.calendarService);

  @override
  Future<Null> ngOnInit() async {
    await initializeDateFormatting('it_IT', null);
    await initializeDateFormatting('en_US', null);

    selectedMonth = DateTime.now();
    changeMonth(selectedMonth);
    setWeekDays();
    motoEvents = await calendarService.getMotoEvents();
/*     document.addEventListener('touchstart', (event) => touchStart(event));
    document.addEventListener('touchmove', (event) => touchMove(event));
    document.addEventListener('touchend', (event) => touchEnd(event)); */
  }

  List<int> createRange(int numero) {
    var number = <int>[];
    number = List.filled(numero, 0);
    return number;
  }

  void changeMonth(DateTime start) {
    days.clear();

    var firstDay = DateTime(start.year, start.month, 1);
    beforeTheFirst = firstDay.weekday - 1;
    var last = DateTime(start.year, start.month + 1, 0).day;
    for (var i = 1; i <= last; i++) {
      days.add(DateTime(start.year, start.month, i));
    }
    afterTheLast = 42 - (beforeTheFirst + days.length);
    if (afterTheLast - 7 > 0) {
      afterTheLast = afterTheLast - 7;
    }
    month = DateFormat('MMMM y', language).format(start).toUpperCase();
  }

  void setWeekDays() {
    var monday = DateTime(2021, 05, 24);
    weekDays
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 0)))
          .toUpperCase())
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 1)))
          .toUpperCase())
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 2)))
          .toUpperCase())
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 3)))
          .toUpperCase())
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 4)))
          .toUpperCase())
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 5)))
          .toUpperCase())
      ..add(DateFormat.EEEE(language)
          .format(monday.add(Duration(days: 6)))
          .toUpperCase());
  }

  void addMonth() {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
    changeMonth(selectedMonth);
  }

  void removeMonth() {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
    changeMonth(selectedMonth);
  }

  /* void touchStart(TouchEvent event) {
    xStart = event.touches[0].client.x;
    xEnd = event.touches[0].client.x;
  }

  void touchMove(TouchEvent event) {
    xEnd = event.touches[0].client.x;
  }

  void touchEnd(TouchEvent event) async {
    if ((xStart - xEnd) > tollerance) {
      Future.delayed(Duration(milliseconds: 0), () => addMonth());
    } else if ((xStart - xEnd) < -tollerance) {
      Future.delayed(Duration(milliseconds: 0), () => removeMonth());
    }
    xStart = 0;
    xEnd = 0;
  } */

  List<MotoEvent> eventInThisDay(DateTime day) {
    var event = <MotoEvent>[];
    event.addAll(motoEvents.where(
        (element) => calendarService.isSameDate(element.oraInizio, day)));

    return event;
  }
}
