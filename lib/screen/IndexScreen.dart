import 'package:flutter/material.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:reduxed/model/model.dart';
import 'package:reduxed/redux/actions.dart';

class IndexScreen extends StatefulWidget {
  final DevToolsStore<AppState> store;

  IndexScreen(this.store);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final TextEditingController controller =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List Redux'),
      ),
      drawer: Container(
        child: ReduxDevTools(widget.store),
      ),
      body: StoreConnector(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Remove all Todos'),
                onPressed: viewModel.onRemoveItems,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Type your to do here',
                  ),
                  onSubmitted: (String str) {
                    viewModel.onAddItem(str);
                    controller.text = '';
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: viewModel.items
                      .map((Item item) => ListTile(
                            title: Text(item.body),
                            leading: IconButton(
                              onPressed: () => viewModel.onRemoveItem(item),
                              icon: Icon(Icons.delete),
                            ),
                            trailing: Checkbox(
                              value: item.completed,
                              onChanged: (b) {
                                viewModel.onCompletedItems(item);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;
  final Function(Item) onCompletedItems;

  _ViewModel({
    this.items,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems,
    this.onCompletedItems,
  });

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }
    _onCompletedItems(Item item) {
      store.dispatch(ItemCompletedAction(item));
    }

    return _ViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
      onCompletedItems: _onCompletedItems,
    );
  }
}
