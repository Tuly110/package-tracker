import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../generated/colors.gen.dart';

@RoutePage()
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPage();
}

class _OtpPage extends State<OtpPage> {
   @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        SizedBox(height: 70.h,),
        Expanded(
          child: Container(   
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16), // Padding nếu cần
                      child: FaIcon(
                        FontAwesomeIcons.chevronLeft,
                        color: ColorName.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  Center(
                    child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        
                        TextSpan(
                          text: 'My',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorName.brandAccent,
                              ),
                        ),
                        TextSpan(
                          text: 'Tracker',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorName.brandBlue,
                              ),
                        ),
                      ],
                    ),
                  ),
                  )
                ],
              ),
              Gap(8),
              Text("Verification code", style: TextStyle(fontSize: 16.sp, color: ColorName.white)),
              Text("user@example.com", style: TextStyle(fontSize: 16.sp, color: Colors.white60)),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildCodeBox()),
              ),
              Gap(20),

              Padding(
                padding: EdgeInsets.only(top: 0),
                child: SizedBox( 
                  width: double.infinity,
                  child: TextButton(
                    onPressed: (){
                      
                    }, 
                    child: Text('Send(39)', style:TextStyle(color: ColorName.white, fontSize: 15.sp) ,),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      minimumSize: Size(100.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),  
                  ),
                )
              ),
            ],
          ),
        )
        ),
      ],
    );
  }

  Widget _buildCodeBox() {
    return SizedBox(
      width: 45.w,
      height: 50.h,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(color: ColorName.white, fontSize: 16.sp),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
    
    
  
}