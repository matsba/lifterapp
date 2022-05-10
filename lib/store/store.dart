import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/reducers/app_reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

Store<AppState> createStore() {
  return Store<AppState>(appReducer,
      initialState: AppState.initialState(),
      middleware: [
        const NavigationMiddleware(),
        thunkMiddleware,
        LoggingMiddleware.printer()
      ]);
}
