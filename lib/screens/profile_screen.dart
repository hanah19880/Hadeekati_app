import 'package:flutter/material.dart';
import '../main.dart';
import '../database/database_helper6.dart';
import 'login_screen.dart';
import '../widgets/custom_text_field.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user; 
  
  final _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'address': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    if (!MyApp.isGuest) loadUser(); 
  }
  void loadUser() async {
    final data = await DatabaseHelper.getUser(); 
    if (data != null) { 
      setState(() {
        user = data; 

        _controllers['name']!.text = data['name'] ?? ''; 
        _controllers['email']!.text = data['email'] ?? '';
        _controllers['phone']!.text = data['phone'] ?? '';
        _controllers['address']!.text = data['address'] ?? '';
        _controllers['password']!.text = data['password'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4), 
      appBar: AppBar(automaticallyImplyLeading: false,
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3525))),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        actions: [ 
          if (!MyApp.isGuest) 
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFF4E7D5A)), 
              onPressed: () async {
                await DatabaseHelper.logout(); 
                MyApp.isGuest = true; 
                MyApp.isAdmin = false; 
                if (mounted) Navigator.pushReplacementNamed(context, '/login'); 
              },
            ),
        ],
      ),
      body: MyApp.isGuest ? _buildGuestView() : _buildProfileView(), 
    );
  }

  Widget _buildGuestView() => Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          const Icon(Icons.account_circle, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text("Welcome Guest!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), 
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4E7D5A), 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15) 
            ),
            child: const Text("Login / Sign Up", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    ),
  );

  Widget _buildProfileView() => user == null 
      ? const Center(child: CircularProgressIndicator(color: Color(0xFF4E7D5A))) 
      : SingleChildScrollView( 
          padding: const EdgeInsets.all(20), 
          child: Column(
            children: [
              const CircleAvatar( 
                radius: 50, 
                backgroundColor: Color(0xFF4E7D5A),
                child: Icon(Icons.person, size: 60, color: Colors.white) 
              ),
              const SizedBox(height: 20),
              CustomTextField(controller: _controllers['name']!, label: "Name", icon: Icons.person), 
              CustomTextField(controller: _controllers['email']!, label: "Email", icon: Icons.email), 
              CustomTextField(controller: _controllers['phone']!, label: "Phone", icon: Icons.phone, keyboardType: TextInputType.phone), 
              CustomTextField(controller: _controllers['address']!, label: "Address", icon: Icons.location_on),
              CustomTextField(controller: _controllers['password']!, label: "Password", icon: Icons.lock, obscure: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton(
                  onPressed: () async {

                    await DatabaseHelper.updateUser(user!['id'], { 
                      'name': _controllers['name']!.text,
                      'email': _controllers['email']!.text,
                      'password': _controllers['password']!.text,
                      'phone': _controllers['phone']!.text,
                      'address': _controllers['address']!.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E7D5A), 
                    padding: const EdgeInsets.all(15) 
                  ),
                  child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        );
}
