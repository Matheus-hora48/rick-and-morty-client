import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/db/database_history_helper.dart';
import 'package:rick_and_morty_client/src/model/navigation_history.dart';

part 'main_controller.g.dart';

class MainController = MainControllerBase with _$MainController;

abstract class MainControllerBase with Store {
  final DatabaseHistoryHelper historyHelper = DatabaseHistoryHelper();

  @observable
  ObservableFuture<List<NavigationHistoryItem>>? historyFuture;

  @action
  Future<void> loadHistory() async {
    historyFuture = ObservableFuture(historyHelper.getHistory());
    await historyFuture;
  }

  @action
  Future<void> clearHistory() async {
    await historyHelper.clearHistory();
    loadHistory();
  }
}
