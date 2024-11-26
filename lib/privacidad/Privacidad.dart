import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:insejupy_multiplatform/privacidad/PrivacidadPdf.dart';

import '../webview.dart';

class Privacidad extends StatefulWidget {
  const Privacidad({Key? key}) : super(key: key);

  @override
  State<Privacidad> createState() => _PrivacidadState();
}

class _PrivacidadState extends State<Privacidad> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewController? pdfWebViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  bool hasShownNavigationDisabledMessage =
      false; // Variable para controlar si se mostró el mensaje recientemente
  Timer?
      messageTimer; // Temporizador para controlar cuándo se puede mostrar el mensaje nuevamente

  void showNavigationDisabledSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('La navegación está deshabilitada en el modo lector.'),
      duration: Duration(
          seconds: 3), // Puedes ajustar la duración según tus preferencias
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    // Cancela el temporizador si está activo
    messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("INSEJUPY"),
          leading: IconButton(
            icon: const Icon(
                Icons.arrow_back), // Cambia el icono según tus preferencias
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebViewApp(),
                ),
              );
            },
          ),
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                      url: WebUri("https://www.insejupy.gob.mx/Privacidad")),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    final url = navigationAction.request.url.toString();
                    // Verifica si la URL termina con ".pdf"
                    if (url.endsWith(".pdf")) {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacidadPdf(pdf: url),
                        ),
                      );
                      return NavigationActionPolicy.CANCEL;
                    } else {
                      if (hasShownNavigationDisabledMessage) {
                        // Si el mensaje se mostró recientemente, evita que se cargue la URL
                        return NavigationActionPolicy.CANCEL;
                      } else {
                        // Muestra el mensaje
                        showNavigationDisabledSnackBar(context);

                        // Configura un temporizador para permitir mostrar el mensaje nuevamente después de un tiempo
                        messageTimer = Timer(const Duration(seconds: 5), () {
                          setState(() {
                            hasShownNavigationDisabledMessage = false;
                          });
                        });

                        setState(() {
                          hasShownNavigationDisabledMessage = true;
                        });

                        // Evita que se cargue la URL
                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    if (kDebugMode) {
                      print(consoleMessage);
                    }
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
        ])));
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    runApp(const MaterialApp(
      home: Privacidad(),
    ));
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) {
        return true;
      };
  }
}
