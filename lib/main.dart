import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: TextTheme(
          titleMedium: TextStyle(fontSize: 18.0, color: Colors.teal[800]),
          bodyMedium: TextStyle(fontSize: 16.0, color: Colors.teal[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const FormularioPersona(),
    );
  }
}

class FormularioPersona extends StatefulWidget {
  const FormularioPersona({super.key});

  @override
  FormularioPersonaState createState() => FormularioPersonaState();
}

class FormularioPersonaState extends State<FormularioPersona> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  String _genero = '';
  bool _casado = false;
  int _edad = 0;

  void _calcularEdad(String fechaNacimiento) {
    if (fechaNacimiento.isNotEmpty) {
      try {
        DateTime fecha = DateFormat('yyyy-MM-dd').parseStrict(fechaNacimiento);
        DateTime hoy = DateTime.now();
        setState(() {
          _edad = hoy.year - fecha.year;
          if (hoy.month < fecha.month || (hoy.month == fecha.month && hoy.day < fecha.day)) {
            _edad--;
          }
        });
      } catch (_) {
        setState(() {
          _edad = 0;
        });
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Formulario válido', style: TextStyle(color: Colors.teal)),
          content: const Text('Todos los campos son correctos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Persona'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 10 || int.tryParse(value) == null) {
                    return 'Ingrese una cédula válida (10 dígitos)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombresController,
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese sus nombres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apellidosController,
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento (YYYY-MM-DD)',
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                keyboardType: TextInputType.datetime,
                onChanged: (value) => _calcularEdad(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese su fecha de nacimiento';
                  }
                  try {
                    DateFormat('yyyy-MM-dd').parseStrict(value);
                  } catch (_) {
                    return 'Formato de fecha inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Edad: $_edad años', style: const TextStyle(fontSize: 16.0, color: Colors.teal)),
              const SizedBox(height: 16),
              const Text('Género:', style: TextStyle(fontSize: 16.0, color: Colors.teal)),
              ListTile(
                title: const Text('Masculino'),
                leading: Radio(
                  value: 'Masculino',
                  groupValue: _genero,
                  onChanged: (value) {
                    setState(() {
                      _genero = value.toString();
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ),
              ListTile(
                title: const Text('Femenino'),
                leading: Radio(
                  value: 'Femenino',
                  groupValue: _genero,
                  onChanged: (value) {
                    setState(() {
                      _genero = value.toString();
                    });
                  },
                  activeColor: Colors.teal,
                ),
              ),
              CheckboxListTile(
                title: const Text('Casado'),
                value: _casado,
                onChanged: (value) {
                  setState(() {
                    _casado = value!;
                  });
                },
                activeColor: Colors.teal,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Siguiente'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Salir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
