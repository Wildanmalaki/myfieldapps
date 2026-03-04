import 'package:MyField/database/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class PendaftaranUser extends StatefulWidget {
  const PendaftaranUser({super.key});

  @override
  State<PendaftaranUser> createState() => _PendaftaranUserState();
}

class _PendaftaranUserState extends State<PendaftaranUser> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void daftarUser() async {
  String email = emailController.text;
  String password = passwordController.text;
  String confirmPassword = confirmPasswordController.text;

   final existingUser =
      await DatabaseHelper.instance.getUserByEmail(email);

  if (existingUser != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email sudah terdaftar")),
    );
    return;
  }

  if (password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password minimal 6 karakter")),
    );
    return;
  }

  bool emailValid = RegExp(
    r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(email);

  if (!emailValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Format email tidak valid")),
    );
    return;
  }

  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Semua field harus diisi")),
    );
    return;
  }

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password tidak sama")),
    );
    return;
  }

  // Buat object user
  final user = UserModel(
    email: email,
    password: password,
  );

  // Simpan ke database
  await DatabaseHelper
  .instance.insertUser(user);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("User berhasil didaftarkan")),
  );

  // Kosongkan field
  emailController.clear();
  passwordController.clear();
  confirmPasswordController.clear();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendaftaran User", 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(1.0),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Buat Akun Baru",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 20),

           Text(
            "Silahkan isi form pendaftaran untuk membuat akun baru",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),

          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          SizedBox(height: 16),
          
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Konfirmasi Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff007E6E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: daftarUser,
                  child: Text(
                    "DAFTAR",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}