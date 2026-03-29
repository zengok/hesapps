import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkNavy;
    final bodyColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkBackgroundGradient : AppTheme.lightBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Hakkımızda',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: textColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              borderRadius: 24,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Text(
                      'Bizim Hikayemiz',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Paragraf 1
                    Text(
                      'Biz, bir zamanlar aynı masalarda, aynı işyerinin koridorlarında yan yana yürüyen, ama kalplerinde çok daha büyük bir dünyanın hayalini taşıyan bir grup arkadaşız. Bizi bir araya getiren şey sadece mesai saatleri değil; ortak bir heyecan, sınırsız bir potansiyel inancı ve en önemlisi, sarsılmaz bir dostluk bağı oldu. Hepimiz o bilindik yolda ilerleyebilirdik. Garanti edilmiş bir maaş, kurulu bir düzen... Ancak içimizdeki ses, "Daha fazlası mümkün," diye fısıldıyordu. Bizi bu yola çıkaran o kıvılcım, bir öğle molasında paylaşılan cesur bir hayalden doğdu. O gün, sadece bir fikir değil, ortak bir gelecek inşa etme sözü verdik.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 15,
                        color: bodyColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paragraf 2
                    Text(
                      'İşte bu yüzden buradayız. Biz, konfor alanını terk etmenin gücüne inananlarız. "Hayallerin, sadece uyurken görülen imgeler değil, uyanıkken peşinden koşulması gereken hedefler" olduğunu biliyoruz. Her birimiz, kendi benzersiz yeteneğimizi ve tutkumuzu ortaya koyduk. Bu şirket, sadece bir iş yeri değil; her birimizin kalbinden söküp aldığı, özenle büyüttüğü bir umut bahçesidir.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 15,
                        color: bodyColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paragraf 3
                    Text(
                      'Bu yolculuk kolay olmadı ve olmayacak. Şüpheler, zorluklar ve yorgunluk anları olacak. Ama bizi ayakta tutacak yegâne şey: birbirimize olan güvenimiz. "Zor bir kararın eşiğinde, birbirimizin gözlerine bakıp \'Yapabiliriz\' dediğimiz o anlar, bizim en büyük sermayemizdir." Biz, sadece iş arkadaşı değiliz; biz, sırtını birbirine dayamış bir aileyiz. Biliyoruz ki, büyük başarılar sadece büyük çabalarla kazanılır. Bu yüzden her güne, daha iyisini yapma arzusuyla başlıyor, her engeli bir öğrenme fırsatı olarak görüyoruz. Kimsenin kolay elde ettiğini düşünmediği bir başarıyı, gece gündüz demeden çalışarak, dürüstlükle ve azimle inşa ediyoruz.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        height: 1.7,
                        fontSize: 15,
                        color: bodyColor,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Alt imza çizgisi
                    Center(
                      child: Text(
                        '— HesApps Ekibi',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
