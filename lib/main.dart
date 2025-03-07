import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Préstamos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E), // Azul oscuro
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// Pantalla de bienvenida
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o imagen
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/tu_imagen.png', // Ruta de tu imagen aquí
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Calculadora de\nPréstamos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Obtenga un préstamo bancario con sólo unos pocos clics',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoanCalculatorScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Empezar', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 5),
                      Icon(Icons.play_arrow, size: 18),
                    ],
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

// Pantalla de cálculo con sliders
class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  double _loanAmount = 10000.0;
  double _loanTerm = 24.0; // en meses
  double _interestRate = 44.0; // porcentaje anual

  // Rangos para los sliders
  final double _minAmount = 1000.0;
  final double _maxAmount = 50000.0;
  final double _minTerm = 6.0;
  final double _maxTerm = 36.0;
  final double _minRate = 10.0;
  final double _maxRate = 50.0;

  void _calculateAndNavigate() {
    // Convertir tasa anual a mensual
    double monthlyInterestRate = _interestRate / 100 / 12;

    // Calcular cuota mensual (interés simple)
    double totalInterest =
        _loanAmount * (_interestRate / 100) * (_loanTerm / 12);
    double totalAmount = _loanAmount + totalInterest;
    double monthlyPayment = totalAmount / _loanTerm;

    // Navegamos a la pantalla de resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LoanDetailsScreen(
              loanAmount: _loanAmount,
              loanTerm: _loanTerm.toInt(),
              interestRate: _interestRate,
              monthlyPayment: monthlyPayment,
              totalInterest: totalInterest,
              totalAmount: totalAmount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Préstamos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de monto del préstamo
            const Text(
              'Monto del préstamo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'S/. ${_loanAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.amber,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.amber,
                overlayColor: Colors.amber.withOpacity(0.3),
                trackHeight: 4.0,
              ),
              child: Slider(
                value: _loanAmount,
                min: _minAmount,
                max: _maxAmount,
                onChanged: (value) {
                  setState(() {
                    _loanAmount = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'S/. ${_minAmount.toInt()}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'S/. ${_maxAmount.toInt()}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Sección de plazo del préstamo
            const Text(
              'Plazo del préstamo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${_loanTerm.toInt()} meses',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.amber,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.amber,
                overlayColor: Colors.amber.withOpacity(0.3),
                trackHeight: 4.0,
              ),
              child: Slider(
                value: _loanTerm,
                min: _minTerm,
                max: _maxTerm,
                divisions: (_maxTerm - _minTerm).toInt(),
                onChanged: (value) {
                  setState(() {
                    _loanTerm = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_minTerm.toInt()} meses',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  '${_maxTerm.toInt()} meses',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Sección de tasa de interés
            const Text(
              'Tasa de interés anual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${_interestRate.toInt()} %',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.amber,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.amber,
                overlayColor: Colors.amber.withOpacity(0.3),
                trackHeight: 4.0,
              ),
              child: Slider(
                value: _interestRate,
                min: _minRate,
                max: _maxRate,
                divisions: (_maxRate - _minRate).toInt(),
                onChanged: (value) {
                  setState(() {
                    _interestRate = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_minRate.toInt()} %',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  '${_maxRate.toInt()} %',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Botón de cálculo
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: _calculateAndNavigate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de detalles del préstamo
class LoanDetailsScreen extends StatelessWidget {
  final double loanAmount;
  final int loanTerm;
  final double interestRate;
  final double monthlyPayment;
  final double totalInterest;
  final double totalAmount;

  const LoanDetailsScreen({
    Key? key,
    required this.loanAmount,
    required this.loanTerm,
    required this.interestRate,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcular la tasa de interés mensual para mostrar
    double monthlyRate = interestRate / 12;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Préstamos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del préstamo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 25),

            // Información del préstamo
            _buildDetailRow(
              'Monto del préstamo',
              'S/ ${loanAmount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 15),

            _buildDetailRow('Periodo en meses', loanTerm.toString()),
            const SizedBox(height: 15),

            _buildDetailRow(
              'Interés mensual %',
              '${monthlyRate.toStringAsFixed(1)} %',
            ),
            const SizedBox(height: 15),

            _buildDetailRow(
              'Cuota mensual',
              'S/ ${monthlyPayment.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 15),

            _buildDetailRow(
              'Total de interés a pagar',
              'S/ ${totalInterest.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 15),

            _buildDetailRow(
              'Total a pagar',
              'S/ ${totalAmount.toStringAsFixed(2)}',
            ),

            const Spacer(),

            // Botón para sacar el préstamo
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuccessScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Saca tu préstamo',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}

// Pantalla de éxito
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.amber, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'Felicidades!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Su crédito fue aprobado',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Volver', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
