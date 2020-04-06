import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_chat.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_zone_text.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';
import 'package:flutter_chat_bloc_rxdart/pages/auth_page.dart';
import 'package:flutter_chat_bloc_rxdart/pages/chat_page.dart';
import 'package:flutter_chat_bloc_rxdart/pages/home_page.dart';
import 'package:flutter_chat_bloc_rxdart/pages/loading_page.dart';
import 'package:flutter_chat_bloc_rxdart/tabs/contacts.dart';
import 'package:flutter_chat_bloc_rxdart/tabs/messages.dart';
import 'package:flutter_chat_bloc_rxdart/tabs/profile.dart';

import 'bloc_root.dart';
import 'bloc_contacts.dart';
import 'bloc_messages.dart';
import 'bloc_profile.dart';

class BlocRouter extends BlocBase {
  BlocProvider root({@required Widget child}) => BlocProvider<BlocRoot>(
      builder: (_, bloc) => BlocRoot(),
      onDispose: (_, bloc) => bloc.dispose(),
      child: child);
  Widget loading() => LoadingPage();
  Widget auth() => AuthPage();
  Widget home() => HomePage();
  BlocProvider messages({@required String id}) => BlocProvider<BlocMessages>(
      builder: (_, bloc) => BlocMessages(id: id),
      onDispose: (_, bloc) => bloc.dispose(),
      child: Messages());
  BlocProvider contacts({@required String id}) => BlocProvider<BlocContacts>(
      builder: (_, bloc) => BlocContacts(id: id),
      onDispose: (_, bloc) => bloc.dispose(),
      child: Contacts());
  BlocProvider profile({@required String id}) => BlocProvider<BlocProfile>(
      builder: (_, bloc) => BlocProfile(id: id),
      onDispose: (_, bloc) => bloc.dispose(),
      child: Profile());
  Future<dynamic> chat(
          {@required String id,
          @required User interlocutor,
          @required BuildContext context}) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return BlocProvider<BlocChat>(
          builder: (_, bloc) => BlocChat(id: id, interlocutor: interlocutor),
          onDispose: (_, bloc) => bloc.dispose(),
          child: ChatPage(),
        );
      }));

  BlocProvider zoneText(
          {@required String id, @required User user, @required Widget child}) =>
      BlocProvider<BlocZoneText>(
        builder: (_, bloc) => BlocZoneText(id: id, interlocutor: user),
        onDispose: (_, bloc) => bloc.dispose(),
        child: child,
      );

  @override
  void dispose() {
    print('Dispose of BlocRouter');
  }
}
