import 'faq.dart';

class FrequentlyAskedQuestionsBase{
  final bool success;
  final List<FrequentlyAskedQuestions> faqs;
  FrequentlyAskedQuestionsBase(this.success,this.faqs);
  factory FrequentlyAskedQuestionsBase.fromMap(Map<String, dynamic> json){
    return FrequentlyAskedQuestionsBase(json['success'], json['FAQs'] != null ? List.from(json['FAQs']).map((element) => FrequentlyAskedQuestions.fromMap(element)).toList() : []);
  }
}