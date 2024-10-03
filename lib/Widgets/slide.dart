import 'package:flutter/cupertino.dart';

import '../Screens/splash.dart';

class Slide {
  String title;
  String image;
  String desc;

  Slide({
    required this.image,
    required this.desc,
    required this.title,
  });
}

// ignore: non_constant_identifier_names
final slideList = [
  Slide(
      image: 'assets/images/on_boarding_1.png',
      desc: "اختر وسيلة الدفع الإلكتروني المناسبة\nلشحن محفظة ويفو",
      title: "اشحن محفظتك"),
  Slide(
      image: 'assets/images/on_boarding_2.png',
      desc: "ابدء في البحث عن طلبات الشحن\nفي نطاق موقعك",
      title: "استكشف طلبات الشحن"),
  Slide(
      image: 'assets/images/on_boarding_3.png',
      desc: "ادخل عرض الشحن الخاص بك\nوانتظر موافقة البائع",
      title: "قدم عرض الشحن"),
];

class Category {
  String? titlecat;
  String? subtitle;
  Function? onTap;
  String? catimage;
  String? salary;
  String? weight;
  String? buttoncar;
  String? imagecar;

  Category({
    this.titlecat,
    this.catimage,
    this.onTap,
    this.buttoncar,
    this.imagecar,
    this.salary,
    this.subtitle,
    this.weight,
  });
}

final categoryList = [
  Category(
      catimage: "assets/images/shirt.png",
      titlecat: "تيشرت مقاس لارج",
      subtitle: "تيشرتات مقاس لارج خامة قطن",
      imagecar: 'assets/images/car.png',
      salary: '1500',
      weight: '10',
      onTap: (context) {
        Navigator.pushNamed(context, Splash.id);
      }),
  Category(
      catimage: "assets/images/gym.png",
      titlecat: "تيشرت مقاس لارج",
      subtitle: "تيشرتات مقاس لارج خامة قطن",
      imagecar: 'assets/images/car.png',
      salary: '1750',
      weight: '15'),
  Category(
      catimage: "assets/images/shirt.png",
      titlecat: "تيشرت مقاس لارج",
      subtitle: "تيشرتات مقاس لارج خامة قطن",
      imagecar: 'assets/images/car.png',
      salary: '1400',
      weight: '20'),
  Category(
      catimage: "assets/images/shirt.png",
      titlecat: "تيشرت مقاس لارج",
      subtitle: "تيشرتات مقاس لارج خامة قطن",
      imagecar: 'assets/images/car.png',
      salary: '1250',
      weight: '30'),
];
