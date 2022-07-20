import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? oldPassword, newPassword, confirmPassword;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            MyTextField(
              labelText: 'Current Password',
              onChanged: (value) {
                setState(() {
                  oldPassword = value;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              labelText: 'New Password',
              onChanged: (value) {
                setState(() {
                  newPassword = value;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            MyTextField(
              labelText: 'Confirm Password',
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 45,
              child: RaisedButton(
                onPressed: oldPassword == null ||
                        newPassword == null ||
                        confirmPassword == null
                    ? null
                    : () async {
                        if (newPassword != confirmPassword) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content:
                                        const Text('Passwords do not match'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      )
                                    ],
                                  ));
                        }
                        if (user.password != oldPassword) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Error'),
                                    content:
                                        const Text('Old password is incorrect'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      )
                                    ],
                                  ));
                        } else {
                          await FirebaseAuth.instance.currentUser!
                              .updatePassword(newPassword!);

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.userId)
                              .update({
                            'password': newPassword,
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Password updated successfully'),
                          ));
                        }
                      },
                color: kIconColor,
                textColor: Colors.white,
                child: const Text('Change Password'),
              ),
            ),
          ])),
    );
  }
}
