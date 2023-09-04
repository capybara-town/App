import 'package:capybara/src/model/festival/festival_meet.dart';
import 'package:capybara/src/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_password_generator/random_password_generator.dart';

import '../../component/bounce.dart';
import '../../component/capybara_button.dart';
import '../../theme/color_theme.dart';
import '../../theme/font_theme.dart';

class MeetAddScreen extends HookWidget {
  const MeetAddScreen({Key? key, required this.festivalPk, required this.festivalTitle, required this.festivalStart}) : super(key: key);

  final String festivalPk;
  final String festivalTitle;
  final DateTime festivalStart;

  @override
  Widget build(BuildContext context) {

    final password = RandomPasswordGenerator();
    final db = FirebaseFirestore.instance;

    final titleController = useState(TextEditingController());
    final contentController = useState(TextEditingController());
    final memberController = useState(TextEditingController());
    final feeController = useState(TextEditingController());
    final locationController = useState(TextEditingController());

    final startDate = useState(festivalStart);
    final endDate = useState(festivalStart);

    final UserProvider userProvider = Provider.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColorTheme.blackPoint,
        appBar: AppBar(
          backgroundColor: ColorTheme.blackPoint,
          scrolledUnderElevation: 0,
          leading: Bounce(
              onTap: () {
                context.pop();
              },
              scale: 0.8,
              child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  child: SvgPicture.asset("asset/image/chevron-left.svg")
              )
          ),
        ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView(
                  children: [
                    const Text("모임 만들기", style: FontTheme.headline1),
                    const SizedBox(height: 10),
                    Text(festivalTitle, style: FontTheme.subtitle1GreyLightest),
                    const SizedBox(height: 40),
                    titleTextField("모임 제목", titleController.value, TextInputType.text),
                    const SizedBox(height: 20),
                    titleTextField("내용", contentController.value, TextInputType.multiline),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Flexible(
                          child: titleTextField("멤버 수", memberController.value, TextInputType.number),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: titleTextField("참가비", feeController.value, TextInputType.number),
                        )
                      ]
                    ),
                    const SizedBox(height: 20),
                    titleTextField("모일 곳", locationController.value, TextInputType.text),
                    const SizedBox(height: 20),
                    const Text("모이는 시간", style: FontTheme.textField_title),
                    const SizedBox(height: 10),
                    Bounce(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          dateFormat: 'MM월 dd일 H시:m분',
                          initialDateTime: startDate.value,
                          minDateTime: DateTime.now(),
                          maxDateTime: DateTime(2100),
                          onMonthChangeStartWithFirstDate: true,
                          onConfirm: (dateTime, List<int> index) {
                            startDate.value = dateTime;
                          },
                          locale: DateTimePickerLocale.ko,
                          pickerTheme: const DateTimePickerTheme(
                            backgroundColor: ColorTheme.greyThickest,
                            cancelTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorTheme.greyLight),
                            confirmTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorTheme.capybaraPoint),
                            itemTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: ColorTheme.white)
                          )
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorTheme.greyThickest
                        ),
                        child: Text(startDate.value.toString(), style: FontTheme.textField)
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("헤어지는 시간", style: FontTheme.textField_title),
                    const SizedBox(height: 10),
                    Bounce(
                      onTap: () {
                        DatePicker.showDatePicker(
                            context,
                            dateFormat: 'MM월 dd일 H시:m분',
                            initialDateTime: endDate.value,
                            minDateTime: DateTime.now(),
                            maxDateTime: DateTime(2100),
                            onMonthChangeStartWithFirstDate: true,
                            onConfirm: (dateTime, List<int> index) {
                              endDate.value = dateTime;
                            },
                            locale: DateTimePickerLocale.ko,
                            pickerTheme: const DateTimePickerTheme(
                                backgroundColor: ColorTheme.greyThickest,
                                cancelTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorTheme.greyLight),
                                confirmTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: ColorTheme.capybaraPoint),
                                itemTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: ColorTheme.white)
                            )
                        );
                      },
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: ColorTheme.greyThickest
                          ),
                          child: Text(endDate.value.toString(), style: FontTheme.textField)
                      ),
                    ),
                    const SizedBox(height: 120)
                  ]
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorTheme.blackPoint.withOpacity(0),
                                ColorTheme.blackPoint.withOpacity(1),
                                ColorTheme.blackPoint.withOpacity(1),
                                ColorTheme.blackPoint.withOpacity(1),
                                ColorTheme.blackPoint.withOpacity(1),
                              ]
                          )
                      )
                  )
              ),
              Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: CapybaraButton(
                          onTap: () {
                            if (
                              titleController.value.text != "" &&
                              contentController.value.text != "" &&
                              memberController.value.text != "" &&
                              locationController.value.text != ""
                            ) {
                              var newId = password.randomPassword(
                                  letters: true,
                                  numbers: true,
                                  passwordLength: 20,
                                  specialChar: true,
                                  uppercase: true
                              );
                              db.collection("meets").doc(newId).set(
                                  FestivalMeet(
                                      id: newId,
                                      title: titleController.value.text,
                                      description: contentController.value.text,
                                      startDate: DateTime(
                                          startDate.value.year,
                                          startDate.value.month,
                                          startDate.value.day,
                                          startDate.value.hour,
                                          startDate.value.minute,
                                          startDate.value.second
                                      ),
                                      endDate: DateTime(
                                          endDate.value.year,
                                          endDate.value.month,
                                          endDate.value.day,
                                          endDate.value.hour,
                                          endDate.value.minute,
                                          endDate.value.second
                                      ),
                                      members: [userProvider.me.id.toString()],
                                      limit: int.parse(memberController.value.text),
                                      location: locationController.value.text,
                                      fee: feeController.value.text,
                                      manager: userProvider.me.id.toString()
                                  ).toJson()
                              ).then((value) => {
                                db.collection("festivals").doc(festivalPk).update({
                                  'meets': FieldValue.arrayUnion([newId])
                                })
                              });
                            }
                          },
                          width: double.infinity,
                          text: "등록하기"
                      )
                  )
              )
            ],
          )
        ),
      ),
    );
  }

  Widget titleTextField(String title, TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: FontTheme.textField_title,),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorTheme.greyThickest
          ),
          child: TextField(
            keyboardType: keyboardType,
            controller: controller,
            maxLines: null,
            style: FontTheme.textField,
            cursorColor: ColorTheme.white,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )
      ]
    );
  }
}
