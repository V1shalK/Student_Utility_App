import 'package:flutter/material.dart';
import 'homepage.dart'; // Import homepage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  void _handleSubmit() {
    if (_isLogin) {
      print('Login button pressed');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      print('Sign Up button pressed');
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double estimatedButtonHeight = 54.0;
    const double buttonOverlap = estimatedButtonHeight / 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60.0, bottom: 40.0),
              alignment: Alignment.center,
              child: const Text(
                'blah blah',
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xA9A59F),
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  width: 310,
                  height: 487,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0DB),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CustomPaint(
                      painter: _LoginSignupPainter(isLogin: _isLogin),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!_isLogin) _toggleForm();
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _isLogin ? Colors.grey[800] : Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_isLogin) _toggleForm();
                                  },
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _isLogin ? Colors.grey[700] : Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 126.0),
                            if (!_isLogin) ...[
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(color: Colors.grey[600]),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[400]!),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[600]!),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400]!),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[600]!),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[400]!),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[600]!),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 10.0),
                            if (_isLogin)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    print('Forgot Password? tapped');
                                  },
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -buttonOverlap,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA0C3A0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: Text(
                        _isLogin ? 'Submit' : 'Sign Up',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: buttonOverlap + 30.0),
            if (_isLogin)
              Column(
                children: [
                  Text(
                    'Or Login using',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png',
                        Icons.g_mobiledata,
                        Colors.red,
                      ),
                      const SizedBox(width: 30.0),
                      _buildSocialIcon(
                        'https://upload.wikedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/2048px-2021_Facebook_icon.svg.png',
                        Icons.facebook,
                        Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String url, IconData fallbackIcon, Color fallbackColor) {
    return GestureDetector(
      onTap: () {
        print('Social login tapped');
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Image.network(
          url,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) =>
              Icon(fallbackIcon, size: 40, color: fallbackColor),
        ),
      ),
    );
  }
}

class _LoginSignupPainter extends CustomPainter {
  final bool isLogin;

  _LoginSignupPainter({required this.isLogin});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC0C0B0)
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isLogin) {
      path.moveTo(size.width * 0.5, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.3);
      path.lineTo(size.width * 0.2, 0);
    } else {
      path.moveTo(size.width * 0.5, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height * 0.3);
      path.lineTo(size.width * 0.8, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _LoginSignupPainter && oldDelegate.isLogin != isLogin;
  }
}
