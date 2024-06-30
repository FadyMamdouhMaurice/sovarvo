import 'package:flutter/material.dart';

Widget buildArabicTerms() {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: '1. المقدمة:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- باستخدامك لخدماتنا، فإنك توافق على الالتزام بالشروط والأحكام التالية. يُرجى قراءتها بعناية قبل إجراء أي حجز.\n\n',
          ),
          TextSpan(
            text: '2. التسجيل والحساب:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- يجب على العميل التسجيل بحساب صحيح وتقديم معلومات شخصية دقيقة وكاملة.\n'
                '- يتحمل العميل مسؤولية الحفاظ على سرية معلومات الحساب وكلمة المرور.\n\n',
          ),
          TextSpan(
            text: '3. المحافظة على الأسطوانات:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- يتعهد العميل بالمحافظة على الأسطوانات وعدم تعريضها لأي نوع من الضرر أو التلف.\n'
                '- يُمنع تمامًا خدش الأسطوانات أو تعريضها لأية مواد قد تؤدي إلى تلفها.\n\n',
          ),
          TextSpan(
            text: '4. المسؤولية القانونية:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- في حالة حدوث أي ضرر أو تلف للأسطوانة بسبب سوء الاستخدام أو الإهمال من قبل العميل، سيتم مسائلة العميل قانونيًا.\n\n',
          ),
          TextSpan(
            text: '5. فحص الأسطوانات عند الإرجاع:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '- يتم فحص كل أسطوانة بدقة عند إرجاعها.\n'
                '- إذا وُجد أي ضرر أو تلف، سيتم مطالبة العميل بقيمة اللعبة كاملة وعدم رد مبلغ التأمين (إن وجد).\n\n',
          ),
          TextSpan(
            text: '6. مدة الفحص:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '- تستغرق عملية الفحص حتى 5 أيام عمل.\n\n',
          ),
          TextSpan(
            text: '7. رسوم التأجير والدفع:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '- يتم تحديد رسوم التأجير وفقًا للمدة ونوع اللعبة.\n'
                '- يجب دفع رسوم التأجير مسبقًا باستخدام الوسائل المتاحة على الموقع.\n\n',
          ),
          TextSpan(
            text: '8. سياسة الإلغاء:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- يُرجى ملاحظة أنه بمجرد تأكيد الحجز، لا يمكن للعميل إلغاء الطلب.\n\n',
          ),
          TextSpan(
            text: '9. إخلاء المسؤولية:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- الموقع غير مسؤول عن الأضرار الناتجة عن سوء الاستخدام بعد استلام العميل للأسطوانة.\n\n',
          ),
          TextSpan(
            text: '10. الاستخدام المقبول:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- يُمنع نسخ الألعاب أو توزيعها أو استخدامها بشكل غير قانوني.\n'
                '- يُحظر استخدام الأسطوانات لأغراض تجارية بدون إذن مسبق.\n\n',
          ),
          TextSpan(
            text: '11. حقوق الملكية الفكرية:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- جميع حقوق الملكية الفكرية المتعلقة بالألعاب والخدمات مملوكة لنا أو لأطراف ثالثة مرخصة.\n'
                '- لا يُسمح بنسخ أو تعديل أو توزيع أي محتوى بدون إذن كتابي مسبق.\n\n',
          ),
          TextSpan(
            text: '12. الدعم الفني وخدمة العملاء:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            '- نقدم دعمًا فنيًا للعملاء عبر البريد الإلكتروني والهاتف خلال ساعات العمل المحددة.\n'
                '- نلتزم بالرد على استفسارات العملاء في غضون 48 ساعة.\n\n',
          ),
          TextSpan(
            text: '13. التعديلات على الشروط والأحكام:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '- نحتفظ بالحق في تعديل هذه الشروط والأحكام في أي وقت.\n'
                '- سيتم إخطار العملاء بأي تغييرات عبر البريد الإلكتروني أو من خلال الموقع.\n\n',
          ),
          TextSpan(
            text: '14. القانون الواجب التطبيق وحل النزاعات:\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '- تخضع هذه الشروط والأحكام لقوانين الدولة التي نقع فيها.\n'
                '- يتم حل أي نزاعات تنشأ عن استخدام خدماتنا بشكل ودي، وإذا تعذر ذلك، يتم اللجوء إلى المحاكم المختصة.\n\n',
          ),
        ],
      ),
    ),
  );
}

Widget buildEnglishTerms() {
  return RichText(
    text: TextSpan(
      style: TextStyle(color: Colors.white),
      children: [
        TextSpan(
          text: '1. Introduction:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- By using our services, you agree to comply with the following terms and conditions. Please read them carefully before making any reservation.\n\n',
        ),
        TextSpan(
          text: '2. Registration and Account:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- Customers must register with accurate and complete personal information.\n'
              '- Customers are responsible for maintaining the confidentiality of their account information and password.\n\n',
        ),
        TextSpan(
          text: '3. Disc Care:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- The customer agrees to maintain the discs in good condition and not subject them to any form of damage.\n'
              '- Scratching the discs or exposing them to any substances that may cause damage is strictly prohibited.\n\n',
        ),
        TextSpan(
          text: '4. Legal Responsibility:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- In case of any damage or loss of the disc due to misuse or negligence by the customer, the customer will be held legally accountable.\n\n',
        ),
        TextSpan(
          text: '5. Disc Inspection Upon Return:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: '- Each disc will be thoroughly inspected upon return.\n'
              '- If any damage or loss is found, the customer will be charged the full value of the game and the deposit will not be refunded (if applicable).\n\n',
        ),
        TextSpan(
          text: '6. Inspection Duration:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: '- The inspection process may take up to 5 business days.\n\n',
        ),
        TextSpan(
          text: '7. Rental Fees and Payment:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- Rental fees are determined based on the rental period and type of game.\n'
              '- Rental fees must be paid in advance using the available payment methods on the site.\n\n',
        ),
        TextSpan(
          text: '8. Cancellation Policy:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- Please note that once the reservation is confirmed, customers cannot cancel the order.\n\n',
        ),
        TextSpan(
          text: '9. Disclaimer:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- The website is not responsible for any damages resulting from misuse after the customer has received the disc.\n\n',
        ),
        TextSpan(
          text: '10. Acceptable Use:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- Copying, distributing, or using the games illegally is strictly prohibited.\n'
              '- Using the discs for commercial purposes without prior permission is prohibited.\n\n',
        ),
        TextSpan(
          text: '11. Intellectual Property Rights:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- All intellectual property rights related to the games and services are owned by us or licensed third parties.\n'
              '- Copying, modifying, or distributing any content without prior written permission is not allowed.\n\n',
        ),
        TextSpan(
          text: '12. Technical Support and Customer Service:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- We offer technical support to customers via email and phone during specified working hours.\n'
              '- We commit to responding to customer inquiries within 48 hours.\n\n',
        ),
        TextSpan(
          text: '13. Amendments to Terms and Conditions:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- We reserve the right to amend these terms and conditions at any time.\n'
              '- Customers will be notified of any changes via email or through the website.\n\n',
        ),
        TextSpan(
          text: '14. Governing Law and Dispute Resolution:\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text:
          '- These terms and conditions are governed by the laws of the country in which we are located.\n'
              '- Any disputes arising from the use of our services will be resolved amicably, and if that is not possible, they will be referred to the competent courts.\n\n',
        ),
      ],
    ),
  );
}