import 'package:flutter_test/flutter_test.dart';
import 'package:ponderada_4_mobile/src/core/constants/app_constants.dart';

void main() {
  test('app name is Reminders', () {
    expect(AppConstants.appName, 'Reminders');
  });

  test('pomodoro duration is 25 minutes', () {
    expect(AppConstants.pomodoroDurationSeconds, 25 * 60);
  });
}
