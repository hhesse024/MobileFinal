import 'package:flutter/material.dart';
import 'package:morseth_finalprojectpart1/SecureStorage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Morseth Mobile App'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please sign in',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            FutureBuilder<Widget>(
              future: _buildLoginUI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? Container();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0, right: 3.0),
              child: FutureBuilder<Widget>(
                future: _buildVersionField(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.data ?? Container();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        },
        child: const Text(
          'About',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

//builds version widget at the bottom of home screen
  Future<Widget> _buildVersionField() async {
    String appVersion = '1.7.4';

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Version: $appVersion',
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }

  Future<Widget> _buildLoginUI() async {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () async {
            await _login();
          },
          child: const Text('Sign in'),
        ),
      ],
    );
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

//Gets user input and compares to stored username and password
    if (username.isNotEmpty && password.isNotEmpty) {
      SecureStorage secureStorage = SecureStorage();
      await secureStorage.saveCredentials('test', 'test');

      String? storedUsername = await secureStorage.getUsername();
      String? storedPassword = await secureStorage.getPassword();

      setState(() {
        if (username == storedUsername && password == storedPassword) {
          _showSnackBar("Login success");
        } else if (username != storedUsername && password == storedPassword) {
          _showSnackBar('Incorrect username. Please try again.');
        } else if (username == storedUsername && password != storedPassword) {
          _showSnackBar('Incorrect password. Please try again.');
        } else {
          _showSnackBar('Incorrect login information.');
        }
      });
    }
  }

//Snackbar method for displaying a customized snackbar mesage after log in attempts
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.teal,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Can't get enough of APIs? You're in the right place. This is an app that uses an API of APIs.",
                style: TextStyle(fontSize: 19.0),
                textAlign: TextAlign.center),
            Text(""),
            Text(""),
            Text(
              "Developed by Heidi Morseth for CMSC 2204",
              style: TextStyle(fontSize: 19.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
