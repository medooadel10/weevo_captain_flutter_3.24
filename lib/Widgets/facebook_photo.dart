import 'package:flutter/material.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../Models/product.dart';

class CustomPhoto extends StatefulWidget {
  final List<Product> products;

  const CustomPhoto({
    super.key,
    required this.products,
  });

  @override
  State<CustomPhoto> createState() => _CustomPhotoState();
}

class _CustomPhotoState extends State<CustomPhoto> {
  final height = 170.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(height: height, child: buildImages(size));
  }

  Widget buildImages(Size size) {
    final length = widget.products.length;
    Widget imageWidget;
    if (length == 1) {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
        child: CustomImage(
          image: widget.products[0].productInfo!.image!,
          width: size.width,
          height: size.height,
          radius: 0,
        ),
      );
    } else if (length == 2) {
      imageWidget = Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20.0)),
              child: CustomImage(
                image: widget.products[0].productInfo!.image!,
                width: size.width,
                height: size.height,
                radius: 0,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20.0)),
              child: CustomImage(
                image: widget.products[1].productInfo!.image!,
                width: size.width,
                height: size.height,
                radius: 0,
              ),
            ),
          ),
        ],
      );
    } else if (length == 3) {
      imageWidget = Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20.0)),
              child: CustomImage(
                image: widget.products[0].productInfo!.image!,
                width: size.width,
                height: size.height,
                radius: 0,
              ),
            ),
          ),
          Expanded(
            child: CustomImage(
              image: widget.products[1].productInfo!.image!,
              width: size.width,
              height: size.height,
              radius: 0,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20.0)),
              child: CustomImage(
                image: widget.products[2].productInfo!.image!,
                width: size.width,
                height: size.height,
                radius: 0,
              ),
            ),
          ),
        ],
      );
    } else {
      imageWidget = Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(20.0)),
              child: CustomImage(
                image: widget.products[0].productInfo!.image!,
                width: size.width,
                height: size.height,
                radius: 0,
              ),
            ),
          ),
          Expanded(
            child: CustomImage(
              image: widget.products[1].productInfo!.image!,
              width: size.width,
              height: size.height,
              radius: 0,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(20.0)),
              child: Stack(
                children: [
                  CustomImage(
                    image: widget.products[2].productInfo!.image!,
                    width: size.width,
                    height: size.height,
                    radius: 0,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: Center(
                        child: Text(
                          '+${length - 3}',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }
    return imageWidget;
  }
}
