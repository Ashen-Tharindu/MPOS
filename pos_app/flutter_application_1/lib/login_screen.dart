import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repair_job_screen.dart'; // ගොනුවේ නම නිවැරදි කරගන්න

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  bool _isObscure = true;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  // Sign In Function
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user != null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRepairJobScreen(),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("දෝෂයක් පවතී: ${e.toString()}")),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFF0F0C29),
                      Color(0xFF302B63),
                      Color(0xFF24243E),
                    ],
                    transform: GradientRotation(
                      _bgController.value * 2 * math.pi,
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                width: 950,
                height: 550,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Row(children: [_buildLeftPanel(), _buildRightPanel()]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              "Easy POS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              "Smart Business Solutions",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildFeatureTile(
              Icons.bolt,
              "Lightning Fast",
              "Optimized for speed",
            ),
            _buildFeatureTile(
              Icons.auto_graph,
              "Live Insights",
              "Real-time data tracking",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Expanded(
      flex: 1,
      child: Container(
        color: const Color(0xFF101026).withOpacity(0.95),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please enter your details",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _buildInputLabel("Email Address"),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  Icons.alternate_email,
                  "name@example.com",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please fill out this field" : null,
              ),
              const SizedBox(height: 25),
              _buildInputLabel("Password"),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  Icons.lock_outline,
                  "••••••••",
                  suffix: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please fill out this field" : null,
              ),
              const SizedBox(height: 30),
              _buildAnimatedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton() {
    return InkWell(
      onTap: _handleSignIn,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8E2DE2).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Sign In to Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
  );

  InputDecoration _inputDecoration(
    IconData icon,
    String hint, {
    Widget? suffix,
  }) => InputDecoration(
    prefixIcon: Icon(icon, color: Colors.white54, size: 20),
    suffixIcon: suffix,
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
    filled: true,
    fillColor: const Color(0xFF1E1E3F),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF8E2DE2), width: 1.5),
    ),
  );

  Widget _buildFeatureTile(IconData icon, String title, String desc) =>
      Container(
        width: 280,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      );
}
