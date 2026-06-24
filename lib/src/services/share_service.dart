import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareProgress({
    required int completedTasksToday,
    required int focusMinutesToday,
  }) async {
    final hours = focusMinutesToday ~/ 60;
    final minutes = focusMinutesToday % 60;

    final focusText = hours > 0
        ? '${hours}h ${minutes}min'
        : '${focusMinutesToday}min';

    final message =
        'Concluí $completedTasksToday tarefas hoje e estudei por $focusText! '
        'Organizando meus estudos com Reminders.';

    await Share.share(message);
  }
}
