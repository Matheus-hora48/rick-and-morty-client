import 'package:mobx/mobx.dart';
import 'package:rick_and_morty_client/src/db/database_history_helper.dart';
import 'package:rick_and_morty_client/src/model/navigation_history.dart';

part 'base_controller.g.dart';

class BaseController = BaseControllerBase with _$BaseController;

abstract class BaseControllerBase with Store {
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
