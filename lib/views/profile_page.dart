import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'account_page.dart' as account;

class ProfilePage extends StatelessWidget {
  final UserModel currentUser;

  const ProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return account.AccountPage(currentUser: currentUser);
  }
}
