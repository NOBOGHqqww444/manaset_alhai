import 'package:flutter/material.dart';
import 'package:manaset_alhai/FAQScreen.dart';
import 'package:manaset_alhai/ServicesScreen.dart';
import 'package:manaset_alhai/profile_screen.dart';
import 'main.dart';

// بيانات مشتركة للمستخدم (تستخدم في كلا الصفحتين)
int globalUserVotes = 156;
List<Map<String, dynamic>> globalVotedIdeas = [];

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> posts = [];

  // متغيرات خاصة بالصفحة
  int totalUserVotes = 156;
  List<Map<String, dynamic>> votedIdeas = [];

  final List<String> _titles = [
    'اقتراح لتحسين الإنارة في الحي الشرقي',
    'مبادرة لتنظيف الحديقة العامة',
    'مشروع إنشاء مكتبة مجتمعية',
    'تحسين خدمات النقل العام',
    'مبادرة زراعة الأشجار',
    'تطوير الملعب الرياضي',
  ];

  final List<String> _categories = [
    'البنية التحتية',
    'البيئة',
    'التعليم',
    'النقل',
    'البيئة',
    'الرياضة'
  ];

  final List<String> _descriptions = [
    'تحسين نظام الإنارة في الشوارع الفرعية للحي الشرقي لزيادة الأمان',
    'تنظيم حملة أسبوعية لتنظيف الحديقة العامة والتوعية بأهمية النظافة',
    'إنشاء مكتبة مجتمعية توفر الكتب والمصادر التعليمية مجاناً للسكان',
    'تحسين وتوسيع خطوط النقل العام وتقليل وقت الانتظار',
    'زراعة 1000 شجرة في مختلف أنحاء الحي لتحسين جودة الهواء',
    'تحديث وتطوير الملعب الرياضي وإضافة معدات جديدة'
  ];

  final List<Color> _colors = [
    const Color(0xFF2E7D32),
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
  ];
  final List<String> _colorNames = ['أخضر', 'أزرق', 'بنفسجي', 'برتقالي', 'أحمر', 'تركواز'];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _loadUserData();
  }

  void _fetchPosts() => setState(() {
    posts = _titles.asMap().entries.map((entry) {
      final index = entry.key;
      final title = entry.value;
      return {
        'title': title,
        'category': _categories[index],
        'description': _descriptions[index],
        'votes': 0,
        'voted': false,
        'comments': 12,
        'date': 'قبل ${index + 2} أيام',
        'author': 'مقترح من أحد سكان الحي',
        'supporters': 42 + index * 10,
        'id': index
      };
    }).toList();
  });

  void _loadUserData() {
    // تحميل البيانات من المتغيرات المشتركة
    totalUserVotes = globalUserVotes;
    votedIdeas = List.from(globalVotedIdeas);
  }

  void _vote(int i) => setState(() {
    final post = posts[i];
    final wasVoted = post['voted'];

    post['voted'] = !wasVoted;
    post['votes'] += post['voted'] ? 1 : -1;

    if (post['voted']) {
      // إضافة الفكرة إلى قائمة الأفكار المصوت عليها
      _addToVotedIdeas(post);
      totalUserVotes++;
      globalUserVotes = totalUserVotes; // تحديث المتغير المشترك
    } else {
      // إزالة الفكرة من قائمة الأفكار المصوت عليها
      _removeFromVotedIdeas(post['id']);
      totalUserVotes--;
      globalUserVotes = totalUserVotes; // تحديث المتغير المشترك
    }

    // تحديث القائمة المشتركة
    globalVotedIdeas = List.from(votedIdeas);

    _saveUserData();

    // إظهار رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(post['voted']
            ? 'شكراً لك! صوتك سُجل للاقتراح: ${post['title']}'
            : 'تم إلغاء تصويتك على: ${post['title']}'),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  });

  void _addToVotedIdeas(Map<String, dynamic> post) {
    final votedIdea = {
      'id': post['id'],
      'title': post['title'],
      'category': post['category'],
      'votes': post['votes'],
      'votedDate': DateTime.now().toString().substring(0, 10),
      'date': post['date'],
      'description': post['description']
    };

    // إضافة إذا لم تكن موجودة بالفعل
    if (!votedIdeas.any((idea) => idea['id'] == post['id'])) {
      votedIdeas.add(votedIdea);
    }
  }

  void _removeFromVotedIdeas(int id) {
    votedIdeas.removeWhere((idea) => idea['id'] == id);
  }

  void _saveUserData() {
    // هنا يمكن حفظ البيانات في قاعدة البيانات أو SharedPreferences
    // مثال: await Database.saveUserVotes(totalUserVotes, votedIdeas);
  }

  void _filter(String q) => setState(() {
    if (q.isEmpty) return _fetchPosts();
    posts = _titles.where((t) => t.contains(q)).map((t) {
      final p = posts.firstWhere((p) => p['title'] == t,
          orElse: () => {
            'title': t,
            'votes': 0,
            'voted': false,
            'comments': 12,
            'category': 'عام',
            'description': 'وصف الاقتراح'
          });
      return p;
    }).toList();
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاقتراحات والمبادرات'),
        centerTitle: true,
        backgroundColor: color,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12)
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن اقتراح...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: _filter,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, size: 30),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ]),
        ),
        Expanded(
          child: posts.isEmpty
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text('لا توجد اقتراحات حالياً',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: posts.length,
            itemBuilder: (c, i) => _buildCard(posts[i], color, i),
          ),
        ),
      ]),
      endDrawer: _buildMenu(color),
    );
  }

  Widget _buildCard(Map p, Color color, int i) {
    final v = p['voted'];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(Icons.lightbulb_outline, color: color),
          ),
          title: Text(p['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p['category'],
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(p['date'],
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.thumb_up, size: 14, color: v ? color : Colors.grey),
                const SizedBox(width: 4),
                Text('${p['votes']} تصويت',
                    style: TextStyle(
                        fontSize: 13,
                        color: v ? color : Colors.grey,
                        fontWeight: v ? FontWeight.bold : FontWeight.normal)),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${p['comments']} تعليق',
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ]),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              v ? Icons.thumb_up : Icons.thumb_up_outlined,
              color: v ? color : Colors.grey,
              size: 22,
            ),
            onPressed: () => _vote(i),
          ),
          onTap: () => _showDetails(p, color),
        ),
      ),
    );
  }

  void _showDetails(Map p, Color color) => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(p['title'])),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              p['category'],
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(p['description'],
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 16),
          _detailRow(Icons.thumb_up, 'عدد التصويتات: ${p['votes']}', color),
          _detailRow(Icons.people, '${p['supporters']} مؤيد حتى الآن', color),
          _detailRow(Icons.access_time, p['date'], color),
          _detailRow(Icons.person, p['author'], color),
          const SizedBox(height: 16),
          if (p['voted'])
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 18),
                  const SizedBox(width: 8),
                  Text('أنت صوتت على هذا الاقتراح',
                      style: TextStyle(color: Colors.green[700])),
                ],
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('إغلاق'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(c);
            // يمكن هنا فتح صفحة التعليقات
          },
          style: ElevatedButton.styleFrom(backgroundColor: color),
          child: const Text('إضافة تعليق',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  Widget _detailRow(IconData icon, String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 8),
      Expanded(child: Text(text)),
    ]),
  );

  Widget _buildMenu(Color color) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => const ProfileScreen(),
              ),
            );
          },
          child: DrawerHeader(
            decoration: BoxDecoration(color: color),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.groups, size: 40, color: color),
                ),
                const SizedBox(height: 10),
                const Text('مستخدم صوت الحي',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Text('user@sawt-alhay.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.thumb_up,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('$totalUserVotes تصويت',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('اختيار اللون',
              style: TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 15,
            runSpacing: 10,
            children: List.generate(
              _colors.length,
                  (i) => _colorOption(
                  _colors[i], _colorNames[i], color, i == 0),
            ),
          ),
        ),
        _menuItem(Icons.miscellaneous_services, 'الخدمات', color,
                () => _navigateToServices(color)),
        _menuItem(Icons.help_outline, 'الأسئلة الشائعة', color,
                () => _navigateToFAQ(color)),
        const Divider(),
        _menuItem(Icons.settings, 'إعادة تعيين اللون', color, _resetColor),
        _menuItem(Icons.logout, 'تسجيل الخروج', Colors.red, _showLogoutDialog),
      ],
    ),
  );

  Widget _colorOption(Color clr, String label, Color currentColor, bool isDefault) =>
      GestureDetector(
        onTap: () {
          AppColors.primaryColor = clr;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const PostsScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('تم تغيير اللون إلى $label'),
                  backgroundColor: clr
              )
          );
        },
        child: Column(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: clr,
              shape: BoxShape.circle,
              border: currentColor == clr
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
            ),
            child: isDefault && currentColor == clr
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: isDefault ? clr : Colors.grey,
                fontWeight: isDefault ? FontWeight.bold : FontWeight.normal,
              )),
        ]),
      );

  Widget _menuItem(IconData icon, String title, Color color, Function() onTap) =>
      ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color)),
        onTap: onTap,
      );

  void _navigateToServices(Color color) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ServicesScreen(
          currentColor: color,
          onColorChanged: (c) => AppColors.primaryColor = c,
        ),
      ),
    );
  }

  void _navigateToFAQ(Color color) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => FAQScreen(currentColor: color), // ✅ بدون onColorChanged
      ),
    );
  }

  void _resetColor() {
    AppColors.primaryColor = const Color(0xFF2E7D32);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('تم إعادة تعيين اللون إلى الإفتراضي'),
            backgroundColor: Color(0xFF2E7D32)
        )
    );
  }

  void _showLogoutDialog() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}