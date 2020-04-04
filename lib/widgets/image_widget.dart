import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl, initials;
  final double radius;

  const ImageWidget(
      {Key key,
      @required this.imageUrl,
      @required this.initials,
      @required this.radius})
      : super(key: key);

  Future<void> _showImage(BuildContext context, ImageProvider provider) {}

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return CircleAvatar(
        radius: radius ?? 0.0,
        backgroundColor: Colors.blue,
        child: Text(
          initials ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: radius,
          ),
        ),
      );
    } else {
      ImageProvider provider = CachedNetworkImageProvider(imageUrl);
      if (radius == null) {
        return InkWell(
          child: Image(
            image: provider,
            width: 250.0,
          ),
          onTap: () {
            _showImage(context, provider);
          },
        );
      } else {
        return InkWell(
          child: CircleAvatar(
            radius: radius,
            backgroundImage: provider,
          ),
          onTap: () {
            _showImage(context, provider);
          },
        );
      }
    }
  }
}
