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
      visor.add(value);
    });
  }

  void clearVisor() {
    setState(() {
      visor.clear();
    });
  }

  void calculate(List visor) {
    setState(() {
      visor.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(

        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text('You have pushed the button this many times:'),
            Container(
              width: 300,
              height: 50,
              color: Colors.blue,
              child: Align(
                alignment: Alignment.centerRight,
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

            TextButton(
              onPressed: () => clearVisor(),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 235, 174, 174),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('C'),
            ),

            TextButton(
              onPressed: () => addToVisor('0'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('0'),
            ),

            TextButton(
              onPressed: () => addToVisor('1'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('1'),
            ),

            TextButton(
              onPressed: () => addToVisor('2'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('2'),
            ),

            TextButton(
              onPressed: () => addToVisor('3'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('3'),
            ),

            TextButton(
              onPressed: () => addToVisor('4'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('4'),
            ),

            TextButton(
              onPressed: () => addToVisor('5'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('5'),
            ),

            TextButton(
              onPressed: () => addToVisor('6'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('6'),
            ),

            TextButton(
              onPressed: () => addToVisor('7'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('7'),
            ),

            TextButton(
              onPressed: () => addToVisor('8'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('8'),
            ),

            TextButton(
              onPressed: () => addToVisor('9'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 231, 226, 226),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('9'),
            ),

            TextButton(
              onPressed: () => addToVisor('+'),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 235, 174, 174),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('+'),
            ),

            TextButton(
              onPressed: () => calculate(visor),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Color.fromARGB(255, 235, 174, 174),
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('='),
            ),           
          ],
        ),
      ),
    );
  }
}
