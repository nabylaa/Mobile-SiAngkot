import 'package:flutter/material.dart';
import 'package:si_angkot/core/constants.dart';
import 'package:si_angkot/gen/assets.gen.dart';
import 'package:si_angkot/gen/colors.gen.dart';

class GradientHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imageUrl;
  final Function()? onSignOut;

  GradientHeader({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MyColors.primaryColor, MyColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, color: Colors.grey[400], size: 30),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Add your action here
                    if (onSignOut != null) {
                      onSignOut!();
                    } else {
                      // Default action if onSignOut is not provided
                      print("Sign out action not defined.");
                    }
                  },
                  child: MyAssets.svg.signOut.svg(
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(
                      MyColors.colorWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Constant.WELCOME} $name!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
