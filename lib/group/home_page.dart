import 'package:flutter/material.dart';
import 'package:socket_chat_app/group/group_page.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});
  @override
  Widget build(BuildContext context) {
    final homeController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Please enter your name'),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: homeController,
                    validator: (val) {
                      if (val!.isEmpty || val.length <= 3) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      homeController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupPage(
                              name: homeController.text,
                            ),
                          ),
                        );
                        homeController.clear();
                      }
                    },
                    child: const Text(
                      'Enter',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            );
          },
          child: const Text('Initialize group '),
        ),
      ),
    );
  }
}
