import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../activity_selection/activity_selection_view.dart';
import 'bloc.dart';

class RootPage extends StatelessWidget {
  static const routeName = '/root';
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return Scaffold(
      body: Provider<DeepLinkBloc>(
        create: (context) => _bloc,
        dispose: (context, bloc) => bloc.dispose(),
        child: PocWidget(),
      ),
    );
  }
}

class PocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ActivitySelectionForm();
        } else {
          // aqui vai entrar se for iniciado pelo link
          return Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Redirected: ${snapshot.data}', style: Theme.of(context).textTheme.title),
              ),
            ),
          );
        }
      },
    );
  }
}
