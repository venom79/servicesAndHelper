import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String role = "customer";
  bool loading = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _register() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMsg("Please fill all fields");
      return;
    }

    setState(() => loading = true);

    try {
      final data = await ApiService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      final token = (data["token"] ?? "").toString();
      final savedRole = (data["role"] ?? role).toString();

      if (token.isEmpty) {
        _showMsg("Token missing in response");
        return;
      }

      await Session.save(
        token: token,
        role: savedRole,
        name: (data["name"] ?? "").toString(),
        userId: (data["_id"] ?? "").toString(),
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        savedRole == "provider" ? AppRoutes.providerDashboard : AppRoutes.customerDashboard,
        (route) => false,
      );
    } catch (e) {
      _showMsg(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: role,
              dropdownColor: const Color(0xFF1E1E1E),
              items: const [
                DropdownMenuItem(value: "customer", child: Text("Customer")),
                DropdownMenuItem(value: "provider", child: Text("Provider")),
              ],
              onChanged: (value) {
                setState(() => role = value ?? "customer");
              },
              decoration: const InputDecoration(
                labelText: "Select Role",
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: loading ? null : _register,
              child: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Register"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              child: const Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
