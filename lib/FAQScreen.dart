import 'package:flutter/material.dart';
import 'main.dart';
class FAQScreen extends StatelessWidget {
  final Color currentColor;

  const FAQScreen({
    super.key,
    required this.currentColor,
  });
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {   'question': 'كيف يمكنني تقديم اقتراح جديد؟',
        'answer': 'من خلال زر "اقتراح جديد" في الصفحة الرئيسية.',},

      {'question': 'كم عدد التصويتات المسموحة؟',
        'answer': 'يمكنك التصويت على عدد غير محدود من الاقتراحات.',},

      {'question': 'كيف أتأكد من قبول اقتراحي؟',
        'answer': 'سيتم إشعارك عبر البريد الإلكتروني أو الإشعارات.',},
      {'question': 'هل يمكنني تعديل اقتراحي؟',
        'answer': 'نعم، خلال 24 ساعة من تقديمه.',},

      {'question': 'كيف يتم اختيار الاقتراحات المنفذة؟',
        'answer': 'بناءً على عدد التصويتات والجدوى التقنية.',
      },
      {'question': 'هل يمكنني مشاركة الاقتراحات؟',
        'answer': 'نعم، عبر وسائل التواصل الاجتماعي أو الرابط.',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة الشائعة'),
        backgroundColor: currentColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),   ),),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              currentColor.withOpacity(0.05),
              currentColor.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,   ),),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            return _buildFAQItem(
              faqList[index]['question']!,
              faqList[index]['answer']!,
              currentColor,
              index,    );},),),);}
  Widget _buildFAQItem(String question, String answer, Color color, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle, ),
            child: Icon(
              Icons.help_outline,
              color: color,
              size: 20,  ),),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],  ),),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4), ),
                child: Text(
                  'سؤال ${index + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),),),],),
          trailing: Icon(
            Icons.expand_more,
            color: color,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),),),],),),);}}