import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';

class BlocMessages extends BlocBase {
  String id;

  BlocMessages({@required this.id});

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Messages');
  }
}
