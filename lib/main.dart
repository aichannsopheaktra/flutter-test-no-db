import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber, // Set the primary color
        accentColor: Colors.black,  // Set the accent color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber, // Set AppBar background color
          iconTheme: IconThemeData(
            color: Colors.black, // Set back button color in AppBar
          ),
          titleTextStyle: TextStyle(
            color: Colors.black, // Set AppBar title text color
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber, // Set ElevatedButton background color
            textStyle: TextStyle(
              color: Colors.black, // Set ElevatedButton text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.amber, // Set the background color of TextFields
          labelStyle: TextStyle(color: Colors.black), // Set the label text color
        ),
      ),
      home: HashVerificationScreen(),
    );
  }
}


class HashVerificationScreen extends StatefulWidget {
  @override
  _HashVerificationScreenState createState() => _HashVerificationScreenState();
}

class _HashVerificationScreenState extends State<HashVerificationScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _hashController = TextEditingController();
  String _generatedHash = '';
  String _verificationResult = '';

  // Array to store normal strings
  final List<String> _storedStrings = [];

  // Function to hash a text using SHA-512
  String generateHash(String input) {
    return sha512.convert(utf8.encode(input)).toString();
  }

  // Function to verify if the hash matches any hash generated from the stored strings
  bool verifyHash(String inputHash) {
    for (String storedString in _storedStrings) {
      if (generateHash(storedString) == inputHash) {
        return true;
      }
    }
    return false;
  }

  // Function to add a new string to the array
  void addString(String newString) {
    setState(() {
      _storedStrings.add(newString);
    });
  }

  // Callback to handle adding string from InputScreen
  void handleAddString(String newString) {
    addString(newString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SHA-512 Hash & Verify',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Custom color for this text
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  fillColor: Colors.amber, // Set the background color
                  filled: true, // Make sure the fill color is applied
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Set the background color
                ),
                onPressed: () {
                  setState(() {
                    _generatedHash = generateHash(_textController.text);
                  });
                },
                child: Text(
                  'Generate Hash',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Custom color for this text
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Generated SHA-512 Hash:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(_generatedHash),
              SizedBox(height: 32),
              TextField(
                controller: _hashController,
                decoration: InputDecoration(
                  labelText: 'Enter Hash to Verify',
                  fillColor: Colors.amber, // Set the background color
                  filled: true, // Make sure the fill color is applied
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Set the background color
                ),
                onPressed: () {
                  setState(() {
                    bool isMatch = verifyHash(_hashController.text);
                    _verificationResult = isMatch ? 'Match Found' : 'No Match';
                  });
                },
                child: Text(
                  'Verify Hash',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Custom color for this text
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Verification Result: $_verificationResult',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _verificationResult == 'No Match'
                      ? Colors.red
                      : Colors.green,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Set the background color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputScreen(
                        onAddString: handleAddString,
                        storedStrings: _storedStrings,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Open Input Screen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Custom color for this text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  final Function(String) onAddString;
  final List<String> storedStrings;

  InputScreen({required this.onAddString, required this.storedStrings});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _savedString = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Screen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Custom color for this text
            )),
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Set the back button color to black
          onPressed: () {
            Navigator.pop(context); // Default back button behavior
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Enter a String',
                  fillColor: Colors.amber, // Set the background color
                  filled: true, // Make sure the fill color is applied
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Set the background color
                ),
                onPressed: () {
                  setState(() {
                    _savedString = _inputController.text;
                  });
                  widget.onAddString(_savedString);
                },
                child: Text(
                  'Save String',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Custom color for this text
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Stored Strings:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...widget.storedStrings
                  .map((storedString) => Text(storedString))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
