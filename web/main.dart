import 'package:angular/angular.dart';
import 'package:BkMoodCalendar/app_component.template.dart' as ng;

import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'main.template.dart' as self;

@GenerateInjector([
  // You can use routerProviders in production
  ClassProvider(Client, useClass: BrowserClient),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  /*if (sw.isSupported) {
    sw.register('sw.dart.js');
  } else {
    print('ServiceWorkers are not supported.');
  }*/
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
