import 'package:flutter/widgets.dart';

class GetBloc<B> extends InheritedWidget {
  final B bloc;

  const GetBloc({Key key, this.bloc, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(GetBloc<B> oldWidget) {
    return oldWidget.bloc != bloc;
  }

  static B of<B>(BuildContext context) {
    final GetBloc<B> provider =
        context.findAncestorWidgetOfExactType<GetBloc<B>>();
    return provider.bloc;
  }
}

class BlocProvider<B> extends StatefulWidget {
  final B Function(BuildContext context, B bloc) builder;
  final void Function(BuildContext context, B bloc) onDispose;
  final Widget child;

  const BlocProvider({
    Key key,
    @required this.builder,
    @required this.onDispose,
    @required this.child,
  }) : super(key: key);

  @override
  _BlocProviderState<B> createState() => _BlocProviderState<B>();
}

class _BlocProviderState<B> extends State<BlocProvider<B>> {
  B bloc;

  @override
  void initState() {
    if (widget.builder != null) bloc = widget.builder(context, bloc);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose(context, bloc);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBloc(
      bloc: bloc,
      child: widget.child,
    );
  }
}

abstract class BlocBase {
  void dispose();
}
