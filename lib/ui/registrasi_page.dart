import 'package:flutter/material.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/widgets/success_dialog.dart';
import 'package:tokokita/widgets/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    _namaTextboxController.dispose();
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _namaTextField(),
                const SizedBox(height: 12),
                _emailTextField(),
                const SizedBox(height: 12),
                _passwordTextField(),
                const SizedBox(height: 12),
                _passwordKonfirmasiTextField(),
                const SizedBox(height: 20),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nama'),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value == null || value.trim().length < 3) {
          return 'Nama harus diisi minimal 3 karakter';
        }
        return null;
      },
    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email harus diisi';
        }
        // simple email validation
        final email = value.trim();
        final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
        if (!regex.hasMatch(email)) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password harus diisi minimal 6 karakter';
        }
        return null;
      },
    );
  }

  // membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value == null || value != _passwordTextboxController.text) {
          return 'Konfirmasi Password tidak sama';
        }
        return null;
      },
    );
  }

  //Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi"),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then(
      (value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Registrasi berhasil, silahkan login",
            okClick: () {
              Navigator.pop(context);
            },
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Registrasi gagal, silahkan coba lagi",
          ),
        );
      },
    );
  }
}
