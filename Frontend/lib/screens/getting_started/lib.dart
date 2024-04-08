import 'package:flutter/material.dart';

Widget buildImage(String assetName, BuildContext context) {
  return Image.asset(
    'lib/assets/$assetName',
    fit: BoxFit.fitHeight,
    height: MediaQuery.sizeOf(context).height > 750 ? 500 : 350,
  );
}

Widget showcaseBodyWidget(String assetName, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [buildImage(assetName, context)],
  );
}
