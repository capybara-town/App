import 'package:capybara/src/model/member.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../config/routes.dart';
import '../theme/color_theme.dart';
import '../theme/font_theme.dart';
import 'bounce_grey.dart';

class UserListItem extends HookWidget {
  const UserListItem({Key? key, required this.member, required this.index}) : super(key: key);

  final Member member;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BounceGrey(
      onTap: () {
        context.push(Routes.PROFILE, extra: {
          'uid': member.uid,
          'push': true
        });
      },
      paddingHorizontal: 20,
      paddingVertical: 10,
      activeColor: ColorTheme.greyThickest,
      child: Row(
        children: [
          ExtendedImage.network(
            member.profileImage,
            width: 50,
            height: 50,
            cache: true,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return Container(
                    width: 50,
                    height: 50,
                    color: ColorTheme.greyThickest,
                  );
                case LoadState.completed:
                  return ExtendedRawImage(
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    image: state.extendedImageInfo?.image,
                  );
                case LoadState.failed:
                  return Container(
                    width: 50,
                    height: 50,
                    color: ColorTheme.greyThickest,
                  );
              }
            },
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.nickname, style: FontTheme.subtitle1WhiteBold,),
              const SizedBox(height: 3),
              Text("${member.role} @${member.belong}", style: FontTheme.subtitle1GreyLightest,)
            ],
          ),
        ],
      ),
    );
  }
}
