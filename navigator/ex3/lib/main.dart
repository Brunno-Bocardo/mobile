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
          builder: (context) => TelaPrincipal(
            nomeUsuario: _usuarioController.text.trim(),
            // .text - Pega o texto do TextEditingController
            // .trim() - Remove espaços em branco no início e no final
          ),
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


class TelaPrincipal extends StatefulWidget {
  final String nomeUsuario;
  const TelaPrincipal({super.key, required this.nomeUsuario});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}


class _TelaPrincipalState extends State<TelaPrincipal> {
  int _itemSelecionado = 0;
  late final List<Widget> _subtelas;

  @override
  void initState() {
    super.initState();
    _subtelas = [
      _dashboard(),
      _disciplinas(),
    ];
  }

  Widget _dashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Você está logado!'),
          const SizedBox(height: 20),
          Text('Ficamos felizes em ver você, ${widget.nomeUsuario}'),
          const SizedBox(height: 20),
          Text('Aproveite esse GIF de gatinho'),
          SizedBox(height: 20),
          Image.network(
            'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExMnpkZHB0d3c3aWZnc3Q1ZW90czlzcXozcm05ZmdjMWt4bmU1ZWR6NiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/lJNoBCvQYp7nq/giphy.gif',
            width: 200,
            height: 200,
          ),
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
            onPressed: () => Navigator.of(context).pop(), // fecha o contexto atual (AlertDialog)
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Fecha o AlertDialog e a TelaPrincipal - retorna para a tela de Login
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
        // A seta de Back vem por padrão na AppBar
        // Ela automaticamente faz um navigate.pop(context)
        // Se quiser remover a seta, usar -> `automaticallyImplyLeading: false`
        appBar: AppBar(
          title: const Text('Bem-vindo :D'),
          automaticallyImplyLeading: false,
        ),

        // o body será mostrado conforme o item selecionado
        // no BottomNavigationBar
        body: Center(
          child: _subtelas[_itemSelecionado], // índice define a tela
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
