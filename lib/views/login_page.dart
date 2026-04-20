import 'package:MyField/database/database_helper.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/views/pendaftaran_page.dart';
import 'package:MyField/views/settings_page.dart';
import 'package:MyField/widget/bottomnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  static bool _googleInitialized = false;

  final Color bgColor = const Color(0xFFF5F7FB);
  final Color accentColor = const Color(0xFF3A7BFF);
  final Color darkAccent = const Color(0xFF0F172A);
  final Color mutedText = const Color(0xFF6B7280);
  final Color titleColor = const Color(0xFF111827);
  final Color inputFillColor = const Color(0xFFEAF1FB);
  final Color borderColor = const Color(0xFFD9E5F5);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    AppThemeController.setDarkMode(false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi")),
      );
      return;
    }

    final UserModel? user = await DatabaseHelper.instance.loginUser(
      email,
      password,
    );
    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavbar(currentUser: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email atau Password salah")),
      );
    }
  }

  Future<void> loginWithGoogle() async {
    if (_isGoogleLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final googleSignIn = GoogleSignIn.instance;
      if (!_googleInitialized) {
        await googleSignIn.initialize();
        _googleInitialized = true;
      }

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw FirebaseAuthException(
          code: 'google-id-token-missing',
          message: 'Token Google tidak tersedia.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final authResult = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = authResult.user;

      if (firebaseUser == null || firebaseUser.email == null) {
        throw FirebaseAuthException(
          code: 'google-user-null',
          message: 'Data akun Google tidak tersedia.',
        );
      }

      final displayName = firebaseUser.displayName?.trim().isNotEmpty == true
          ? firebaseUser.displayName!.trim()
          : firebaseUser.email!.split('@').first;

      final user = await DatabaseHelper.instance.ensureGoogleUser(
        email: firebaseUser.email!,
        username: displayName,
        photoUrl: firebaseUser.photoURL ?? '',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Google berhasil")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavbar(currentUser: user),
        ),
      );
    } on GoogleSignInException catch (e) {
      if (!mounted) return;
      final isCancelled = e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCancelled
                ? "Login Google dibatalkan"
                : "Login Google gagal: ${e.description}",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final isCancelled = e.code == 'web-context-cancelled' ||
          e.code == 'popup-closed-by-user' ||
          e.code == 'canceled';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isCancelled
                ? "Login Google dibatalkan"
                : "Login Google gagal: ${e.message ?? e.code}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Google gagal: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.05),
                  Image.asset(
                    'assets/images/logo_myfield.png',
                    height: 118,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: darkAccent,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Masuk untuk lanjut booking lapangan dan cek jadwal main kamu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: mutedText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFieldLabel("EMAIL ADDRESS"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: titleColor),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hint: "name@gmail.com",
                      prefixIcon: Icons.mail_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFieldLabel("PASSWORD"),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: TextStyle(color: titleColor),
                    decoration: _inputDecoration(
                      hint: "........",
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: mutedText,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    "OR CONTINUE WITH",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: mutedText,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _socialButton(
                          icon: _buildGoogleIcon(),
                          label: _isGoogleLoading ? "Loading..." : "Google",
                          onPressed: _isGoogleLoading ? null : loginWithGoogle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _socialButton(
                          icon: const Icon(Icons.apple_rounded, size: 20),
                          label: "Apple",
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Apple belum tersedia"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PendaftaranUser(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: mutedText,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          const TextSpan(
                            text: "Don't have an account? ",
                          ),
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: mutedText,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: darkAccent,
        backgroundColor: Colors.white,
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFFEA4335),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF4285F4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFFFBBC05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF34A853),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: mutedText.withValues(alpha: 0.75)),
      prefixIcon: Icon(prefixIcon, color: mutedText, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: inputFillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accentColor, width: 1.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
