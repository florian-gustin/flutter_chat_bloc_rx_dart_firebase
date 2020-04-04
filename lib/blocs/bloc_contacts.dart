import 'package:flutter/foundation.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';

class BlocContacts extends BlocBase {
  String id;

  BlocContacts({@required this.id});

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Contacts');
  }
}
