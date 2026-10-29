import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:flutter/services.dart';
import 'package:sap/features/stockreport/presentation/stockReportScreen.dart';
import 'package:sap/features/stockreport/controller/stock_report_controller.dart';
import 'package:simple_barcode_scanner/barcode_appbar.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controller/bin_controller.dart';
import 'package:sap/features/inventory/presentation/inventoryscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sap/login/controller/login_controller.dart';
import 'package:sap/features/workorder/presentation/workorder_page.dart';
import 'package:sap/features/workorder/controller/workorder_controller.dart';
import 'package:sap/features/transfer_req/presentation/transferreq_page.dart';
import 'package:sap/features/transfer_req/controller/transferreq_controller.dart';

import 'package:sap/features/transfer/presentation/transfer_page.dart';
import 'package:sap/features/mfgorder/presentation/mfgorder_page.dart';
import 'package:sap/features/mfgorder/controller/mfgorder_controller.dart';
import 'package:sap/features/transfer/controller/transfer_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final StockReportController stockReportController =
  Get.put(StockReportController());
  final BinController binController = Get.put(BinController());
  LoginController lc = Get.put(LoginController(), permanent: true);
  WorkOrderController wc = Get.put(WorkOrderController());
  MfgOrderController mc = Get.put(MfgOrderController());
  WarehouseController TR = Get.put(WarehouseController());
  TransferController transferController = Get.put(TransferController());

  var qrResult = ''.obs;
  var warehouse = ''.obs;
  var binCode = ''.obs;
  var binName = ''.obs;
  var isLoading = false.obs;

  List<String> names = [
    'Open Work Order',
    'Open Mfg Order',
    'Stock Transfer Request',
   // 'Stock Transfer',
  ];

  bool _dialogShown = false;

  //ScannedData? scannedData;
 // String barcodeData = "";

  @override
  void initState() {
    super.initState();
    //_initializeScanner();
  }

 // Future<void> _initializeScanner() async {
  //  try {
   //    HoneywellScanner honeywellScanner = HoneywellScanner();
   //
   //    // Initialize PDN scanner
   //    ScannedData = await HoneywellMobilitySdk.createBarcodeReader(
   //      onRead: (event) {
   //        print(event.barcodeData);
   //        if (!mounted) return;
   //        qrResult.value = event.barcodeData;
   //        _extractWarehouseAndBin(event.barcodeData);
   //        ScannedData?.claim();
   //        _fetchBinName();
   //      },
   //      onFailure: (event) {
   //        print(event.timestamp);
   //        setState(() {
   //          // Handle failure here
   //        });
   //      },
   //      onTrigger: (event) {
   //        print(event.state);
   //      },
   //    );
   //
   //    _barcodeReader?.claim();
   //  } on PlatformException catch (e) {
   //    print('Failed to initialize PDN scanner: ${e.message}');
   //    // If initialization fails, fall back to camera scanner
   // //   await scanQR();
   //  }
 //}

    String _filterOnlyNumbers(String input) {
      final numericRegex = RegExp(r'\d+');
      return numericRegex.allMatches(input).map((m) => m.group(0)).join();
    }
    void _extractWarehouseAndBin(String qrcode) {
      List<String> lines = qrcode.split('\n');
      if (lines.length >= 2) {
        warehouse.value =
            _filterOnlyNumbers(lines[0].split(':').skip(1).join(':').trim());
        binCode.value = _filterOnlyNumbers(lines[1].split(':').skip(1).join(':').trim());
      } else {
        warehouse.value = 'Invalid';
        binCode.value = 'Invalid';
      }
    }


    Future<void> _fetchBinName() async {
      if (warehouse.value != 'Invalid' && binCode.value != 'Invalid') {
        isLoading.value = true;
        binName.value = await binController.fetchbinName(warehouse.value, binCode.value);
        isLoading.value = false;
      }
    }
  Future<void> scanQR() async {
    try {
      final qrcode = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Scan QR',
          centerTitle: false,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back_ios),
        ),
        isShowFlashIcon: true,
        delayMillis: 500,
        cameraFace: CameraFace.back,
        scanFormat: ScanFormat.ALL_FORMATS,
      );

      if (!mounted) return;

      qrResult.value = qrcode!;
      _extractWarehouseAndBin(qrcode);
      _fetchBinName();
    } on PlatformException catch (e) {
      print('Failed to initialize camera scanner: ${e.message}');
    }
  }






  Future<dynamic> _handleScan() async {
    try {
      // if (_barcodeReader != null) {
      //   await _barcodeReader!.softwareTrigger(true);
      // } else {
      //   await scanQR();
      // }
      await scanQR();

    } on PlatformException catch (e) {
      print('Failed to scan barcode: ${e.message}');
    }
  }

  // @override
  // void dispose() {
  //   _barcodeReader?.release();
  //   _barcodeReader?.close();
  //   super.dispose();
  // }
  void _navigateToPage(int index) async {
    switch (index) {
      case 0:
        Get.to(
          (() => WorkOrderPage(
            warehouse: warehouse.value,
            binCode: binCode.value,
            binName: binName.value,
          )),
        );
        await wc.getWorkOrder();
        break;
      case 1:
        Get.to((() => MfgOrderScreen()));
        mc.fetchMfgOrder();
        break;
      case 2: // here exported workorder details.
        // Get.to((() => TransferScreen()));
        // await TR.fetchtransfer();
        Get.to((() => TransferReq()));
        await transferController.fetchTransfer();
        break;
      // case 3: //transfer req changes to last icon.
      //   Get.to((() => TransferReq()));
      //   //  await TR.fetchtransfer();
      //   await transferController.fetchTransfer();
      //   //   await TR.fetchwarehouse();
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.random,
      appBar: AppBar(
        backgroundColor: AppColors.random,
        automaticallyImplyLeading: false,
        title: Container(
          color: Colors.white,
          height: 50,
          child: Image(
            fit: BoxFit.cover,
            image: AssetImage(
              'lib/ui/assets/client.png',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () async {
                bool shouldLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.white,
                      content: const Text(
                        "Are you sure you want to logout?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              color: AppColors.mainblue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: AppColors.mainblue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout == true) {
                  lc.logOutUser();
                }
              },
              child: Icon(
                Icons.logout,
                color: Colors.black87.withOpacity(0.9),
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.mainblue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              40,
            ),
            topLeft: Radius.circular(
              40,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.02,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Welcome manager!",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.18,
                      ),
                      Icon(
                        Icons.notifications,
                        color: AppColors.random,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: height * 0.03,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.all(4)),
                        // Center the image and button horizontally
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                               await _handleScan();
                              },

                              child: Container(
                                child: Icon(
                                  Icons.qr_code_scanner,
                                  color: AppColors.random.withOpacity(0.9),
                                  size: width * 0.2,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              'Click to Scan',
                              style: TextStyle(color: Colors.white),
                            ),
                           // Text('Scanned Data: $barcodeData'),

                          ],
                        ),
                        SizedBox(width: width * 0.1),

                        Container(
                          padding: EdgeInsets.all(4),
                          height: height * 0.15,
                          width: width * 0.45,
                          decoration: BoxDecoration(
                              color: AppColors.mainblue,
                              borderRadius: BorderRadius.circular(15),
                              border:
                              Border.all(color: Colors.white, width: 2)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Obx(() => Text(
                                'Whs code: ${warehouse.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  //  fontWeight: FontWeight.bold,
                                ),
                              )),
                              SizedBox(height: 10),
                              Obx(() => Text(
                                'Bin Location: ${binCode.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  //    fontWeight: FontWeight.bold,
                                ),
                              )),
                              SizedBox(height: 10),
                              Obx(() {
                                if (binController.isLoading.value) {
                                  return CircularProgressIndicator();
                                }

                                if (binController.errorMessage.isNotEmpty) {
                                  return Text(
                                    binController.errorMessage.value,
                                    style: TextStyle(color: Colors.red),
                                  );
                                }

                                return Container(
                                  child: RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Bin Name: ',
                                      style: TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: binController
                                              .binNameModel.value.BinName,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (warehouse.value.isNotEmpty &&
                                        binCode.value.isNotEmpty) {
                                      Get.to(() => InventoryScreen(
                                        warehouse: warehouse.value,
                                        binCode: binCode.value,
                                        binName: binName.value,
                                      ));
                                      await stockReportController
                                          .fetchStockData(
                                          warehouse.value, binCode.value);
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please Scan QR.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: height * 0.12,
                                    width: width * 0.4,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.random,
                                      border: Border.all(
                                        color: Colors.brown,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      'BIN / Warehouse Transfer',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),

                                SizedBox(width: width * 0.025),
                                GestureDetector(
                                  onTap: () async {
                                    if (warehouse.value.isNotEmpty &&
                                        binCode.value.isNotEmpty) {
                                      Get.to(() => StockReportScreen(
                                        warehouse: warehouse.value,
                                        binCode: binCode.value,
                                        binName: binName.value,
                                      ));
                                      await stockReportController
                                          .fetchStockData(
                                          warehouse.value, binCode.value);
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Scan QR Code.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: height * 0.12,
                                    padding: const EdgeInsets.all(18.0),
                                    width: width * 0.4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.random,
                                        border: Border.all(
                                            color: Colors.brown, width: 2)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text('Stock Report',
                                          style:
                                          TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ), ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.005),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.random,
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: 60,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) => SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              _navigateToPage(
                                  index); // Call _navigateToPage function with the index
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.random,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          names[index],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFFC09500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
               SizedBox(height: height * 0.01), // Add spacing before the image
               Align(
                 alignment: Alignment.bottomRight,
                 child: Text(
                   'EPE.V0.1',
                   style: TextStyle(color: Colors.white),
                 ),
               ),
               Align(
                 alignment: Alignment.bottomRight,
                 child: Image(
                   //  width: MediaQuery.of(context).size.width,
                   height: height * 0.05, // Adjust the height of the image
                   image: AssetImage('lib/ui/assets/my.png'),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
