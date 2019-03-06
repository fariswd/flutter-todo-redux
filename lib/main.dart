import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:reduxed/model/model.dart';
import 'package:reduxed/redux/reducers.dart';
import 'package:reduxed/redux/actions.dart';
import 'package:reduxed/redux/middleware.dart';

import 'package:reduxed/screen/IndexScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware()
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'reduxed',
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(GetItemsAction()),
          builder: (BuildContext context, Store<AppState> store) => IndexScreen(store),
        )
      ),
    );
  }
}
