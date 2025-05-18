// import 'package:flutter/material.dart';
// import '../services/db_helper.dart'; // Your DB helper for checking user existence
// import '../services/auth_service.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   void _signup(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       try {
//         // Check if the email already exists in the database
//         final dbHelper = DBHelper();
//         final existingUser = await dbHelper.getUserByEmail(_emailController.text);

//         if (existingUser != null) {
//           // If the email already exists
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Email already exists! Please login.")),
//           );
//         } else {
//           // Proceed with user registration if email is unique
//           await AuthService().registerUser(
//             _firstNameController.text,
//             _lastNameController.text,
//             _emailController.text,
//             _passwordController.text,
//           );

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Account created! Please login.")),
//           );

//           Navigator.pushReplacementNamed(context, '/login');
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${e.toString()}")),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: "First Name"),
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter your first name" : null,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: "Last Name"),
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter your last name" : null,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Enter a valid email";
//                   }
//                   final emailRegex = RegExp(
//                       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
//                   if (!emailRegex.hasMatch(value)) {
//                     return "Enter a valid email format";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: "Password"),
//                 obscureText: true,
//                 validator: (value) => value!.length < 6
//                     ? "Password must be at least 6 characters"
//                     : null,
//               ),
//               const SizedBox(height: 20),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () => _signup(context),
//                       child: const Text("Sign Up"),
//                     ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/login');
//                 },
//                 child: const Text("Already have an account? Login"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/db_helper.dart'; // Your DB helper for checking user existence
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _signup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dbHelper = DBHelper();
      final existingUser = await dbHelper.getUserByEmail(_emailController.text);

      if (existingUser != null) {
        _showSnackbar("Email already exists! Please login.", Colors.red);
      } else {
        await AuthService().registerUser(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        _showSnackbar("Account created! Please login.", Colors.green);
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showSnackbar("Error: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Create an Account", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    _buildTextField(_firstNameController, "First Name"),
                    _buildTextField(_lastNameController, "Last Name"),
                    _buildTextField(_emailController, "Email", isEmail: true),
                    _buildTextField(_passwordController, "Password", isPassword: true),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _signup(context),
                            child: const Text("Sign Up"),
                          ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isEmail = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Enter your $label";
          }
          if (isEmail) {
            //final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$');
            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return "Enter a valid email";
            }
          }
          if (isPassword && value.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
      ),
    );
  }
}