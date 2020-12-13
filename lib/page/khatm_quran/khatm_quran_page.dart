import 'package:flutter/material.dart';
import 'package:quran/main.dart';

class KhatmQuranPage extends StatefulWidget {
  @override
  _KhatmQuranPageState createState() => _KhatmQuranPageState();
}

class _KhatmQuranPageState extends State<KhatmQuranPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: 'دعاء ختم القران', context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
                text: "* ",
                style: TextStyle(fontSize: 30, fontFamily: 'alquran')),
            TextSpan(
                text:
                    'اللهم أرحمنى بالقرءان واجعله لى إماما ونورا وهدى ورحمة اللهم ذكرنى منه ما نسيت وعلمنى منه ما جهلت وارزقنى تلاوته آناء الليل وأطراف النهار وأجعله لى حجة يارب العالمين',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'ربنا آتنا فى الدنيا حسنة وفى الأخرة حسنة وقنا عذاب الناروصلى الله على نبينا محمد وعلى آله وأصحابه الأخيار وسلم تسليما كثيرا',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم لا تدع لنا ذنبا إلا غفرته ولا هما إلا فرجته ولا دينا إلا قضيته ولا حاجة من حوائج الدنيا والأخرة هى لك رضى إلا قضيتها ياأرحم الراحمين',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم أقسم لنا من خشيتك ما تحول به بيننا وبين معصيتك ومن طاعتك ماتبلغنا بها جنتك ومن اليقين ما تهون به علينا من مصائب الدنيا ومتعنا بأسماعنا وأبصارنا وقوتنا ماأحييتنا وأجعله الوارث منا وأجعل ثأرنا على من ظلمنا وأنصرنا على من عادانا ولا تجعل مصيبتنا فى ديننا ولا تجعل الدنيا أكبر همنا ولا مبلغ علمنا ولا تسلط علينا من لا يرحمنا',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم أقسم لنا من خشيتك ما تحول به بيننا وبين معصيتك ومن طاعتك ماتبلغنا بها جنتك ومن اليقين ما تهون به علينا من مصائب الدنيا ومتعنا بأسماعنا وأبصارنا وقوتنا ماأحييتنا وأجعله الوارث منا وأجعل ثأرنا على من ظلمنا وأنصرنا على من عادانا ولا تجعل مصيبتنا فى ديننا ولا تجعل الدنيا أكبر همنا ولا مبلغ علمنا ولا تسلط علينا من لا يرحمنا',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم أحسن عاقبتنا فى الامور كلها وأجرنا من خزى الدنيا وعذاب الأخرة',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم إنى أسألك موجبات رحمتك وعزائم مغفرتك والسلامة من كل إثم والغنيمة من كل بر والفوز بالجنة والنجاة من النار',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم عنى أسألك خير المسألة وخير الدعاء وخير النجاح وخير العلم وخير العمل وخير الثواب وخير الحياة وخير الممات وثبتنى وثقل موازينى وحقق امانى وأرفع درجاتى وتقبل صلاتى وأغفر لى خطيئاتى وأسألك العلا من الجنة',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم إنى أسألك عيشة هنية وميتة سوية ومرادا غير مخز ولافاضح',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم أجعل خير عمرى آخره وخير عملى خواتمه وخير أيامى يوم ألقاك فيه',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
            _starSpan(),
            TextSpan(
                text:
                    'اللهم أصلح لى دينى الذى هو عصمة أمرى وأصلح لى دنياى التى فيها معاشى وأصلح لى آخرتى التى فيها معادى وأجعل الحياة زيادة لى فى كل خير وأجعل الموت راحة لى من كل شر',
                style: TextStyle(fontSize: 22, fontFamily: 'alquran')),
          ]),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  TextSpan _starSpan() {
    return TextSpan(
        text: "\n* ", style: TextStyle(fontSize: 30, fontFamily: 'alquran'));
  }
}

