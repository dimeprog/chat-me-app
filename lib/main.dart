import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socket_chat_app/firebase_options.dart';
import 'package:socket_chat_app/screen/users_screen.dart';

import 'api/auth.dart';
import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Chat App'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Welcome to Chat App'),
                const SizedBox(
                  height: 30,
                ),
                const Text('Please enter your name'),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) return;

                    await Auth.signin(
                            emailController.text, passwordController.text)
                        .then((data) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UsersPage()));
                    }, onError: (_) {
                      print('error');
                    });

                    // Navigate to the second screen using a named route.
                  },
                  child: const Text('signin'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) return;

                    await Auth.signup(
                            emailController.text, passwordController.text)
                        .then(
                      (data) {
                        FirebaseApi.createChats(emailController.text,
                                passwordController.text, data.user!.uid)
                            .then(
                          (_) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Chat created'),
                              duration: Duration(seconds: 3),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UsersPage()));
                          },
                          onError: (_) {
                            print('error');
                          },
                        );
                      },
                    );
                    // Navigate to the second screen using a named route.
                  },
                  child: const Text('signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
