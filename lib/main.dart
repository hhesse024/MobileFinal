import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:morseth_finalprojectpart1/SecureStorage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    String? storedUsername = await _secureStorage.read(key: 'test');
    String? storedPassword = await _secureStorage.read(key: 'test');

    setState(() {
      _isLoggedIn = storedUsername != null && storedPassword != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Morseth Mobile App'),
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
                  return CircularProgressIndicator();
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
                    return CircularProgressIndicator();
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
            MaterialPageRoute(builder: (context) => AboutPage()),
          );
        },
        child: const Text(
          'About',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Future<Widget> _buildVersionField() async {
    String appVersion = '1.7.4';

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Version: $appVersion',
          style: TextStyle(fontSize: 15.0),
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
          decoration: InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () async {
            await _login();
          },
          child: Text('Sign in'),
        ),
      ],
    );
  }

  Widget _buildLoggedInUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Center(
          child: Text('login success'),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
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
