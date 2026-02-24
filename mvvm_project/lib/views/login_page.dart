import 'package:flutter/material.dart';
import 'package:mvvm_project/viewmodels/login/login_viewmodel.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController(text: 'admin');
  final _passCtrl = TextEditingController(text: '123456');
  bool _obscure = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFE9F4FF);
    const primary = Color(0xFF1E88E5);
    const titleBlue = Color(0xFF1D4E9E);

    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 120),
                Text(
                  'Personal Management',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: titleBlue,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 70),

                TextField(
                  controller: _userCtrl,
                  enabled: !vm.loading,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 1.2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: const TextStyle(fontSize: 22),
                  onChanged: (_) => vm.clearError(),
                ),

                const SizedBox(height: 26),

                TextField(
                  controller: _passCtrl,
                  enabled: !vm.loading,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: const UnderlineInputBorder(),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 1.2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: IconButton(
                      onPressed: vm.loading
                          ? null
                          : () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 22, color: Colors.black54),
                  onChanged: (_) => vm.clearError(),
                  onSubmitted: (_) => _handleLogin(context),
                ),

                const SizedBox(height: 10),

                if (vm.error != null)
                  Text(
                    vm.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: vm.loading ? null : () {},
                    style: TextButton.styleFrom(
                      foregroundColor: primary,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forget your password',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    onPressed: vm.loading ? null : () => _handleLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    child: vm.loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('LOGIN'),
                  ),
                ),

                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: vm.loading ? null : () {},
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 18,
                          color: primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final vm = context.read<LoginViewModel>();

    final ok = await vm.login(_userCtrl.text, _passCtrl.text);
    if (!ok) return;

    final username = vm.session!.user.userName;

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage(userName: username, title: 'Personal Management')),
    );
  }
}

