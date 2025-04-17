import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Map<String, String> _fieldErrors = {};

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Select your birth date',
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  bool _validateForm() {
    _fieldErrors.clear();

    if (_usernameController.text.isEmpty) {
      _fieldErrors['username'] = 'กรุณากรอกชื่อผู้ใช้';
    }

    if (_nameController.text.isEmpty) {
      _fieldErrors['name'] = 'กรุณากรอกชื่อ';
    }

    if (_lastNameController.text.isEmpty) {
      _fieldErrors['lastName'] = 'กรุณากรอกนามสกุล';
    }

    if (_emailController.text.isEmpty) {
      _fieldErrors['email'] = 'กรุณากรอกอีเมล';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      _fieldErrors['email'] = 'กรุณากรอกอีเมลให้ถูกต้อง';
    }

    if (_phoneController.text.isEmpty) {
      _fieldErrors['phone'] = 'กรุณากรอกเบอร์โทร';
    } else if (!RegExp(r'^\d{10}$').hasMatch(_phoneController.text)) {
      _fieldErrors['phone'] = 'เบอร์โทรต้องเป็นตัวเลข 10 หลัก';
    }

    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _fieldErrors['password'] = 'กรุณากรอกรหัสผ่านและยืนยันรหัสผ่าน';
    } else if (_passwordController.text != _confirmPasswordController.text) {
      _fieldErrors['password'] = 'รหัสผ่านไม่ตรงกัน';
    }

    setState(() {
      _errorMessage = _fieldErrors.isEmpty ? '' : 'กรุณากรอกข้อมูลให้ถูกต้อง';
    });

    return _fieldErrors.isEmpty;
  }

  Future<void> _registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': _usernameController.text.trim(),
        'name': _nameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'birthDate': _birthDateController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Registration failed';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String placeholder, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
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
        ),
        if (errorKey != null && _fieldErrors.containsKey(errorKey))
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              _fieldErrors[errorKey]!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('M', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Icon(Icons.monetization_on, size: 28),
                Text('neyQuest', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFA8E1E6)),
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
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left, color: Colors.lightBlueAccent, size: 30),
                                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                              ),
                              const Expanded(
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(_usernameController, 'Username', errorKey: 'username'),
                          const SizedBox(height: 12),
                          _buildTextField(_nameController, 'Name', errorKey: 'name'),
                          const SizedBox(height: 12),
                          _buildTextField(_lastNameController, 'Last name', errorKey: 'lastName'),
                          const SizedBox(height: 12),
                          _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress, errorKey: 'email'),
                          const SizedBox(height: 12),
                          _buildTextField(_phoneController, 'Phone', keyboardType: TextInputType.phone, errorKey: 'phone'),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _birthDateController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              hintText: 'Date of Birth',
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
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(_passwordController, 'Password', isPassword: true, errorKey: 'password'),
                          const SizedBox(height: 12),
                          _buildTextField(_confirmPasswordController, 'Confirm Password', isPassword: true),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 14)),
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_validateForm()) {
                                  _registerUser();
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
                              child: const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Already have an account? ', style: TextStyle(color: Colors.black54)),
                                Text('Login', style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
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
