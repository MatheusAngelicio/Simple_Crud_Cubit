import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:page_indicator/page_indicator.dart';

final googleClientId = kIsWeb || Platform.isAndroid
    ? '320233292561-1pdjllql3uc59t3i4fg08psu6ri579qv.apps.googleusercontent.com'
    : '320233292561-n4r0t490u7vqnnu1lvf6t0cm70b91fth.apps.googleusercontent.com';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: _IntroPager(),
    );
  }
}

class _IntroPager extends StatelessWidget {
  final String exampleText =
      'Lorem ipsum dolor sit amet, conscreated advising elit se,'
      'def do eismod tempor sincudt ut labore et'
      'dolore magna aligua. Ut enim ad minum vianem';

  @override
  Widget build(BuildContext context) {
    return PageIndicatorContainer(
      align: IndicatorAlign.bottom,
      length: 4,
      indicatorSpace: 12,
      indicatorColor: Colors.grey,
      indicatorSelectorColor: Colors.black,
      child: PageView(
        children: [
          _DescriptionPage(text: exampleText, imagePath: 'assets/intro_1.png'),
          _DescriptionPage(text: exampleText, imagePath: 'assets/intro_2.png'),
          _DescriptionPage(text: exampleText, imagePath: 'assets/intro_3.png'),
          _LoginPage()
        ],
      ),
    );
  }
}

class _DescriptionPage extends StatelessWidget {
  final String text;
  final String imagePath;

  const _DescriptionPage({
    super.key,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
    );
  }
}

class _LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providerConfigs: [
        GoogleProviderConfiguration(clientId: googleClientId),
        const FacebookProviderConfiguration(clientId: ''),
        const EmailProviderConfiguration(),
      ],
    );
  }
}
