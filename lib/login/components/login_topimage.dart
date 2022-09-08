import 'package:aplikasi_hrd/constant/const_login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';


class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: const [
            Spacer(),
            // Expanded(
            //   flex: 8,
              // child: SvgPicture.asset("assets/icons/login.svg"),
            // ),
            Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}