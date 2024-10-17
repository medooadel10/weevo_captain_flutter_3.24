import 'package:flutter/material.dart';

class HomeNavigationData {
  final String svgPicture;
  final String svgPicutureSelected;
  final String label;
  final Color? backgroundColor;

  HomeNavigationData(
    this.svgPicture,
    this.svgPicutureSelected,
    this.label, {
    this.backgroundColor,
  });

  static final List<HomeNavigationData> navigationData = [
    HomeNavigationData(
      'assets/images/home_unselected.svg',
      'assets/images/home_selected.svg',
      'الرئيسية',
    ),
    HomeNavigationData(
      'assets/images/notifications_unselected.svg',
      'assets/images/notifications_selected.svg',
      'الاشعارات',
    ),
    HomeNavigationData(
      'assets/images/messages_unselected.svg',
      'assets/images/messages_selected.svg',
      'الرسائل',
    ),
    HomeNavigationData(
      'assets/images/profile_white.svg',
      'assets/images/profile_white.svg',
      'الحساب',
    ),
  ];
}
