import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_root.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_router.dart';
import 'package:flutter_chat_bloc_rxdart/models/user.dart';

class AuthPage extends StatelessWidget {
  List<Widget> cardElements(bloc, snap) {
    List<Widget> widgets = [];

    widgets.add(TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: 'Enter your email address'),
      onChanged: (String mail) {
        bloc.addMail(mail);
      },
    ));

    widgets.add(TextField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(hintText: 'Enter your password'),
      onChanged: (String password) {
        bloc.addPassword(password);
      },
    ));

    if (!snap.data.isLog) {
      widgets.add(TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Enter your firstname'),
        onChanged: (String firstname) {
          bloc.addFirstname(firstname);
        },
      ));
      widgets.add(TextField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(hintText: 'Enter your lastname'),
        onChanged: (String lastname) {
          bloc.addLastname(lastname);
        },
      ));
    }

    widgets.add(
      FlatButton(
        onPressed: () {
          bloc.updateIsLog();
        },
        child: Text(snap.data.isLog ? 'Sign Up' : 'Sign In'),
      ),
    );
    return widgets;
  }

  Future<dynamic> alert(String error, BuildContext context) async {
    if (error == null) return;

    Text title = Text('Error : ');
    Text subtitle = Text(error);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[
                    dismissedDialogButton(context),
                  ],
                )
              : AlertDialog(
                  title: title,
                  content: subtitle,
                  actions: <Widget>[
                    dismissedDialogButton(context),
                  ],
                );
        });
  }

  FlatButton dismissedDialogButton(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('OK'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = GetBloc.of<BlocRoot>(context);

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: StreamBuilder<User>(
        stream: bloc.stream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final bool log = snapshot.data.isLog;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20.0),
                      width: size.width - 40,
                      height: size.height / 2,
                      child: Card(
                        elevation: 8.5,
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: cardElements(bloc, snapshot),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        bloc.handleLog();
                        alert(snapshot.data.status, context);
                      },
                      child: Text(
                        log ? 'OK' : 'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
