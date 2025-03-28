import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/usuario.dart';
import '../../services/usuario_service.dart';
import '../../styles/app_colors.dart'; // Importa el archivo de colores
import 'agregar_usuario_screen.dart';
import 'editar_usuario_screen.dart';

class UsuariosScreen extends StatelessWidget {
  final UsuarioService _usuarioService =
      UsuarioService(FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddUserDialog(context);
            },
            iconSize: 30.0,
            color: AppColors.addButton, // Usa el color definido
          ),
        ],
      ),
      body: StreamBuilder<List<Usuario>>(
        stream: _usuarioService.getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay usuarios disponibles.'));
          } else {
            final usuarios = snapshot.data!;
            return ListView.separated(
              itemCount: usuarios.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.divider,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      usuario.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(usuario.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditUserDialog(context, usuario);
                          },
                          iconSize: 24.0,
                          color: AppColors.editButton, // Usa el color definido
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteUser(context, usuario);
                          },
                          iconSize: 24.0,
                          color:
                              AppColors.deleteButton, // Usa el color definido
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgregarUsuarioScreen()),
    );
  }

  void _showEditUserDialog(BuildContext context, Usuario usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditarUsuarioScreen(usuario: usuario)),
    );
  }

  void _deleteUser(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Usuario'),
          content: Text('¿Estás seguro de que deseas eliminar a este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _usuarioService.deleteUsuario(usuario.uid);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Usuario eliminado')),
                );
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
