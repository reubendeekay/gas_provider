import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/button_loader.dart';
import 'package:gas_provider/helpers/my_dropdown.dart';

import 'package:http/http.dart' as http;

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String? phoneNumber;
  String? email;
  String? contact;
  String? name;
  String? message;
  String? inquiryOption;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
        ),
        title: const Text("Enquiry",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            const Text("User Details",
                style:
                    TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                },
                style: const TextStyle(
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  hintText: "Your Name",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 22,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                },
                style: const TextStyle(
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  hintText: "Your Email",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    size: 22,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    phoneNumber = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter a phone number";
                  }
                  return null;
                },
                style: const TextStyle(
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  hintText: "Phone number",
                  hintStyle: const TextStyle(
                    letterSpacing: 0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    size: 22,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                keyboardType: TextInputType.phone,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Enquiry information",
                style:
                    TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
            const SizedBox(
              height: 5,
            ),
            MyDropDown(
                selectedOption: (val) {
                  setState(() {
                    inquiryOption = val;
                  });
                },
                hintText: 'Enquiry Type',
                options: [
                  "Report",
                  "Compliments",
                  "General Enquiry",
                ]),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    message = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter your message";
                  }
                  return null;
                },
                maxLength: null,
                maxLines: null,
                style: const TextStyle(
                  letterSpacing: 0,
                ),
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: const TextStyle(
                    letterSpacing: 0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 22,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: kIconColor,
              onPressed: inquiryOption == null
                  ? () {}
                  : () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        final statusCode = await sendEmail(name!, email!,
                            message!, inquiryOption!, phoneNumber!);
                        setState(() {
                          isLoading = false;
                        });

                        if (statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                      'Your enquiry has been sent successfully',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))));
                          Future.delayed(const Duration(seconds: 5), () {
                            Navigator.pop(context);
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'Something went wrong, please try again later',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ));
                        }
                      }
                    },
              child: isLoading
                  ? const MyLoader()
                  : const Text('Submit',
                      style: TextStyle(
                        color: Colors.white,
                      )),
            )
          ],
        ),
      ),
    );
  }
}

Future sendEmail(String name, String email, String message, String enquiry,
    String phone) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_9rpw7w8';
  const templateId = 'template_ujonvga';
  const userId = 'VuUlTtlEpMwxt0xwT';
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'name': name,
          'inquiry_option': enquiry,
          'message': message,
          'phone': phone,
          'email': email
        }
      }));
  print(response.body);

  return response.statusCode;
}
