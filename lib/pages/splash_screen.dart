import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gdgold/helper/get_service_key.dart';
import 'package:gdgold/helper/shared_preferences.dart';
import 'package:gdgold/pages/home_screen.dart';
import 'package:gdgold/pages/auth/login_screen.dart';
import 'package:gdgold/themes/constant_color.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var isAnimationCompleted = false;
  var isLogin = false;
  // isAnimationCompleted ? Center(child: const Text('GP Gold', style: TextStyle(color: ConstantColor.white, fontSize: 40, fontWeight: FontWeight.w600))) :

  getSharePreference() async {
    isLogin = await SharPreferences.getBoolean("isLogin") ?? false;
  }
  @override
  void initState() {
    // TODO: implement initState
    getSharePreference();
    getFirebaseServerToken();
    Future.delayed(const Duration(seconds: 4), () {

      Get.offAll(isLogin ? HomeScreen() : LoginScreen(), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 300));
    });
    super.initState();
  }

  getFirebaseServerToken() async {
    GetServerKey getServerKey = GetServerKey();
    String accessToken = await getServerKey.getServerKeyToken();
    print("Server accessToken ${accessToken}");
    SharPreferences.setString('FirebaseServerToken', accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.primary,
      body: Center(
        child: SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: ConstantColor.white,
              fontSize: 40.0,
              fontFamily: 'Montserrat',
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset('assets/icon/launcher_logo.png', fit: BoxFit.fill),),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('GP Gold', textStyle: const TextStyle(color: ConstantColor.white, fontSize: 40, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

// onTap: () async {
//
// Uint8List imageBytes = await rootBundle.load('assets/icon/launcher_logo.png').then((value) => value.buffer.asUint8List());
// final logoImage = pw.MemoryImage(imageBytes);
//
// final imageWidgets = await loadImageWidgets(controller.arrImages); // Assuming arrImages = List<String> of URLs
//
// print("imageWidgets ${imageWidgets.length}");
//
// controller.pdf.addPage(pw.MultiPage(
// pageFormat: PdfPageFormat.a4,
// crossAxisAlignment: pw.CrossAxisAlignment.center,
// build: (pw.Context context) {
// return [
// pw.Align(
// alignment: pw.Alignment.topRight,
// child: pw.Column(
// children: [
// pw.Text("Date: ${controller.orderDetail.orderDate ?? ''}"),
// pw.Text("Name: ${controller.orderDetail.client?.full_name ?? ''}"),
// ]
// )
// ),
// // pw.Container(
// //   height: 100,
// //   width: 100,
// //   padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
// //   decoration: const pw.BoxDecoration(
// //     borderRadius: pw.BorderRadius.all(pw.Radius.circular(50)),
// //   ),
// //   child: pw.Image(logoImage, fit: pw.BoxFit.fill),
// // ),
// pw.Text("G P Gold"),
// pw.Text("Surat"),
// pw.Text("Brand Name: Qutone"),
// pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 10.0)),
// pw.Table(
// border: pw.TableBorder.all(),
// columnWidths: const {
// 0: pw.FlexColumnWidth(1),
// 1: pw.FlexColumnWidth(1),
// },
// children: controller.arrRows,
// ),
// pw.Padding(padding: const pw.EdgeInsets.symmetric(vertical: 10.0)),
// ...imageWidgets
// ]; // Center
// })); // P
//
// final output = await getTemporaryDirectory();
// final file = File("${output.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.pdf");
//
// await file.writeAsBytes(await controller.pdf.save());
//
// final params = ShareParams(
//   text: 'Great picture',
//   files: [XFile(file.path)],
// );
//
// final result = await SharePlus.instance.share(params);
//
// if (result.status == ShareResultStatus.success) {
// print('Thank you for sharing the picture!');
// }
// },




// onTap: () async {
//
// Uint8List imageBytes = await rootBundle.load('assets/icon/launcher_logo.png').then((value) => value.buffer.asUint8List());
// final logoImage = pw.MemoryImage(imageBytes);
//
// final imageWidgets = await loadImageWidgets(controller.arrImages); // Assuming arrImages = List<String> of URLs
//
// print("imageWidgets ${imageWidgets.length}");
// controller.pdf.addPage(pw.MultiPage(
// pageFormat: PdfPageFormat.a4,
// crossAxisAlignment: pw.CrossAxisAlignment.center,
// build: (pw.Context context) {
// return [
// pw.Image(logoImage, height: 100, width: 100, fit: pw.BoxFit.fill),
// pw.Text("Date: ${controller.orderDetail.orderDate ?? ''}"),
// pw.Text("Name: ${controller.orderDetail.client?.full_name ?? ''}"),
// pw.SizedBox(height: 10),
// pw.Table(
// border: pw.TableBorder.all(),
// columnWidths: const {
// 0: pw.FlexColumnWidth(1),
// 1: pw.FlexColumnWidth(1),
// },
// children: controller.arrRows,
// ),
// ]; // Center
// })); // P
//
// // Separate Page for Images
// if (imageWidgets.isNotEmpty) {
// controller.pdf.addPage(
// pw.MultiPage(
// pageFormat: PdfPageFormat.a4,
// build: (pw.Context context) => [
// pw.Text("Images", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
// pw.SizedBox(height: 10),
// ...imageWidgets,
// ],
// ),
// );
// }
//
// print("controller.pdf ${controller.pdf.document.pdfPageList.pages.length}");
//
// final output = await getTemporaryDirectory();
// final file = File("${output.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.pdf");
//
// await file.writeAsBytes(await controller.pdf.save());
//
// final params = ShareParams(
//   text: 'Great picture',
//   files: [XFile(file.path)],
// );
//
// final result = await SharePlus.instance.share(params);
//
// if (result.status == ShareResultStatus.success) {
// print('Thank you for sharing the picture!');
// }
// },