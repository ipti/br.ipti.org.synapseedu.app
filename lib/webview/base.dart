import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'webview_pagina.dart';
import 'models/webview_modelo.dart';

class Base extends StatefulWidget {
  Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: SafeArea(
        child: _buildWebViewTabs(),
      ),
    );
  }

  Widget _buildWebViewTabs() {
    var browserModel = Provider.of<BaseModel>(context, listen: true);

    if (browserModel.webViewTabs.length == 0) {
      abrirNovaPagina();
      FocusScope.of(context).unfocus();
    }

    return Stack(
      children: [
        IndexedStack(
          index: 0,
          children: browserModel.webViewTabs.map((webViewTab) {
            return webViewTab;
          }).toList(),
        ),
      ],
    );
  }

  void abrirNovaPagina() {
    var browserModel = Provider.of<BaseModel>(context, listen: false);
    browserModel.addTab(
      WebViewPagina(
        webViewModel: WebViewModel(),
      ),
    );
  }

}