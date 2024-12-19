import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('À propos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'À propos de l\'application',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Cette application Todo a été réalisée par notre groupe dans le cadre du cours de développement d\'applications mobiles. Elle permet de gérer des tâches avec une interface intuitive et des fonctionnalités robustes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Membres du groupe :',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('- Membre 1: AGNIDE Akim'),
            Text('- Membre 2: AKONAKPO Sandrine'),
            Text('- Membre 3: DAGBINDE Benoite'),
            Text('- Membre 4: HOUDJI Crezus'),
            Text('- Membre 5: LAHAN Hapiness'),
          ],
        ),
      ),
    );
  }
}
