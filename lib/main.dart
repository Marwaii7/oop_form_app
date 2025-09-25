import 'package:flutter/material.dart';

abstract class Person {
  void showRole();
}

class User extends Person {
  String _username;
  String _password;

  User(this._username, this._password);

  String get username => _username;
  String get password => _password;

  @override
  void showRole() {
    print("I am a normal user.");
  }
}

class Admin extends User {
  Admin(String username, String password) : super(username, password);

  @override
  void showRole() {
    print("I am an Admin.");
  }
}

List<String> globalItems = [];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    theme: ThemeData(
      primarySwatch: Colors.teal,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  final User admin = Admin("admin", "1234");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_userController.text == admin.username &&
                        _passController.text == admin.password) {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => CrudPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Wrong credentials!")),
                      );
                    }
                  },
                  child: Text("Login", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.teal[50],
    );
  }
}

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  List<String> items = globalItems;

  void addItem(String item) {
    setState(() {
      items.add(item);
      globalItems = items;
    });
  }

  void editItem(int index, String newValue) {
    setState(() {
      items[index] = newValue;
      globalItems = items;
    });
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      globalItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Form")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) => Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(items[i]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal),
                          onPressed: () {
                            final controller = TextEditingController(text: items[i]);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Edit Item"),
                                content: TextField(controller: controller),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      editItem(i, controller.text);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Save"),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteItem(i),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final controller = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Add Item"),
                      content: TextField(controller: controller),
                      actions: [
                        TextButton(
                          onPressed: () {
                            addItem(controller.text);
                            Navigator.pop(context);
                          },
                          child: Text("Add"),
                        )
                      ],
                    ),
                  );
                },
                child: Text("Add Item"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
