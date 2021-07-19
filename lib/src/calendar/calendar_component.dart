import 'dart:async';
import 'dart:math';

import 'package:BkMoodCalendar/src/model/motoEvent.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_maps/google_maps.dart';
import 'package:angular_forms/angular_forms.dart';

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
    formDirectives,
    NgFor,
    NgIf,
  ],
  providers: [windowBindings, ClassProvider(CalendarService)],
)
class Calendar implements OnInit, AfterViewInit {
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
  GMap _map;
  Marker _aMarker;
  Marker _bMarker;
  final double milesPerKm = 0.621371;

  /// Radius of the earth in km.
  final int radiusOfEarth = 6371;

  Calendar(this.calendarService);

  @override
  Future<Null> ngOnInit() async {
/*     document.addEventListener('touchstart', (event) => touchStart(event));
    document.addEventListener('touchmove', (event) => touchMove(event));
    document.addEventListener('touchend', (event) => touchEnd(event)); */
    await initializeDateFormatting('it_IT', null);
    await initializeDateFormatting('en_US', null);

    selectedMonth = DateTime.now();
    changeMonth(selectedMonth);
    setWeekDays();
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
    event.addAll(motoEvents.where((element) => calendarService.isSameDate(
        calendarService.fromStringToDateTime(element.oraInizio), day)));

    return event;
  }

  /// The DOM element reference for the Google Maps initialization.
  @ViewChild('mapArea')
  var mapAreaRef;

  @override
  Future<void> ngAfterViewInit() async {
    motoEvents = await calendarService.getMotoEvents();
    _map = GMap(
        mapAreaRef.nativeElement,
        MapOptions()
          ..zoom = 5
          //..center = LatLng(47.4979, 19.0402) // Budapest, Hungary
          ..center = LatLng(41.902782, 12.496366) //Rome, Italy
        );
    _map.onClick.listen((MouseEvent event) {
      _updatePosition(event.latLng);
      //_updateDistance();
    });
    motoEvents.forEach((element) {
      _createMarker(
          _map,
          '',
          LatLng(num.parse(element.luogo.latitudine),
              num.parse(element.luogo.longitudine)));
    });
  }

  /*String _formatPosition(LatLng position) {
    if (position == null) return null;
    return '${position.lat.toStringAsFixed(4)}, '
        '${position.lng.toStringAsFixed(4)}';
  }*/

  void _updatePosition(LatLng position) {
    if (_aMarker == null) {
      _aMarker = _createMarker(_map, 'A', position);
    } else if (_bMarker == null) {
      _bMarker = _createMarker(_map, 'B', position);
    } else {
      _aMarker.position = _bMarker.position;
      _bMarker.position = position;
    }
  }

  Marker _createMarker(GMap map, String label, LatLng position) {
    final marker = Marker(MarkerOptions()
      ..map = map
      ..draggable = true
      ..label = label
      ..position = position);
    marker.onDrag.listen((MouseEvent event) {
      //_updateDistance();
    });
    return marker;
  }

  /*void _updateDistance() {
    if (_aMarker == null || _bMarker == null) return;
    var d = _calculateDistance();
    if (unit == 'miles') {
      d *= milesPerKm;
    }
    distance = '${d.round()} $unit';
  }*/

  //double _toRadian(num degree) => degree * pi / 180.0;

  /*double _calculateDistance() {
    final dLat = _toRadian(b.lat - a.lat);
    final sLat = pow(sin(dLat / 2), 2);
    final dLng = _toRadian(b.lng - a.lng);
    final sLng = pow(sin(dLng / 2), 2);
    final cosALat = cos(_toRadian(a.lat));
    final cosBLat = cos(_toRadian(b.lat));
    final x = sLat + cosALat * cosBLat * sLng;
    return 2 * atan2(sqrt(x), sqrt(1 - x)) * radiusOfEarth;
  }*/
}
