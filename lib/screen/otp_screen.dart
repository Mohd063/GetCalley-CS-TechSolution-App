import 'package:flutter/material.dart';
import 'package:get_calley/screen/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:get_calley/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GmailOtpScreen extends StatefulWidget {
  final String email;
  const GmailOtpScreen({super.key, required this.email});

  @override
  State<GmailOtpScreen> createState() => _GmailOtpScreenState();
}

class _GmailOtpScreenState extends State<GmailOtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  bool isResending = false;
  int cooldownSeconds = 0;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }
Future<void> _verifyOtp() async {
  String otp = _controllers.map((e) => e.text).join();

  if (otp.length != 6) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
    );
    return;
  }

  setState(() => _isVerifying = true);

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final error = await authProvider.verifyOtp({
    'email': widget.email,
    'otp': otp,
  });

  setState(() => _isVerifying = false);

  if (error == null) {
    print("✅ OTP verified successfully, navigating to WelcomeScreen...");

    if (!mounted) return;

    // Wait briefly before navigating
    await Future.delayed(const Duration(milliseconds: 100));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  } else {
    print("❌ OTP Error: $error");

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }
}

  Future<void> _resendOtp() async {
    if (isResending || cooldownSeconds > 0) return;

    setState(() => isResending = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.sendOtp(widget.email);

    setState(() => isResending = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP sent again!")));
      setState(() => cooldownSeconds = 30);
      _startCooldownTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to resend OTP")));
    }
  }

  void _startCooldownTimer() async {
    while (cooldownSeconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => cooldownSeconds--);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image.asset('assets/images/logo.png', height: 80),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    const Text(
                      "Gmail OTP Verification",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter the 6-digit OTP sent to your email",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (val) => _onOtpChanged(index, val),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      widget.email,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 150),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Didn't receive OTP? "),
                        GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            isResending
                                ? "Sending..."
                                : cooldownSeconds > 0
                                    ? "Resend in ${cooldownSeconds}s"
                                    : "Resend OTP",
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Verify",
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
}
