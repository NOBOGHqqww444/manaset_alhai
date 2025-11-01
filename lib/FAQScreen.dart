import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorChanged;

  const FAQScreen({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة الشائعة'),
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
              Icons.help_outline,
              size: 100,
              color: currentColor,
            ),
            const SizedBox(height: 20),
            Text(
              'الأسئلة الشائعة',
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
                  _buildFAQItem(
                    question: 'كيف أقدم اقتراحاً جديداً؟',
                    answer:
                    'يمكنك تقديم اقتراح جديد من خلال النقر على أيقونة (+) في شاشة الاقتراحات',
                  ),
                  _buildFAQItem(
                    question: 'هل يمكنني تعديل اقتراح قدمته؟',
                    answer: 'نعم، يمكنك تعديل اقتراحك خلال 24 ساعة من تقديمه',
                  ),
                  _buildFAQItem(
                    question: 'كم عدد التصويتات المطلوبة لتنفيذ الاقتراح؟',
                    answer: 'يتم دراسة الاقتراحات التي تحصل على 100 تصويت أو أكثر',
                  ),
                  _buildFAQItem(
                    question: 'كيف أتابع حالة اقتراحي؟',
                    answer: 'يمكنك متابعة حالة اقتراحك من خلال صفحة المتابعة',
                  ),
                  _buildFAQItem(
                    question: 'هل الخدمة مجانية؟',
                    answer: 'نعم، الخدمة مجانية بالكامل لجميع سكان الحي',
                  ),
                  _buildFAQItem(
                    question: 'كيف أبلغ عن مشكلة تقنية؟',
                    answer: 'يمكنك التواصل مع الدعم الفني من خلال قسم المساعدة',
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'العودة للرئيسية',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(Icons.help, color: currentColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: currentColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}