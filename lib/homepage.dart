import 'package:flutter/material.dart';
import 'login.dart';
import 'posts_screen.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // استمع لتغييرات اللون
    AppColors.addListener(_refresh);
  }

  @override
  void dispose() {
    // توقف عن الاستماع عند إغلاق الصفحة
    AppColors.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {}); // أعد بناء الصفحة
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = AppColors.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('صوت الحي'),
        centerTitle: true,
        backgroundColor: currentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Icon(
              Icons.handshake_outlined,
              size: 100,
              color: currentColor,
            ),
            const SizedBox(height: 20),
            Text(
              'مرحباً بك في منصة "صوت الحي" 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: currentColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'تم تسجيل الدخول بنجاح',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'منصّة مجتمعية لاقتراح الأفكار وتحسين أحياء مدينتك بالتعاون مع الجهات المحلية.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'ابدأ الآن',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'آخر الاقتراحات النشطة 🔥',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: currentColor,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.lightbulb_outline, color: currentColor),
                    title: const Text('تركيب إنارة جديدة في شارع النخيل'),
                    subtitle: const Text('عدد المؤيدين: 42'),
                  ),
                  ListTile(
                    leading: Icon(Icons.park, color: currentColor),
                    title: const Text('إعادة تأهيل الحديقة العامة في الحي الشمالي'),
                    subtitle: const Text('عدد المؤيدين: 68'),
                  ),
                  ListTile(
                    leading: Icon(Icons.sports_soccer, color: currentColor),
                    title: const Text('إنشاء ملعب كرة قدم في المنطقة الجنوبية'),
                    subtitle: const Text('عدد المؤيدين: 95'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}