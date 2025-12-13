import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterScreen extends StatefulWidget {
const RegisterScreen({super.key});


@override
State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
final _emailController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmController = TextEditingController();


bool _loading = false;


Future<void> _register() async {
if (_passwordController.text != _confirmController.text) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
);
return;
}


try {
setState(() => _loading = true);
await FirebaseAuth.instance.createUserWithEmailAndPassword(
email: _emailController.text.trim(),
password: _passwordController.text.trim(),
);
Navigator.pop(context);
} on FirebaseAuthException catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text(e.message ?? 'Đăng ký thất bại')),
);
} finally {
setState(() => _loading = false);
}
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Đăng ký tài khoản')),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(
children: [
TextField(
controller: _emailController,
decoration: const InputDecoration(labelText: 'Email'),
),
TextField(
controller: _passwordController,
decoration: const InputDecoration(labelText: 'Mật khẩu'),
obscureText: true,
),
TextField(
controller: _confirmController,
decoration: const InputDecoration(labelText: 'Nhập lại mật khẩu'),
obscureText: true,
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: _loading ? null : _register,
child: _loading
? const CircularProgressIndicator()
: const Text('Đăng ký'),
),
],
),
),
);
}
}