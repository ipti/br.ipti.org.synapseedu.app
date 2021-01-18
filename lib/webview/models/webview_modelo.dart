import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../webview_pagina.dart';

class BaseModel extends ChangeNotifier {
  final List<WebViewPagina> _webViewPaginas = [];
  WebViewModel _currentWebViewModel;

  BaseModel(currentWebViewModel) {
    this._currentWebViewModel = currentWebViewModel;
  }

  UnmodifiableListView<WebViewPagina> get webViewTabs =>
      UnmodifiableListView(_webViewPaginas);

  void addTab(WebViewPagina webViewTab) {
    _webViewPaginas.add(webViewTab);
  }
}

class WebViewModel extends ChangeNotifier {
  InAppWebViewGroupOptions options;

  WebViewModel({
    this.options,
  }) {
    options = options ??
        InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(),
          ios: IOSInAppWebViewOptions(),
        );
  }
}
