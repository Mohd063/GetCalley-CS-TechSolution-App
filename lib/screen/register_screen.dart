import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_calley/provider/auth_provider.dart';
import 'package:get_calley/screen/login_screen.dart';
import 'package:get_calley/screen/otp_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  bool agreeTerms = false;
  bool _isRegistering = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/images/logo.png', height: 70),
              const SizedBox(height: 20),

              // 🟦 Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            "Welcome!",
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Please register to continue",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ✏️ Input Fields
                    _buildTextField(
                      controller: _nameController,
                      label: "Name",
                      icon: Icons.person_outline,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email address",
                      icon: Icons.email_outlined,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text("🇮🇳 +91", style: TextStyle(fontSize: 16)),
                          ),
                          suffixIcon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Color(0xFF25D366),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    // ✅ Terms Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: agreeTerms,
                          activeColor: const Color(0xFF2563EB),
                          onChanged: (val) => setState(() => agreeTerms = val!),
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              text: "I agree to the ",
                              style: TextStyle(color: Colors.black, fontSize: 15),
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyle(
                                    color: Color(0xFF2196F3),
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 80),

                    // 🔁 Already Registered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(fontSize: 15, color: Colors.black)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 13),

                    // 🔘 Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isRegistering ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Registration Logic
  Future<void> _handleRegister() async {
  final prefs = await SharedPreferences.getInstance();

  if (!agreeTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please agree to Terms")),
    );
    return;
  }

  if (_nameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _mobileController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
    return;
  }

  setState(() {
    _isRegistering = true; 
  });

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  await prefs.setString('name', _nameController.text.trim());
  await prefs.setString('mobile', _mobileController.text.trim());
  await prefs.setString('email', _emailController.text.trim());

  final result = await authProvider.registerUser(
    name: _nameController.text.trim(),
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
    mobile: _mobileController.text.trim(),
  );

  if (result['success']) {
    bool otpSent = await authProvider.sendOtp(_emailController.text.trim());

    if (otpSent) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GmailOtpScreen(email: _emailController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? "Registration failed")),
    );
  }

  setState(() {
    _isRegistering = false; 
  });
}

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
          ),
        ),
      ),
    );
  }
}
