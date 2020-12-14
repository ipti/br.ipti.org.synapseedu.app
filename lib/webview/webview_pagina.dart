import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/webview_modelo.dart';

class WebViewPagina extends StatefulWidget {
  WebViewPagina({@required this.webViewModel});

  final WebViewModel webViewModel;

  @override
  WebViewPaginaState createState() => WebViewPaginaState();
}

class WebViewPaginaState extends State<WebViewPagina> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(color: Colors.white, child: _buildWebView());
  }

  InAppWebView _buildWebView() {
    //Propriedades do WebView pra ambas as plataformas
    var initialOptions = widget.webViewModel.options;
    initialOptions.crossPlatform.useOnDownloadStart = true;
    initialOptions.crossPlatform.useOnLoadResource = true;
    initialOptions.crossPlatform.useShouldOverrideUrlLoading = true;
    initialOptions.crossPlatform.javaScriptCanOpenWindowsAutomatically = true;
    initialOptions.crossPlatform.userAgent =
        "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36";

    initialOptions.android.safeBrowsingEnabled = true;
    initialOptions.android.disableDefaultErrorPage = true;
    initialOptions.android.supportMultipleWindows = true;

    initialOptions.ios.allowsLinkPreview = false;
    initialOptions.ios.isFraudulentWebsiteWarningEnabled = true;

    return InAppWebView(
      initialUrl: 'http://elesson.com.br/login.html',
      initialOptions: initialOptions,
      onWebViewCreated: (controller) async {
        if (Platform.isAndroid) {
          controller.android.startSafeBrowsing();
        }
        widget.webViewModel.options = await controller.getOptions();
      },

      shouldOverrideUrlLoading:
          (controller, shouldOverrideUrlLoadingRequest) async {
        var url = shouldOverrideUrlLoadingRequest.url;
        var uri = Uri.parse(url);

        // vai garantir que o webview seja capaz de rodar o site e as demandas dele, dentro do proprio app ( se remover ele vai pedir pra rodar o site no navegador do dispositivo)
        if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
            .contains(uri.scheme)) {
          if (await canLaunch(url)) {
            // carrega a URL
            await launch(url);
            return ShouldOverrideUrlLoadingAction.CANCEL;
          }
        }
        return ShouldOverrideUrlLoadingAction.ALLOW;
      },

      // Permissões
      androidOnPermissionRequest: (InAppWebViewController controller,
          String origin, List<String> resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
    );
  }
}
