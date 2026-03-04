import 'package:MyField/database/database_helper.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/views/home_page.dart';
import 'package:MyField/views/pendaftaran_page.dart';
import 'package:MyField/widget/bottomnavbar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND IMAGE
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// OVERLAY 
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          /// FORM LOGIN
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(height: 40),

                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 10),

                   Text(
                    "Silahkan login untuk melanjutkan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 40),

                  /// EMAIL
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  /// PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  /// BUTTON LOGIN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff007E6E),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () async {

                         bool emailValid = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                           ).hasMatch(emailController.text);

                          if (!emailValid) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text("Format email tidak valid")),
                      );
                        return;
  }

                        if (passwordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password harus minimal 6 karakter"),
                            ),
                          );
                          return;
                        }

                        if (!emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email tidak valid"),
                            ),
                          );
                          return;
                        }

                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email dan Password tidak boleh kosong"),
                            ),
                          );
                          return;
                        }
                        final UserModel? login =
                            await DatabaseHelper.instance.loginUser(
                            email: emailController.text,
                            password: passwordController.text,
                        );

                        if (login != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              content: Text("Login Berhasil"),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  bottomNavbar(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email / Password Salah"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  /// DAFTAR
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PendaftaranUser(),
                        ),
                      );
                    },
                    child: Text(
                      "Belum punya akun? Daftar disini",
                      style: TextStyle(
                        color:Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                    ],
                  ),

                  TextButton(
                    onPressed: () {

                    },
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}