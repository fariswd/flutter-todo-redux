import 'dart:async';
import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reduxed/model/model.dart';
import 'package:reduxed/redux/actions.dart';

Middleware<AppState> _loadFromPrefs(AppState state){
  return (Store<AppState> store, action, NextDispatcher next){
    next(action);
    loadFromPrefs().then((state) => store.dispatch(LoadedItemsAction(state.items)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state){
  return (Store<AppState> store, action, NextDispatcher next){
    next(action);
    saveToPerfs(store.state);
  };
}

List<Middleware<AppState>> appStateMiddleware([
    AppState state = const AppState(items: [])
  ]){
  final loadItems = _loadFromPrefs(state);
  final saveItems =_saveToPrefs(state);

  return [
    TypedMiddleware<AppState, AddItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemsAction>(saveItems),
    TypedMiddleware<AppState, GetItemsAction>(loadItems),
  ];
}


void saveToPerfs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var string = json.encode(state.toJson());
  await preferences.setString('itemsState', string);

}

Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences =await SharedPreferences.getInstance();
  var string = preferences.getString('itemsState');
  if (string != null){
    Map map = json.decode(string);
    return AppState.fromJson(map);
  }
  return AppState.initialState();
}
