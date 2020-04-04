import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_root.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_router.dart';

void main() {
  runApp(BlocRouter().root(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _handleAuth(context),
    );
  }

  Widget _handleAuth(context) {
    final bloc = GetBloc.of<BlocRoot>(context);

    return StreamBuilder<FirebaseUser>(
      stream: bloc.onAuthStateChanged,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.active) {
          return snap.hasData ? BlocRouter().home() : BlocRouter().auth();
        } else {
          return BlocRouter().loading();
        }
      },
    );
  }
}
