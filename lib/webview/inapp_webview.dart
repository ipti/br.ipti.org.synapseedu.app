import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InAppWebViewController? webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int number = 0;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      // initialUrl: "https://flutter.dev/",
      initialUrlRequest: URLRequest(url: Uri.parse("https://flutter.dev/")),
      // initialFile: "assets/example.html",
      // initialHeaders: ,
      // initialOptions: InAppWebViewGroupOptions(
      //     crossPlatform: InAppWebViewOptions(
      //   debuggingEnabled: true,
      // )),
      onWebViewCreated: (InAppWebViewController controller) {
        webView = controller;
        webView!.addJavaScriptHandler(
            handlerName: 'theHandler',
            callback: (args) {
              // return data to JavaScript side!
              return {'bar': 'bar_value', 'baz': 'baz_value'};
            });

        webView!.addJavaScriptHandler(
            handlerName: 'handlerFooWithArgs',
            callback: (args) {
              // print("Blergh: ${args[3]['foo']}");
              print("fooWithArgs: $args");
              // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
            });
      },
      onConsoleMessage: (controller, consoleMessage) {
        print('Mensagem: $consoleMessage');
        // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
      },
//                     onLoadStart: (InAppWebViewController controller, String url) {
//                       setState(() {
//                         this.url = url;
//                       });
//                     },
//                     onLoadStop: (InAppWebViewController controller, String url) async {
//                       setState(() {
//                         this.url = url;
//                       });
//                       // valor = await controller
//                       //     .evaluateJavascript(source: 'assets/app.js')
//                       //     .timeout(Duration(milliseconds: 1000));
//                       controller.evaluateJavascript(source: '''function test() {
//     document.getElementById("mid").innerHTML = "HOY";
//     console.log(3010);
//     return 1212;
// };
// test();''').then((value) {
//                         print('RESULTADO: $value and $valor');
//                       });
//                       // print('RESULTADO: $number');
//                     },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        setState(() {
          this.progress = progress / 100;
        });
      },
    );

    int valor = 0;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('InAppWebView Example'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text("CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
              ),
              // Container(child: evalJavascript('alert("Hello World")'),),
              Container(padding: EdgeInsets.all(10.0), child: progress < 1.0 ? LinearProgressIndicator(value: progress) : Container()),
              Expanded(
                child: Container(
                  // height: 0,
                  // width: 0,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                    // initialUrl: "https://flutter.dev/",
                    initialUrlRequest: URLRequest(url: Uri.parse("https://flutter.dev/")),
                    // initialFile: "assets/example.html",
                    // initialHeaders: ,
                    // initialOptions: InAppWebViewGroupOptions(
                    //     crossPlatform: InAppWebViewOptions(
                    //   debuggingEnabled: true,
                    // )),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                      webView!.addJavaScriptHandler(
                          handlerName: 'theHandler',
                          callback: (args) {
                            // return data to JavaScript side!
                            return {'bar': 'bar_value', 'baz': 'baz_value'};
                          });

                      webView!.addJavaScriptHandler(
                          handlerName: 'handlerFooWithArgs',
                          callback: (args) {
                            // print("Blergh: ${args[3]['foo']}");
                            print("fooWithArgs: $args");
                            // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                          });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print('Mensagem: $consoleMessage');
                      // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                    },
//                     onLoadStart: (InAppWebViewController controller, String url) {
//                       setState(() {
//                         this.url = url;
//                       });
//                     },
//                     onLoadStop: (InAppWebViewController controller, String url) async {
//                       setState(() {
//                         this.url = url;
//                       });
//                       // valor = await controller
//                       //     .evaluateJavascript(source: 'assets/app.js')
//                       //     .timeout(Duration(milliseconds: 1000));
//                       controller.evaluateJavascript(source: '''function test() {
//     document.getElementById("mid").innerHTML = "HOY";
//     console.log(3010);
//     return 1212;
// };
// test();''').then((value) {
//                         print('RESULTADO: $value and $valor');
//                       });
//                       // print('RESULTADO: $number');
//                     },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (webView != null) {
                        webView!.goBack();
                      }
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (webView != null) {
                        webView!.goForward();
                      }
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      if (webView != null) {
                        webView!.reload();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
