import 'package:flutter/foundation.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/constants.dart';

class BlocProfile extends BlocBase {
  String id;

  BlocProfile({@required this.id});

  @override
  void dispose() {
    fDisposingBlocOf('Bloc Profile');
  }
}
