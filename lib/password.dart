import 'package:flutter/material.dart';
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('استعادة كلمة المرور'),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: _emailSent ? _buildSuccessUI() : _buildResetForm(),
      ),);}
  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Icon(Icons.lock_reset, size: 60, color: Theme.of(context).primaryColor),
        SizedBox(height: 16),
        Text('نسيت كلمة المرور؟', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين'),
        SizedBox(height: 32),
        // Email Field
        Text('البريد الإلكتروني', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'example@email.com',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: _validateEmail,
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendResetEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text('إرسال رابط الإعادة', style: TextStyle(fontSize: 16)),
          ),),],);}
  Widget _buildSuccessUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: 80, color: Colors.green),
        SizedBox(height: 24),
        Text('تم الإرسال!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني', textAlign: TextAlign.center),
        SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('حسناً', style: TextStyle(fontSize: 16)),
          ),),],);}
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
    if (!value.contains('@')) return 'بريد إلكتروني غير صحيح';
    return null;}
  void _sendResetEmail() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال بريد إلكتروني صحيح')),
      );
      return;}
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });});}
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}