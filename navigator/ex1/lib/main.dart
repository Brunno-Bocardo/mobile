import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();


  void _tentarLogin() {
    String usuario = _usuarioController.text.trim();
    String senha = _senhaController.text;
    String? _erro;

    if (usuario.isEmpty || senha != 'admin') {
      setState(() {
        _erro = "Usuário em branco ou senha incorreta!";
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Usuário em branco ou senha incorreta.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _erro = null;
      });

      // Avança para próxima tela
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TelaPrincipal(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP Bar 
      appBar: AppBar(title: const Text('Login')),

      // Corpo da tela
      body: Padding(  // Padding para o corpo da tela
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true, // Oculta o texto da senha - Formato de senha
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _tentarLogin,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}


class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A seta de Back vem por padrão na AppBar
      // Ela automaticamente faz um navigate.pop(context)
      // Se quiser remover a seta, usar -> `automaticallyImplyLeading: false`
      appBar: AppBar(title: const Text('Início')),

      body: const Center(
        child: Text('Você está logado :D'),
      ),
    );
  }
}
