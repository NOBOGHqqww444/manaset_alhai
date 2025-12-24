import 'package:flutter/material.dart';
class ServicesScreen extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;

  const ServicesScreen({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخدمات'),
        backgroundColor: currentColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.miscellaneous_services,
              size: 100,
              color: currentColor,
            ),
            const SizedBox(height: 20),
            Text(
              'خدمات منصة صوت الحي',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: currentColor,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildServiceItem(
                    context,
                    icon: Icons.lightbulb_outline,
                    title: 'تقديم الاقتراحات',
                    description: 'قدم اقتراحاتك لتحسين الحي',
                  ),
                  _buildServiceItem(
                    context,
                    icon: Icons.track_changes,
                    title: 'متابعة التنفيذ',
                    description: 'تابع مراحل تنفيذ الاقتراحات',
                  ),
                  _buildServiceItem(
                    context,
                    icon: Icons.groups,
                    title: 'المبادرات المجتمعية',
                    description: 'انضم للمبادرات التطوعية في الحي',
                  ),
                  _buildServiceItem(
                    context,
                    icon: Icons.report,
                    title: 'الإبلاغ عن مشكلات',
                    description: 'بلغ عن أي مشكلة في الحي',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context,
      {required IconData icon,
        required String title,
        required String description}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: currentColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: currentColor),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خدمة: $title'),
              backgroundColor: currentColor,
            ),
          );
        },
      ),
    );
  }
}