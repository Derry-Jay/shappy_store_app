class FrequentlyAskedQuestions{
  final int faqID,faqType;
  final String question,answer;
  FrequentlyAskedQuestions(this.faqID,this.faqType,this.question,this.answer);
  factory FrequentlyAskedQuestions.fromMap(Map<String, dynamic> json){
    return FrequentlyAskedQuestions(json['FAQ_ID'],json['Faq_type'],json['Faq_Qus'],json['Faq_Ans']);
  }
}