import 'package:flutter/material.dart';
import 'main.dart';
import 'posts_screen.dart'; // لاستيراد المتغيرات المشتركة

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // بيانات المستخدم - يمكن تغييرها
  String fullName = 'اسم المستخدم';
  String email = 'user@example.com';
  String phone = '+966 50 123 4567';
  String address = 'الرياض، المملكة العربية السعودية';
  String birthDate = '01/01/1990';

  // إحصائيات المستخدم
  int totalLikes = 156; // العدد الإجمالي للايكات
  int suggestionsCount = 12; // عدد الاقتراحات المقدمة
  int followersCount = 89; // عدد المتابعين

  // قائمة الأفكار التي صوت عليها المستخدم
  List<VotedIdea> votedIdeas = [];

  // حالة التعديل
  bool _isEditing = false;

  // متحكمات النصوص
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // تحميل بيانات المستخدم من المتغيرات المشتركة
    _loadUserData();

    // تعيين القيم الأولية للمتحكمات
    _nameController.text = fullName;
    _emailController.text = email;
    _phoneController.text = phone;
    _addressController.text = address;
    _birthController.text = birthDate;
  }

  void _loadUserData() {
    // تحميل عدد التصويتات من البيانات المشتركة
    setState(() {
      totalLikes = globalUserVotes;

      // تحويل البيانات المشتركة إلى List<VotedIdea>
      if (globalVotedIdeas.isNotEmpty) {
        votedIdeas = globalVotedIdeas.map((idea) {
          return VotedIdea(
            title: idea['title'] ?? 'بدون عنوان',
            category: idea['category'] ?? 'عام',
            likes: idea['votes'] ?? 0,
            votedDate: idea['votedDate'] ?? idea['date'] ?? 'غير معروف',
            description: idea['description'] ?? 'لا يوجد وصف',
          );
        }).toList();
      } else {
        // بيانات تجريبية إذا لم توجد بيانات
        votedIdeas = [
          VotedIdea(
            title: 'تطوير نظام النقل العام',
            category: 'النقل',
            likes: 245,
            votedDate: '2024-03-15',
            description: 'تحسين وتوسيع خطوط النقل العام',
          ),
          VotedIdea(
            title: 'حديقة عامة في كل حي',
            category: 'البيئة',
            likes: 189,
            votedDate: '2024-03-10',
            description: 'إنشاء حدائق عامة في جميع الأحياء',
          ),
        ];
      }
    });
  }

  @override
  void dispose() {
    // تنظيف المتحكمات
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      // حفظ التغييرات
      fullName = _nameController.text;
      email = _emailController.text;
      phone = _phoneController.text;
      address = _addressController.text;
      birthDate = _birthController.text;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حفظ التغييرات بنجاح'),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      // استعادة القيم الأصلية
      _nameController.text = fullName;
      _emailController.text = email;
      _phoneController.text = phone;
      _addressController.text = address;
      _birthController.text = birthDate;
      _isEditing = false;
    });
  }

  Widget _buildInfoCard(IconData icon, String label, String value, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                _isEditing
                    ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'أدخل $label',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primaryColor, size: 20),
              onPressed: () {
                // يمكن إضافة منطق خاص للتحرير الفردي
              },
            ),
        ],
      ),
    );
  }

  // دالة لبناء بطاقة الفكرة التي صوت عليها المستخدم
  Widget _buildVotedIdeaCard(VotedIdea idea, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    idea.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    idea.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (idea.description != null && idea.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  idea.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${idea.likes}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Text(
                  'تم التصويت: ${idea.votedDate}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // دالة لتحديث البيانات
  void _refreshData() {
    setState(() {
      _loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث البيانات'),
          backgroundColor: AppColors.primaryColor,
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = AppColors.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: currentColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'تحديث البيانات',
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _isEditing ? _cancelEdit : _toggleEdit,
            tooltip: _isEditing ? 'إلغاء' : 'تعديل',
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [currentColor.withOpacity(0.05), currentColor.withOpacity(0.15)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // صورة الملف الشخصي
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: currentColor,
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: currentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // اسم المستخدم
              Text(
                fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: currentColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // بطاقات المعلومات الشخصية
              _buildInfoCard(Icons.person, 'الاسم الكامل', fullName, _nameController),
              _buildInfoCard(Icons.email, 'البريد الإلكتروني', email, _emailController),
              _buildInfoCard(Icons.phone, 'رقم الهاتف', phone, _phoneController),
              _buildInfoCard(Icons.location_on, 'العنوان', address, _addressController),
              _buildInfoCard(Icons.cake, 'تاريخ الميلاد', birthDate, _birthController),

              const SizedBox(height: 20),

              // زر الحفظ (يظهر فقط في وضع التعديل)
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _cancelEdit,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: currentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 16,
                            color: currentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // معلومات إضافية (تظهر فقط في وضع العرض)
              if (!_isEditing) ...[
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: currentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('الاقتراحات', '$suggestionsCount', Icons.lightbulb_outline, currentColor),
                      _buildStatItem('التصويتات', '$totalLikes', Icons.thumb_up, currentColor),
                      _buildStatItem('المتابعين', '$followersCount', Icons.group, currentColor),
                    ],
                  ),
                ),

                // قسم الأفكار التي صوت عليها المستخدم
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.how_to_vote,
                            color: currentColor,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'الأفكار التي صوتت عليها',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: currentColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'إجمالي التصويتات: $totalLikes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 15),

                      if (votedIdeas.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              'عدد الأفكار المصوت عليها: ${votedIdeas.length}',
                              style: TextStyle(
                                fontSize: 13,
                                color: currentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...votedIdeas
                                .asMap()
                                .entries
                                .map((entry) => _buildVotedIdeaCard(entry.value, entry.key))
                                .toList(),
                          ],
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.how_to_vote_outlined,
                                size: 60,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'لم تقم بالتصويت على أي أفكار بعد',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: () {
                                  // العودة لصفحة البوستات
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: currentColor),
                                ),
                                child: Text(
                                  'استعرض الأفكار',
                                  style: TextStyle(color: currentColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('سيتم إرسال رابط تغيير كلمة المرور لبريدك'),
                          backgroundColor: currentColor,
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock_reset, color: Colors.white),
                    label: const Text(
                      'تغيير كلمة المرور',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

// نموذج للفكرة التي صوت عليها المستخدم
class VotedIdea {
  final String title;
  final String category;
  final int likes;
  final String votedDate;
  final String? description;

  VotedIdea({
    required this.title,
    required this.category,
    required this.likes,
    required this.votedDate,
    this.description,
  });
}