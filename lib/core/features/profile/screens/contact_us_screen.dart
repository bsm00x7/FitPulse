import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff1D1617)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: Color(0xff1D1617),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffB4C0FE), Color(0xff9BB5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffB4C0FE).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.support_agent, size: 60, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'We\'re Here to Help!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Have questions or feedback? Get in touch with us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Contact Methods
            Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1D1617),
              ),
            ),
            SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildContactMethod(
                    Icons.email,
                    'Email',
                    () => _launchEmail(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildContactMethod(
                    Icons.phone,
                    'Call',
                    () => _launchPhone(),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Contact Form
            Text(
              'Send us a Message',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1D1617),
              ),
            ),
            SizedBox(height: 12),
            
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon: Icon(Icons.person, color: Color(0xffB4C0FE)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xffB4C0FE), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email, color: Color(0xffB4C0FE)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xffB4C0FE), width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Your Message',
                        prefixIcon: Icon(Icons.message, color: Color(0xffB4C0FE)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xffB4C0FE), width: 2),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffB4C0FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Send Message',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1D1617),
              ),
            ),
            SizedBox(height: 12),
            
            _buildFAQItem(
              'How do I track my workouts?',
              'Navigate to the Walking screen and start your workout. Your steps and distance will be tracked automatically.',
            ),
            _buildFAQItem(
              'Can I sync with other apps?',
              'Currently, the app works independently. We\'re working on integrations with popular fitness apps.',
            ),
            _buildFAQItem(
              'How do I change my goal?',
              'Go to your Profile, tap on your current goal, and select a new one from the available options.',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactMethod(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xffB4C0FE).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xffB4C0FE), size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff1D1617),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xff1D1617),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Here you would typically send the form data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Message sent successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }
  
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@fitnessapp.com',
      query: 'subject=Support Request',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open email app')),
      );
    }
  }
  
  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+1234567890');
    
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open phone app')),
      );
    }
  }
}
