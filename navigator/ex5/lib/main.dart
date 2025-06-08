import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}


final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final nome = state.uri.queryParameters['nome'] ?? 'Usuário';
        return TelaPrincipal(nomeUsuario: nome);
      },
    ),
  ],
);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Login com GoRouter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
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

    if (usuario.isEmpty || senha != 'admin') {
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
      context.go('/home?nome=$usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
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
              obscureText: true,
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


class TelaPrincipal extends StatefulWidget {
  final String nomeUsuario;
  const TelaPrincipal({super.key, required this.nomeUsuario});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}


class _TelaPrincipalState extends State<TelaPrincipal> {
  int _itemSelecionado = 0;
  late final List<Widget> _subtelas;

  final List<String> _disciplinasADS = [
    'Algoritmos',
    'Programação Orientada a Objetos',
    'Estruturas de Dados',
    'Banco de Dados',
    'Engenharia de Software',
    'Redes de Computadores',
    'Sistemas Operacionais',
    'Desenvolvimento Web',
    'Matemática Discreta',
    'Projeto de Extensão',
  ];

  @override
  void initState() {
    super.initState();
    _subtelas = [
      _dashboard(),
      _disciplinas(),
    ];
  }

  Widget _dashboard() {
    String sugestao = _disciplinasADS[Random().nextInt(_disciplinasADS.length)];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Você está logado!'),
          const SizedBox(height: 20),
          Text('Ficamos felizes em ver você, ${widget.nomeUsuario}'),
          const SizedBox(height: 20),
          Image.network(
            'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExMnpkZHB0d3c3aWZnc3Q1ZW90czlzcXozcm05ZmdjMWt4bmU1ZWR6NiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/lJNoBCvQYp7nq/giphy.gif',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text('Sugestão de estudo: $sugestao'),
        ],
      ),
    );
  }

  Widget _disciplinas() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Lista de Disciplinas (exemplo)')),
        ],
      ),
    );
  }

  void _sair() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/');
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bem-vindo :D'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: _subtelas[_itemSelecionado],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 76, 175, 101),
          selectedItemColor: Colors.white,
          currentIndex: _itemSelecionado,
          onTap: (idx) {
            setState(() {
              if (idx == 2) {
                _sair();
                return;
              }
              if (idx == 0) {
                _subtelas[0] = _dashboard();
              }
              _itemSelecionado = idx;
            });
          },
          items: const [
            BottomNavigationBarItem(label: 'Dashboard', icon: Icon(Icons.home), backgroundColor: Colors.red),
            BottomNavigationBarItem(label: 'Disciplinas', icon: Icon(Icons.menu_open)),
            BottomNavigationBarItem(label: 'Sair', icon: Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}
