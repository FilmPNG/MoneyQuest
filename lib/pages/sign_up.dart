import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  bool _validateForm() {
    // Check for empty required fields
    if (_usernameController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return false;
    }

    // Validate email format
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(_emailController.text)) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return false;
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return false;
    }

    // If all validations pass
    setState(() {
      _errorMessage = '';
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // White top section with logo
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'M',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.monetization_on,
                  size: 28,
                ),
                Text(
                  'neyQuest',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Light blue section with sign up form
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFA8E1E6),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          // Header with back button and title
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.lightBlueAccent,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              // Spacer to balance the layout
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Sign up form fields
                          _buildTextField(_usernameController, 'Username'),
                          const SizedBox(height: 12),
                          _buildTextField(_nameController, 'Name'),
                          const SizedBox(height: 12),
                          _buildTextField(_lastNameController, 'Last name'),
                          const SizedBox(height: 12),
                          _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 12),
                          _buildTextField(_phoneController, 'Phone', keyboardType: TextInputType.phone),
                          const SizedBox(height: 12),
                          
                          // Date of birth field with calendar icon
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: TextField(
                              controller: _birthDateController,
                              decoration: InputDecoration(
                                hintText: 'Date of birth',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          _buildTextField(_passwordController, 'Password', isPassword: true),
                          const SizedBox(height: 12),
                          
                          _buildTextField(_confirmPasswordController, 'Confirm Password', isPassword: true),
                          
                          // Error message
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 20),
                          
                          // Create Account button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_validateForm()) {
                                  // Success - go back to login
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Account created successfully!')),
                                  );
                                  Navigator.pushReplacementNamed(context, '/login');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          // Login option
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String placeholder, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}