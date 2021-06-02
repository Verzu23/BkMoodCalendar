import 'package:angular/angular.dart';

import 'src/calendar/calendar_component.dart';

// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [Calendar],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
