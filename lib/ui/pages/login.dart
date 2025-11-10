import 'package:chat_mvvm_bloc/ui/pages/chat_list_screen.dart';
import 'package:chat_mvvm_bloc/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';
import '../../services/socket_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  String _selectedRole = 'vendor';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final authRepo = GetIt.instance<AuthRepository>();
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(authRepo),
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, vm, _) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login Here!",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextField(
                    controller: _emailController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  TextField(
                    controller: _passwordController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),

                  SizedBox(height: 16),
                  vm.isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: width,
                          height: height * 0.06,
                          child: ElevatedButton(
                            onPressed: () async {
                              final success = await vm.login(
                                _emailController.text,
                                _passwordController.text,
                                _selectedRole,
                              );
                              if (success) {
                                GetIt.instance<SocketService>().connect();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatListPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login failed!')),
                                );
                              }
                            },
                            child: Text('Login'),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login as  ",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      DropdownButton<String>(
                        style: Theme.of(context).textTheme.bodySmall,
                        value: _selectedRole,
                        items: ['vendor', 'customer']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (v) {
                          print("Selected role: $v");
                          setState(() {
                            _selectedRole = v!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
