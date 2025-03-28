import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/biblioteca_articulos/biblioteca_screen.dart';
import 'screens/almacen/almacen_screen.dart';
import 'screens/usuarios/usuarios_screen.dart';
import 'screens/reportes/reportes_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 👈 Esta línea elimina el banner
      title: 'Flutter Web Proyecto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/biblioteca': (context) => BibliotecaScreen(),
        '/almacen': (context) => ArticulosXUsuarioScreen(),
        '/usuarios': (context) => UsuariosScreen(),
        '/reportes': (context) => ReportesScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
