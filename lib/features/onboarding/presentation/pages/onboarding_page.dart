import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Kalbinizden Notlar mı?',
      'description':
          'Evet, yanlış duymadınız! Artık kalbinizden geçenleri not alabilirsiniz. Hem de en duygusalından, en komiğine kadar!',
      'image': 'assets/lottie/onboarding_heart.json',
    },
    {
      'title': 'AI ile Mesaj Yaratın!',
      'description':
          'Siz sadece anahtar kelimeleri seçin, gerisini AI\'ya bırakın. O size en yaratıcı, en duygusal mesajları hazırlasın.',
      'image': 'assets/lottie/onboarding_ai.json',
    },
    {
      'title': 'Paylaşın, Saklayın, Keyfini Çıkarın!',
      'description':
          'Oluşturduğunuz mesajları dilediğiniz gibi paylaşın veya saklayın. Hatta bir gün dönüp baktığınızda "Ben bunu mu yazmışım?" diyeceğiniz anılar biriktirin.',
      'image': 'assets/lottie/onboarding_share.json',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_onboardingData[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Geç'),
                    onPressed: () => _completeOnboarding(context),
                  ),
                  DotsIndicator(
                    dotsCount: _onboardingData.length,
                    position: _currentPage,
                    decorator: const DotsDecorator(
                      color: CupertinoColors.inactiveGray,
                      activeColor: CupertinoColors.destructiveRed,
                    ),
                  ),
                  CupertinoButton(
                    child: Text(_currentPage == _onboardingData.length - 1
                        ? 'Başla'
                        : 'İleri'),
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _completeOnboarding(context);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            data['image']!,
            height: 200,
            repeat: false,
          ),
          const SizedBox(height: 32),
          Text(
            data['title']!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data['description']!,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    context.go('/');
  }
}
