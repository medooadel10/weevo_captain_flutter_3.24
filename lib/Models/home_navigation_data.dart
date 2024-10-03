import 'package:flutter/material.dart';

class HomeNavigationData {
  final String svgPicture;
  final String label;
  final Color? backgroundColor;

  HomeNavigationData(
    this.svgPicture,
    this.label, {
    this.backgroundColor,
  });

  static final List<HomeNavigationData> navigationData = [
    HomeNavigationData(
      'assets/images/home_white.svg',
      'الرئيسية',
    ),
    HomeNavigationData(
      'assets/images/notifications_white.svg',
      'الاشعارات',
    ),
    HomeNavigationData(
      'assets/images/messages_white.svg',
      'الرسائل',
    ),
    HomeNavigationData(
      'assets/images/profile_white.svg',
      'الحساب',
    ),
  ];
}
