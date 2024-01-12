import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Kalkulator Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.transparent), // Ganti warna utama
        hintColor: Colors.red, // Ganti warna aksen
        useMaterial3: true,
      ),
      home: const MyCalculator(title: 'Kalkulator Flutter'),
    );
  }
}

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key, required this.title});
  final String title;

  @override
  State<MyCalculator> createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  String _output = '0';
  String _currentInput = '';
  String _operator = '';
  double _result = 0;

  void _onNumberClick(String value) {
    setState(() {
      if (_result != 0 && !_operator.isNotEmpty) {
        // Reset hasil operasi sebelumnya jika tidak ada operator yang dipilih
        _result = 0;
        _currentInput = value;
      } else {
        if (_currentInput == '0' && !value.contains('.')) {
          _currentInput = value;
        } else if (!(_currentInput.contains('.') && value == '.')) {
          _currentInput += value;
        }
      }
    });
  }

  void _onBackspaceClick() {
    setState(() {
      if (_currentInput.isNotEmpty) {
        // Hapus karakter terakhir
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      }
      if (_currentInput.isEmpty) {
        // Jika tidak ada karakter lagi, reset ke '0'
        _currentInput = '0';
      }
    });

    // Reset hasil operasi jika pengguna menekan tombol backspace setelah hasil operasi
    if (_result != 0) {
      _result = 0;
    }
  }

  void _onOperatorClick(String operator) {
    setState(() {
      if (_operator.isNotEmpty && _currentInput.isNotEmpty) {
        // Jika sudah ada operator dan angka yang dimasukkan, hitung hasilnya terlebih dahulu
        _calculateResult();
        _operator = operator;
        _currentInput = '';
      } else if (_currentInput.isNotEmpty) {
        // Jika hanya ada angka yang dimasukkan, set operator dan siapkan untuk angka berikutnya
        _operator = operator;
        _result = double.parse(_currentInput);
        _currentInput = '';
      } else if (_result != 0) {
        // Jika hasil operasi sebelumnya tidak nol, set operator baru
        _operator = operator;
      }
      // Jika tidak ada angka yang dimasukkan, operator tidak diubah
    });
  }

  void _onEqualsClick() {
    setState(() {
      if (_operator.isNotEmpty && _currentInput.isNotEmpty) {
        // Jika ada operator dan angka yang dimasukkan, hitung hasilnya
        _calculateResult();
        _operator = '';
      } else if (_currentInput.isNotEmpty) {
        // Jika hanya ada angka yang dimasukkan, gunakan operator terakhir dan hitung hasilnya
        _operator = _operator;
        _calculateResult();
      }
      // Jika tidak ada angka yang dimasukkan, tidak ada tindakan yang diambil
    });
  }

  void _onClearClick() {
    setState(() {
      _currentInput = '0';
      _operator = '';
      _result = 0;
    });
  }

  void _calculateResult() {
    double currentInput = double.parse(_currentInput);

    switch (_operator) {
      case '+':
        _result += currentInput;
        break;
      case '-':
        _result -= currentInput;
        break;
      case '*':
        _result *= currentInput;
        break;
      case '/':
        _result /= currentInput;
        break;
    }

    if (_result.isNaN || _result.isInfinite) {
      _output = 'Error';
    } else {
      // Konversi hasil ke string dengan format sesuai kebutuhan
      _output = _formatResult(_result);
      _currentInput = _output;
    }
  }

  String _formatResult(double result) {
    // If the result is an integer, display it without decimals
    if (result % 1 == 0) {
      return result.toInt().toString();
    }

    // Use toStringAsFixed to limit the number of decimal places
    String resultString =
        result.toStringAsFixed(10).replaceAll(RegExp(r'0*$'), '');

    // Remove the decimal point if there are no remaining digits after it
    resultString = resultString.replaceAll(RegExp(r'\.$'), '');

    return resultString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: Text(
              _currentInput,
              style: TextStyle(fontSize: 64.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/'),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*'),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('⌫', isSpecial: true),
              _buildButton('+'),
            ],
          ),
          SizedBox(height: 10.0), // Adjusted spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Ganti 8.0 dengan nilai padding yang Anda inginkan
                  child: _buildButton('C'),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          16.0), // Ganti 8.0 dengan nilai padding yang Anda inginkan
                  child: _buildButton('='),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildButton(String text, {bool isSpecial = false}) {
    return ElevatedButton(
      onPressed: () {
        if (isSpecial) {
          _onBackspaceClick();
        } else if (text == 'C') {
          _onClearClick();
        } else if (text == '=') {
          _onEqualsClick();
        } else if (text == '+' || text == '-' || text == '*' || text == '/') {
          _onOperatorClick(text);
        } else {
          _onNumberClick(text);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20.0),
        backgroundColor: Colors.lightBlueAccent, // Ganti warna tombol '='
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Ganti bentuk sudut tombol
        ),
        elevation: 4.0, // Atur ketinggian bayangan
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: isSpecial ? 16.0 : 20.0),
      ),
    );
  }
}
