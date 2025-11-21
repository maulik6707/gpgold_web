import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../l10n/app_localizations.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AboutUsScreen> {

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.primary,
      appBar: AppBar(
        title: Text("About Us", style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center), centerTitle: true, backgroundColor: ConstantColor.gradientTopColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset('assets/icon/launcher_logo.png', fit: BoxFit.fill),),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text('GP Gold', style: TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text('Brand Name: Qutone', style: TextStyle(color: ConstantColor.white, fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text('GST No: 24ABCFG8893L1ZS', style: TextStyle(color: ConstantColor.white, fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 0.0),
              child: Text('${AppLocalizations.of(context)!.address}', style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0.0),
              child: Text('B/28, Lambe Hanuman Rd, Ramkrishna Society, Shivnagar Society, Varachha, Surat, Gujarat 395006.', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 0.0),
              child: Text('${AppLocalizations.of(context)!.mobileNo}', style: const TextStyle(color: ConstantColor.white, fontSize: 20, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 0.0),
              child: Text('+919824766077', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0.0),
              child: Text('+919727120007', style: TextStyle(color: ConstantColor.white, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
            ),
          ],
        ),
      ),
    );

  }
}
