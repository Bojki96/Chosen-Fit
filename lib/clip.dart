import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width * 0.15, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ButtonClipper extends CustomClipper<Path> {
  String nazivGumba;
  ButtonClipper({@required this.nazivGumba});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (nazivGumba == 'Add') {
      // path.moveTo(0, 0);
      // path.lineTo(size.width * 0.35, 0);
      // path.lineTo(size.width, size.height * 0.75);
      // path.lineTo(size.width, size.height);
      // path.lineTo(0, size.height);
      path
        ..moveTo(0, 0)
        ..arcToPoint(Offset(size.width, size.height),
            radius: Radius.circular(110))
        ..lineTo(0, size.height);
    } else if (nazivGumba == 'Save') {
      path
        ..moveTo(0, size.height)
        ..arcToPoint(Offset(size.width, 0), radius: Radius.circular(110))
        ..lineTo(size.width, size.height);

      // path.moveTo(size.width, 0);
      // path.lineTo(size.width * (1 - 0.35), 0);
      // path.lineTo(0, size.height * 0.75);
      // path.lineTo(0, size.height);
      // path.lineTo(size.width, size.height);
    } else if (nazivGumba == 'Back') {
      path.moveTo(size.width, 0);
      path.lineTo(size.width * 0.5, 0);
      path.lineTo(0, size.height * 0.5);
      path.lineTo(size.width * 0.5, size.height);
      path.lineTo(size.width, size.height);
    }
    // else if (nazivGumba == 'Save') {
    //   path.moveTo(size.width, 0);
    //   path.lineTo(size.width * 0.5, 0);
    //   path.lineTo(0, size.height);
    //   path.lineTo(size.width, size.height);
    // }
    else if (nazivGumba == 'Log in') {
      path.moveTo(size.width, 0);
      path.lineTo(size.width * 0.5, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (nazivGumba == 'Sign up') {
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.5, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ClientClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(size.width * 0.15, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    //path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DailyDatesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width, 0);
    // path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.2, 0);
    // path.lineTo(size.width * 0.5, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SubtitleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height);
    // path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    // path.lineTo(size.width * 0.5, 0);

    path.close();
    return path;
  }

  @override
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
