import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/constants/app_info.dart';
import 'package:dalal_street_client/constants/urls.dart';
import 'package:dalal_street_client/theme/buttons.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/responsive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  Widget buildBody(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;

    return screenwidth > 1000
        ? SingleChildScrollView(
            child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: secondaryColor, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: body(context),
            margin: EdgeInsets.fromLTRB(screenwidth * 0.25, screenwidth * 0.03,
                screenwidth * 0.25, screenwidth * 0.05),
          ))
        : FillMaxHeightScrollView(builder: (context) => body(context));
  }

  @override
  Widget build(context) => Scaffold(
        body: Responsive(
          desktop: const LandingPageWeb(),
          tablet: SafeArea(
            child: (buildBody(context)),
          ),
          mobile: SafeArea(
            child: (buildBody(context)),
          ),
        ),
      );

  SizedBox body(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/bull_image.png',
              height: 300,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    appTitle,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    appDesc,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () => onRegisterClick(context),
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: secondaryButtonStyle,
                    onPressed: () => onLoginClick(context),
                    child: const Text('Log In'),
                  ),
                ),
              ],
            ),
            buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget buildFooter(BuildContext context) => Padding(
        padding: const EdgeInsets.all(0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 15),
            children: [
              const TextSpan(text: 'Made with '),
              TextSpan(
                text: '♥',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      fontSize: 15,
                      color: heartRed,
                    ),
                recognizer: TapGestureRecognizer()..onTap = onHeartClick,
              ),
              const TextSpan(text: ' by '),
              TextSpan(
                text: 'Delta',
                style: Theme.of(context).textTheme.caption?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                recognizer: TapGestureRecognizer()..onTap = onDeltaClick,
              ),
            ],
          ),
        ),
      );

  void onRegisterClick(BuildContext context) => context.push('/register');

  void onLoginClick(BuildContext context) => context.push('/login');

  void onHeartClick() => launch(helikopterHelikopter);

  void onDeltaClick() => launch(deltaUrl);
}

class LandingPageWeb extends StatelessWidget {
  const LandingPageWeb({Key? key}) : super(key: key);
  void onRegisterClick(BuildContext context) => context.push('/register');

  void onLoginClick(BuildContext context) => context.push('/login');
//
  void onHeartClick() => launch(helikopterHelikopter);

  void onDeltaClick() => launch(deltaUrl);

  void onDocsClick() => launch(docsLink);
  void onForumClick() => launch(forumLink);
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/LandingBackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 125, vertical: 50),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(52, 52, 52, 0.15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Row(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Dalal Street',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 32),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        TextButton(
                            onPressed: () => onDocsClick(),
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 15)),
                            child: const Text(
                              'Docs',
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.normal),
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                        TextButton(
                          onPressed: () => onForumClick(),
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5)),
                          child: const Text(
                            'Forum',
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () => onLoginClick(context),
                            child: const Text('Login')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () => onRegisterClick(context),
                          child: const Text('Get Started',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.60,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 25),
                    width: screenwidth * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dalal Street',
                          style: TextStyle(
                            fontSize: 120.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          '\'Know what you own, and know why you own it.\'',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          ' - Peter Lynch',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: white,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 45),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25), // <-- Radius
                              )),
                          onPressed: () => onRegisterClick(context),
                          child: const Text('Get Started',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenwidth * 0.25,
                    height: screenHeight,
                    child: Image.asset('assets/images/bull_image.png',
                        alignment: Alignment.topRight,
                        width: 200,
                        height: 450,
                        fit: BoxFit.contain),
                  )
                  // width: screenwidth * 0.5,
                  // height: screenHeight * 0.65,
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    Theme.of(context).textTheme.caption?.copyWith(fontSize: 18),
                children: [
                  const TextSpan(text: 'Made with '),
                  TextSpan(
                    text: '♥',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontSize: 18,
                          color: heartRed,
                        ),
                    recognizer: TapGestureRecognizer()..onTap = onHeartClick,
                  ),
                  const TextSpan(text: ' by '),
                  TextSpan(
                    text: 'Delta',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                    recognizer: TapGestureRecognizer()..onTap = onDeltaClick,
                  ),
                ],
              ),
            )
          ],
        ) /* add child content here */,
      ),
    );
  }
}
