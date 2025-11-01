import 'package:flutter/material.dart';
import 'login.dart';
import 'homepage.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب جديد'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text('إنشاء حساب', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                SizedBox(height: 8),
                Text('انضم إلى منصة الحي وابدأ رحلتك', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 32),

                _buildTextField('الاسم الكامل', 'أدخل اسمك الكامل', Icons.person_outlined, _nameController, _validateName),
                SizedBox(height: 20),
                _buildTextField('البريد الإلكتروني', 'example@email.com', Icons.email_outlined, _emailController, _validateEmail),
                SizedBox(height: 20),
                _buildPasswordField('كلمة المرور', _passwordController, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword), _validatePassword),
                SizedBox(height: 20),
                _buildPasswordField('تأكيد كلمة المرور', _confirmPasswordController, _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword), _validateConfirmPassword),
                SizedBox(height: 32),

                _buildSignupButton(),
                SizedBox(height: 20),
                _buildLoginLink(),
              ],),),),),);}
  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController controller, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: validator,    ),],);}
  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback onToggle, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'أدخل كلمة المرور',
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icon(Icons.lock_outlined),
            suffixIcon: IconButton(icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: onToggle),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: validator,  ),],);}
  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : Text('إنشاء حساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),  ),);}
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('لديك حساب بالفعل؟'),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())),
          child: Text('تسجيل الدخول', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
           ),],);}
  String? _validateName(String? value) => value == null || value.isEmpty ? 'يرجى إدخال الاسم الكامل' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
    if (!value.contains('@')) return 'يرجى إدخال بريد إلكتروني صحيح';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
    if (value != _passwordController.text) return 'كلمات المرور غير متطابقة';
    return null;
  }
  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إنشاء الحساب بنجاح!'), backgroundColor: Colors.green),
        );});}}
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();}}