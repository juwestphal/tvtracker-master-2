import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> updateEmail() async {
    final newEmail = _emailController.text;
    if (newEmail.isEmpty) {
      _showError('Por favor, insira um email válido.');
      return;
    }

    setState(() => isLoading = true);
    try {
      // Call your API to update the email
      // Example: await APIService().updateEmail(newEmail);
      _showSuccess('Email atualizado com sucesso!');
      _emailController.clear();
    } catch (e) {
      _showError('Erro ao atualizar email: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      _showError('Por favor, preencha todos os campos.');
      return;
    }

    setState(() => isLoading = true);
    try {
      // Call your API to change the password
      // Example: await APIService().changePassword(currentPassword, newPassword);
      _showSuccess('Senha alterada com sucesso!');
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      _showError('Erro ao alterar a senha: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void logOut() {
    // Clear any stored tokens or session information
    // Navigate back to login screen
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.red))),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.green))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section to update email
                  const Text('Alterar Email',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Novo Email'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: updateEmail,
                    child: const Text('Atualizar Email'),
                  ),
                  const SizedBox(height: 20),

                  // Section to change password
                  const Text('Alterar Senha',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(labelText: 'Senha Atual'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: 'Nova Senha'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: changePassword,
                    child: const Text('Alterar Senha'),
                  ),
                  const SizedBox(height: 20),

                  // Log out button
                  const Text('Sair',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: logOut,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
    );
  }
}
