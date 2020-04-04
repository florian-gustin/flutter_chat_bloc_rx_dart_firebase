import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/base.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_root.dart';
import 'package:flutter_chat_bloc_rxdart/blocs/bloc_router.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  List<Widget> tabsRoutes(String id) {
    return [
      BlocRouter().messages(id: id),
      BlocRouter().contacts(id: id),
      BlocRouter().profile(id: id),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Text title = Text('Flutter Chat');
    final bloc = GetBloc.of<BlocRoot>(context);

    return StreamBuilder<String>(
      stream: bloc.getUID,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final String id = snapshot.data;
          bloc.addUID(id);
          if (Theme.of(context).platform == TargetPlatform.iOS) {
            return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                  backgroundColor: Colors.blue,
                  activeColor: Colors.black,
                  inactiveColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.message),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.supervisor_account),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                    ),
                  ]),
              tabBuilder: (_, i) {
                Widget tabSelected = tabsRoutes(id)[i];
                return Scaffold(
                  appBar: AppBar(
                    title: title,
                  ),
                  body: tabSelected,
                );
              },
            );
          } else {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: title,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.message),
                      ),
                      Tab(
                        icon: Icon(Icons.supervisor_account),
                      ),
                      Tab(
                        icon: Icon(Icons.account_circle),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(children: tabsRoutes(id)),
              ),
            );
          }
        } else {
          return SizedBox();
        }
      },
    );
  }
}
