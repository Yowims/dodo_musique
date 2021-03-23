import 'package:app_settings/app_settings.dart';
import 'package:dodo_musique/Views/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessDenied extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "L'application a besoin d'accéder à vos fichiers pour récupérer vos musiques. Veuillez redémarrer l'application et taper sur \"Accepter\", ou bien ouvrir les paramètres avec le bouton ci-dessous. Une fois la permission donnée, rappuyez sur ce bouton ou redémarrez l'application.",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await Permission.storage.isDenied)
                      AppSettings.openAppSettings();
                    else
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                  },
                  child: Image.asset("assets/settings_icon.png"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
