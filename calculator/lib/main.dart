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
                    if (visor.last == '.' || visor.last.contains('.')) {
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
            if (visor.isEmpty) {
                return;
            }

            bool inicioNegativo = false;
            // cria a primeira leva de listas auxiliares
            var (expressao, operacoes, numeros, multDiv, somaSub) = _listasAuxiliares();

            if (operacoes.contains(visor.last)) {
                return; // Formato inválido
            }

            if (operacoes[0] == '-' && visor[0] == '-' && somaSub[0] == '-') {
                inicioNegativo = true;
                operacoes.removeAt(0);
                visor.removeAt(0);
                somaSub.removeAt(0);
            }

            if (operacoes.isNotEmpty) {
                // primeiro, faz os cálculos de multiplicação e divisão
                for (int i=0; i<multDiv.length; i++) {
                    String operador = multDiv[i];
                    double tempResultado = 0;
                    int qtdUsada = 0;
                    
                    for (int j=0; j<visor.length; j++) {
                        // encontra o operador em relação a toda a expressão
                        if (operador == visor[j]) {
                            
                            // lógica para formar o número anterior e posterior do operador - caso dos decimais
                            String numAnterior = '';
                            int cont = j - 1;
                            while (cont >= 0) {
                                if (operacoes.contains(visor[cont])) {
                                    break;
                                }
                                numAnterior = visor[cont] + numAnterior;
                                qtdUsada++;
                                cont--;
                            }

                            String numPosterior = '';
                            cont = j + 1;
                            while (cont < visor.length) {
                                if (operacoes.contains(visor[cont])) {
                                    break;
                                }
                                numPosterior = numPosterior + visor[cont];
                                qtdUsada++;
                                cont++;
                            }


                            if (operador == 'x') {
                                tempResultado = (double.parse(numAnterior) * double.parse(numPosterior));
                            } else if (operador == '÷') {
                                if (visor[j + 1] == '0') { return; }
                                tempResultado = (double.parse(numAnterior) / double.parse(numPosterior));
                            }

                            // no caso de multiplicação e divisão, basta inverter o sinal do resultado da operação
                            if (inicioNegativo && operador == operacoes[0]) {
                                inicioNegativo = false;
                                tempResultado = tempResultado * (-1);
                            }

                            int fimDaExpressao = j + 1;
                            while (fimDaExpressao < visor.length && !operacoes.contains(visor[fimDaExpressao])) {
                                fimDaExpressao++;
                            }
                            visor[fimDaExpressao-1] = tempResultado.toString();

                            // remove os números/operação que foram usados na operação, e adiciona o resultado ao fim do segmento da expressão
                            if (visor.length + 1 > fimDaExpressao) {
                                fimDaExpressao--;
                            }
                            visor[fimDaExpressao] = tempResultado.toString();
                            while (qtdUsada > 0) {
                                if (fimDaExpressao > 0) {
                                    visor.removeAt(fimDaExpressao - 1);
                                }
                                qtdUsada--;
                                fimDaExpressao--;
                            }
                        }
                    }
                }
            }

            // atualiza as listas auxiliares após os cálculos de multiplicação e divisão
            (expressao, operacoes, numeros, multDiv, somaSub) = _listasAuxiliares();
            double result = double.parse(numeros[0]);
            
            if (operacoes.length == numeros.length && numeros.length != 1) {
                operacoes.removeAt(0);
                somaSub.removeAt(0);
                inicioNegativo = true;
            } else if (operacoes.length == numeros.length && numeros.length == 1) {
                result = result * (-1);
                somaSub.removeAt(0);
            }
            
            if (operacoes.isNotEmpty && somaSub.isNotEmpty) {
                // segundo, faz os cálculos de soma e subtração
                for (int i=0; i<somaSub.length; i++) {
                    String operador = somaSub[i];
                    double numero = double.parse(numeros[i + 1]);

                    // no caso de soma e subtração, basta inverter o sinal do número à esquerda do operador (que tinha originalmente o sinal negativo)
                    if (inicioNegativo && operador == operacoes[0]) {
                        inicioNegativo = false;
                        result = result * (-1);
                    }
                    
                    if (operador == '+') {
                        result += numero;
                    } else if (operador == '-') {
                        result -= numero;
                    }
                }
            }

             _exibirResultado(result);
        });
    }

    void _exibirResultado(double result) {
        visor.clear();

        if (result.isNegative) {
            String finalResult = (result % 1 == 0) ? result.abs().toInt().toString() : result.abs().toString();
            visor.add('-'); 
            visor.add(finalResult); return;
        }
        else if (result % 1 == 0) {
            visor.add(result.toInt().toString()); return;
        }
        visor.add(result.toString());
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
                                        backgroundColor: Color.fromARGB(255, 101, 145, 103),
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
                                        backgroundColor: Color.fromARGB(255, 101, 145, 103),
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
