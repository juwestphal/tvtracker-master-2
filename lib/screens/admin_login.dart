import 'package:flutter/material.dart';
import 'admin_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  AdminLoginPageState createState() => AdminLoginPageState();
}

class AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loginAdmin() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Replace with proper API login call if necessary
      if (_usernameController.text == 'admin' &&
          _passwordController.text == 'admin123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      } else {
        throw 'Credenciais inválidas.';
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: loginAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Fundo do botão em vermelho
                foregroundColor: Colors.white, // Texto branco dentro do botão
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ), // Padding opcional para melhor design
              ),
              child: const Text(
                'Entrar',
                style:
                    TextStyle(fontWeight: FontWeight.bold), // Texto em negrito
              ),
            ),
          ],
        ),
      ),
    );
  }
}
