import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Dialogs/action_dialog.dart';
import '../Utilits/colors.dart';
import '../Widgets/slide.dart';
import '../Widgets/slide_dotes.dart';
import '../Widgets/slide_items.dart';
import 'before_registration.dart';

class OnBoarding extends StatefulWidget {
  static const String id = 'ON_BOARDING';

  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        switch (_currentPage) {
          case 0:
            showDialog(
              context: context,
              builder: (context) => ActionDialog(
                title: 'الخروج من التطبيق',
                content: 'هل تود الخروج من التطبيق',
                approveAction: 'نعم',
                cancelAction: 'لا',
                onApproveClick: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
                onCancelClick: () {
                  Navigator.pop(context);
                },
              ),
            );
            break;
          case 1:
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            break;
          case 2:
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  itemCount: slideList.length,
                  itemBuilder: (context, i) => SlideItems(i),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(
                            const Size(0, 0),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            BeforeRegistration.id,
                          );
                        },
                        child: Text(
                          'تخطي',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          slideList.length,
                          (i) => i == _currentPage
                              ? const SlideDotes(true)
                              : const SlideDotes(false),
                        ),
                      ),
                    ),
                    TextButton(
                        style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size(0, 0),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryBlueColor,
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(
                              Colors.white,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(10.0))),
                        onPressed: () {
                          if (_currentPage == slideList.length - 1) {
                            Navigator.pushReplacementNamed(
                              context,
                              BeforeRegistration.id,
                            );
                          }
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 25.0,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
