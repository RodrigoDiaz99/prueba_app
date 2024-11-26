import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'navbar.dart';

/*
 *  @params 
 * Este es el punto de entrada de la aplicación. Se asegura de que Flutter esté inicializado y realiza algunas configuraciones iniciales.
 * Se utiliza HttpOverrides.global para anular las solicitudes HTTP para permitir certificados no válidos. Esto generalmente se usa para depuración y pruebas.
 * Se establece la orientación preferida de la pantalla en modo retrato.
 * Si la plataforma es Android, se habilita la depuración de contenido web en el WebView incrustado.
 * Finalmente, se ejecuta la aplicación Flutter con un widget MaterialApp que contiene la clase WebViewApp.
 * dart
*/
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  //  await Preferences.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MaterialApp(home: WebViewApp()));
}

/*
WebViewApp es un widget StatefulWidget que representa la aplicación principal. 
*/
class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

/*
_WebViewAppState es la clase de estado para WebViewApp. Aquí se declara una clave global que se utiliza para acceder al WebView incrustado.
 */
class _WebViewAppState extends State<WebViewApp> {
  final GlobalKey webViewKey = GlobalKey();
/* 
*@params 
*Se declara una variable webViewController que se utilizará para controlar el WebView.
*Se configuran opciones para el WebView, como la capacidad de anular la carga de URL y la reproducción de medios sin interacción del usuario.
*/
  InAppWebViewController? webViewController;
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
/*
*Qparams
 * Se declaran varias variables relacionadas con el control del WebView, incluido un controlador para el mecanismo de "pull to refresh" y un temporizador para mostrar mensajes de advertencia. 
 * showNavigationDisabledSnackBar es una función que muestra un mensaje en forma de Snackbar cuando se intenta la navegación en modo lector.
 */
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
  /*En initState(), se inicializa el controlador de "pull to refresh".*/
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
  /*
  *@params
   * dispose() se utiliza para liberar recursos cuando el widget se destruye, en este caso, se cancela el temporizador si está activo. .
   * */
  void dispose() {
    // Cancela el temporizador si está activo
    messageTimer?.cancel();
    super.dispose();
  }

  @override
  /*
  *@params
   * En el método build(), se crea la interfaz de usuario de la aplicación. Incluye un Drawer (NavBar), una AppBar y un WebView incrustado con una barra de progreso.
   */
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(title: const Text("INSEJUPY")),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                      URLRequest(url: WebUri("https://www.insejupy.gob.mx")),
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

/*
*MyHttpOverrides es una clase que anula el comportamiento de HttpOverrides para permitir certificados no válidos. Se utiliza para permitir conexiones HTTP en modo de depuración. 
*/
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
