import 'package:insejupy_multiplatform/datostomocomercio/busquedadatostomocomercio.dart';
import 'package:insejupy_multiplatform/datospredio/busquedadatospredio.dart';
import 'package:insejupy_multiplatform/privacidad/Contacto.dart';
import 'package:insejupy_multiplatform/privacidad/Normatividad.dart';
import 'package:insejupy_multiplatform/privacidad/Privacidad.dart';
import 'package:insejupy_multiplatform/qr/avaluoqr.dart';
import 'package:insejupy_multiplatform/qr/catastroqr.dart';
import 'package:insejupy_multiplatform/qr/rppqr.dart';
import 'package:insejupy_multiplatform/seguimiento.dart';
import 'package:flutter/material.dart';
import 'package:insejupy_multiplatform/datostomo/busquedadatostomo.dart';
import 'package:insejupy_multiplatform/foliocivilcomercio/busquedafce.dart';

import 'package:url_launcher/url_launcher.dart';

import 'privacidad/PrivacidadMovil.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(142, 44, 72, 1),
            ),
            child: Center(
              // Centra el logo horizontalmente
              child: Image.asset(
                'images/logo_6.png',
                width: 200, // Ajusta el ancho del logo
                height: 150, // Ajusta el alto del logo
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text(
              'Seguimiento',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Seguimiento()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text(
              'Verifica Documento RPP',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Rppqr()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text(
              'Verifica QR Catastro',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Acción al seleccionar Verifica QR Catastro
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Catastroqr()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text(
              'Verifica QR Avaluo',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              // Acción al seleccionar Verifica QR Catastro
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Avaluoqr()),
              );
            },
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Consultar de Propiedad Por',
              style: TextStyle(
                fontFamily: 'EpicaPro',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text(
              'Datos del Tomo',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const Busquedadatostomo()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text(
              'Datos del Predio',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const Busquedadatospredio()),
              );
            },
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Consultar de Comercio Por',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'EpicaPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text(
              'Datos del Tomo',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const Busquedadatostomocomercio()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text(
              'Consulta del Folio Civil',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Busquedafce()),
              );
            },
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Acceder',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'EpicaPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text(
              'Notaría Digital',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () async {
              String url = 'https://ancj.insejupy.gob.mx/';
              _launch(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text(
              'Ciudadano',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () async {
              String url = 'https://personasmoralesncivil.insejupy.gob.mx/';
              _launch(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.balance),
            title: const Text(
              'Comercio',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () async {
              String url = 'https://personasmoralesncivil.insejupy.gob.mx/';
              _launch(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text(
              'Avalúos',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () async {
              String url = 'https://sistemaavaluos.insejupy.gob.mx/';
              _launch(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text(
              'Catastro',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () async {
              String url = 'http://www.insejupy.gob.mx:8040/SGC/Servicios';

              _launch(url);
            },
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Información sobre la privacidad en INSEJUPY',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'EpicaPro',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              'Políticas de Usuario',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const PrivacidadMovil()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              'Políticas de Privacidad',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Privacidad()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              'Normatividad',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Normatividad()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              'Contacto',
              style: TextStyle(
                fontFamily: 'EpicaSansPro',
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const Contacto()),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _launch(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw "Cannot load Url $url";
  }
}
