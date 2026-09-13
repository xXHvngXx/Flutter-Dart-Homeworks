import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  bool _isNewNumber = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _firstOperand = '';
        _operator = '';
        _isNewNumber = true;
      } else if (value == 'CE') {
        _display = '0';
        _isNewNumber = true;
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
          _isNewNumber = true;
        }
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _firstOperand = _display;
        _operator = value;
        _isNewNumber = true;
      } else if (value == '=') {
        if (_firstOperand.isNotEmpty && _operator.isNotEmpty) {
          double num1 = double.tryParse(_firstOperand) ?? 0;
          double num2 = double.tryParse(_display) ?? 0;
          double result = 0;

          switch (_operator) {
            case '+':
              result = num1 + num2;
              break;
            case '-':
              result = num1 - num2;
              break;
            case '×':
              result = num1 * num2;
              break;
            case '÷':
              result = num2 != 0 ? num1 / num2 : 0;
              break;
          }

          _display = result % 1 == 0 ? result.toInt().toString() : result.toString();
          _firstOperand = '';
          _operator = '';
          _isNewNumber = true;
        }
      } else if (value == '+/-') {
        if (_display != '0') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
      } else if (value == '.') {
        if (!_display.contains('.')) {
          _display += '.';
          _isNewNumber = false;
        }
      } else {
        if (_isNewNumber || _display == '0') {
          _display = value;
          _isNewNumber = false;
        } else {
          _display += value;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? bgColor, Color? textColor, bool isBold = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.0), // Khe hở cực nhỏ 1px giữa các nút
        child: SizedBox.expand( 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor ?? const Color(0xFFF9F9F9),
              foregroundColor: textColor ?? Colors.black,
              elevation: 0.5,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero, 
            ),
            onPressed: () => _onButtonPressed(text),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 22, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryBtn(String text, {bool enabled = true}) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: enabled ? () {} : null,
        child: Text(
          text,
          style: TextStyle(
            color: enabled ? Colors.black87 : Colors.black26,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, {bool isActive = false}) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3,
            height: 18,
            color: isActive ? const Color(0xFF005A9E) : Colors.transparent,
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            size: 18,
            color: isActive ? const Color(0xFF005A9E) : Colors.black87,
          ),
        ],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? const Color(0xFF005A9E) : Colors.black87,
        ),
      ),
      hoverColor: const Color(0x1F000000),
      selected: isActive,
      selectedTileColor: const Color(0x1F000000),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        titleSpacing: 0,
        title: const Row(
          children: [
            Text(
              "Standard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.open_in_full, size: 16, color: Colors.black54),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        width: 260,
        backgroundColor: const Color(0xFFE8E8E8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 40),
            _buildSectionHeader("Calculator"),
            _buildNavItem(Icons.calculate, "Standard", isActive: true),
            _buildNavItem(Icons.science_outlined, "Scientific"),
            _buildNavItem(Icons.show_chart, "Graphing"),
            _buildNavItem(Icons.code, "Programmer"),
            _buildNavItem(Icons.calendar_today_outlined, "Date calculation"),
            const SizedBox(height: 8),
            _buildSectionHeader("Converter"),
            _buildNavItem(Icons.attach_money, "Currency"),
            _buildNavItem(Icons.widgets_outlined, "Volume"),
            _buildNavItem(Icons.straighten, "Length"),
            _buildNavItem(Icons.scale_outlined, "Weight and mass"),
            _buildNavItem(Icons.thermostat_outlined, "Temperature"),
            _buildNavItem(Icons.local_fire_department_outlined, "Energy"),
            _buildNavItem(Icons.crop_square, "Area"),
            _buildNavItem(Icons.speed, "Speed"),
            const Divider(),
            _buildNavItem(Icons.settings_outlined, "Settings"),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Màn hình hiển thị số
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            // Hàng nút Memory (MC, MR, M+, M-, MS, M~)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  _buildMemoryBtn("MC", enabled: false),
                  _buildMemoryBtn("MR", enabled: false),
                  _buildMemoryBtn("M+"),
                  _buildMemoryBtn("M-"),
                  _buildMemoryBtn("MS"),
                  _buildMemoryBtn("M~", enabled: false),
                ],
              ),
            ),
            // Toàn bộ lưới nút máy tính
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("%"),
                          _buildButton("CE"),
                          _buildButton("C"),
                          _buildButton("⌫"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("¹/x"),
                          _buildButton("x²"),
                          _buildButton("²√x"),
                          _buildButton("÷"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("7", bgColor: Colors.white, isBold: true),
                          _buildButton("8", bgColor: Colors.white, isBold: true),
                          _buildButton("9", bgColor: Colors.white, isBold: true),
                          _buildButton("×"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("4", bgColor: Colors.white, isBold: true),
                          _buildButton("5", bgColor: Colors.white, isBold: true),
                          _buildButton("6", bgColor: Colors.white, isBold: true),
                          _buildButton("-"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("1", bgColor: Colors.white, isBold: true),
                          _buildButton("2", bgColor: Colors.white, isBold: true),
                          _buildButton("3", bgColor: Colors.white, isBold: true),
                          _buildButton("+"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("+/-", bgColor: Colors.white),
                          _buildButton("0", bgColor: Colors.white, isBold: true),
                          _buildButton(".", bgColor: Colors.white),
                          _buildButton(
                            "=",
                            bgColor: const Color(0xFF005A9E),
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}