import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return Center(child: Text('No hay usuario logueado.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  DashboardTile(
                      title: 'Grupo Sanchez', icon: Icons.business, route: '/'),
                  DashboardTile(
                      title: 'Usuario Logeado',
                      icon: Icons.person,
                      route: '/profile'),
                  DashboardTile(
                      title: 'Reportes',
                      icon: Icons.assessment,
                      route: '/reportes'),
                  DashboardTile(
                      title: 'Usuarios',
                      icon: Icons.people,
                      route: '/usuarios'),
                  DashboardTile(
                      title: 'Almacén', icon: Icons.store, route: '/almacen'),
                  DashboardTile(
                      title: 'Biblioteca de Artículos',
                      icon: Icons.library_books,
                      route: '/biblioteca'),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  DashboardTile({required this.title, required this.icon, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (route.isNotEmpty) {
            Navigator.pushNamed(context, route);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
