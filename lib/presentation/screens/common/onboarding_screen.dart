
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cookbook_ia/core/setting.dart';
import 'package:cookbook_ia/presentation/screens/mobile/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen extends StatefulHookConsumerWidget {

  OnboardingScreen();

  @override
  OnboardingScreenState createState() => new OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {

  OnboardingScreenState();

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset('img/logo.png'),
            nextScreen: HomePageScreen(),
            centered: true,
            splashIconSize: 200.0,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Setting.primaryColor
          );
            
  }
    
  }