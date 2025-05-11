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
      title: 'Calculator',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

    List visor = [];

    void addToVisor(String value) {
        setState(() {
            List<String> operacoes = ['+', '-', 'x', '÷'];

            // Lidar com o decimal (.)
            if (value == '.') {
                if (visor.isNotEmpty) {
                    if (visor.last == '.') {
                        return; // Não adiciona dois decimais seguidos
                    }
                    // Não adiciona dois decimais em um número
                    for (int i=visor.length-1; i>=0; i--) {
                        if (visor[i] == '.') {
                            return;
                        }
                        if (operacoes.contains(visor[i])) {
                            break;
                        }
                    }
                }

                // Adiciona um zero antes do decimal
                // - se . for o primeiro digitado no início ou após de uma operação
                if (visor.isEmpty) {
                    visor.add('0'); 
                }
                if (visor.isNotEmpty && operacoes.contains(visor.last)) {
                    visor.add('0');
                }
            }

            // Não adiciona nada além de números no início
            if (visor.isEmpty && operacoes.contains(value)) {
                return;
            }

            // Não adiciona um caractere especial seguido de outro
            if (visor.isNotEmpty && operacoes.contains(visor.last) && operacoes.contains(value)) {
                return;
            }

            visor.add(value);
        });
    }

    void clearVisor() {
        setState(() {
            visor.clear();
        });
    }

    void clearLast() {
        setState(() {
            if (visor.isNotEmpty) {
                visor.removeLast();
            }
        });
    }

    void calculate() {
        setState(() {
            // cria a primeira leva de listas auxiliares
            var (expressao, operacoes, numeros, multDiv, somaSub) = _listasAuxiliares();

            if (operacoes.length == numeros.length) {
                return; // Formato inválido
            }

            
            // primeiro, faz os cálculos de multiplicação e divisão
            for (int i=0; i<multDiv.length; i++) {
                String operador = multDiv[i];
                String tempResultado = '';
                
                for (int j=0; j<visor.length; j++) {
                    if (operador == visor[j]) {
                        if (operador == 'x') {
                            tempResultado = (double.parse(visor[j - 1]) * double.parse(visor[j + 1])).toString();
                        } else if (operador == '÷') {
                            tempResultado = (double.parse(visor[j - 1]) / double.parse(visor[j + 1])).toString();
                        }
                        visor[j+1] = tempResultado;
                        visor.removeAt(j - 1);
                        visor.removeAt(j - 1);
                    }
                }
            }

            // atualiza as listas auxiliares após os cálculos de multiplicação e divisão
            (expressao, operacoes, numeros, multDiv, somaSub) = _listasAuxiliares();

            // segundo, faz os cálculos de soma e subtração
            double result = double.parse(numeros[0]);
            for (int i=0; i<somaSub.length; i++) {
                String operador = somaSub[i];
                double numero = double.parse(numeros[i + 1]);
                
                if (operador == '+') {
                    result += numero;
                } else if (operador == '-') {
                    result -= numero;
                }
            }

            visor.clear();

            // Remove o decimal se for inteiro
            if (result % 1 == 0) {
                int resultInt = result.toInt();
                visor.add(resultInt.toString()); return;
            }
            
            visor.add(result.toString());
        });
    }

    (String, List<String>, List<String>, List<String>, List<String>) _listasAuxiliares() {
        String expressao = visor.join(''); // Transforma a lista em uma string única
        List<String> operacoes = expressao.split(RegExp(r'[^+\-x÷]')).where((element) => element.isNotEmpty).toList();
        List<String> numeros = expressao.split(RegExp(r'[+\-x÷]')).where((element) => element.isNotEmpty).toList();
        List<String> multDiv = expressao.split(RegExp(r'[^x÷]')).where((element) => element.isNotEmpty).toList();
        List<String> somaSub = expressao.split(RegExp(r'[^+\-]')).where((element) => element.isNotEmpty).toList();
        return (expressao, operacoes, numeros, multDiv, somaSub);
    }

    @override
    Widget build(BuildContext context) {
        
        return Scaffold(
            backgroundColor: Color.fromARGB(255, 31, 32, 36),
            body: Center(
                

                child: Column(
                
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Container(
                                    width: 350,
                                    height: 150,
                                    color: Color.fromARGB(255, 0, 79, 77),
                                    child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                                visor.join(''),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                            ],
                        ),

                        SizedBox(height: 30,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                TextButton(
                                    onPressed: () => clearVisor(),
                                    
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 202, 163, 177),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('C',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 190,),

                                TextButton(
                                    onPressed: () => clearLast(),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 202, 163, 177),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('<-',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),
                            ],
                        ),

                        SizedBox(height: 10,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                TextButton(
                                    onPressed: () => addToVisor('7'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('7',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('8'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('8',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('9'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('9',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('x'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 0, 79, 77),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('x',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                            ],
                        ),

                        SizedBox(height: 10,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                TextButton(
                                    onPressed: () => addToVisor('4'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('4',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('5'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('5',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('6'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('6',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('-'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 0, 79, 77),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('-',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                            ],
                        ),

                        SizedBox(height: 10,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                TextButton(
                                    onPressed: () => addToVisor('1'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('1',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('2'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('2',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('3'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('3',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('+'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 0, 79, 77),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('+',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                            ],
                        ),

                        SizedBox(height: 10,),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                TextButton(
                                    onPressed: () => addToVisor('.'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 98, 122, 110),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('0'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 75, 73, 82),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('0',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => calculate(),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 98, 122, 110),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('=',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                                SizedBox(width: 10,),

                                TextButton(
                                    onPressed: () => addToVisor('÷'),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                        backgroundColor: Color.fromARGB(255, 0, 79, 77),
                                        padding: const EdgeInsets.all(30.0),
                                        textStyle: const TextStyle(fontSize: 20),
                                        minimumSize: const Size(80, 60),
                                    ),
                                    child: const Text('÷',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),

                            ],
                        ),

                        
                    ],
                ),
            ),
        );
    }
}
