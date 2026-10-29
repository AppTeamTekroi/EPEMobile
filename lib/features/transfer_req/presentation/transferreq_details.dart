import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:sap/ui/richtext.dart';
import 'package:sap/features/workorder/controller/workorder_controller.dart';
import 'package:sap/features/workorder/controller/post_workorder_controller.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sap/features/homeScreen/presentation/homeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sap/features/transfer_req/controller/transferreq_controller.dart';
import 'package:sap/ui/CommonWidget.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:flutter/services.dart';
import '../controller/post_transferreq.dart';

class TransferDetails extends StatefulWidget {
  final int docEntry;
  final String itemcode;
  final int docnum;
  final dynamic startDate;
  final String prod;
  final double po;
  final double co;
  final double op;
   final String binname;
   final String bincode;
  const TransferDetails({
    required this.docEntry,
    required this.itemcode,
    required this.co,
    required this.docnum,
    required this.op,
    required this.po,
    required this.prod,
    required this.startDate,
    required this.bincode,
    required this.binname,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferDetails> createState() => _TransferDetailsState();
}

class _TransferDetailsState extends State<TransferDetails> {
  final WorkOrderController wc = Get.put(WorkOrderController());
  final PostWorkOrderController pc = Get.put(PostWorkOrderController());
  final WarehouseController wh = Get.put(WarehouseController());
  final PostTransferReq tc = Get.put(PostTransferReq());
  final List<String> verificationMessages = []; // List to store verification messages for each index

  List<Map<String, dynamic>> items = []; // Ensure this list is populated correctly
  List<String> quantities = [];
  List<TextEditingController> controllers = [];
  String dropdownValue = '';
  bool _showDropdown = false;
  var _selectedItem;
  var binCode = ''.obs;

  var toWarehouse = "";
  var qrResult = ''.obs;
  var warehouse = ''.obs;
  List<Map<String, String>> selectedItems = [];
  String? firstScannedWarehouse;
  String _verificationMessage = '';

  Future<void> scanQR(int index, dynamic details) async {
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


      print(qrcode);
      if (!mounted) return;
    // if(qrcode != null){
      qrResult.value = qrcode!;
      List<String> lines = qrcode.split('\n');
      if (lines.length >= 2) {
        warehouse.value = filterOnlyNumbers(lines[0].split(':').skip(1).join(':').trim());
        binCode.value = lines[1].split(':').skip(1).join(':').trim();

        // Verify the bin for the scanned item using the workOrder's itemcode
        final result = await wh.fetchBinVerify(int.parse(binCode.value), int.parse(warehouse.value), details.itemCode);

        result.fold(
              (failure) {
            setState(() {
              verificationMessages[index] = "Verification failed: ${failure.message}";
            });
            Fluttertoast.showToast(
              msg: verificationMessages[index],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
              (result) {
            setState(() {
              if (result.isNotEmpty) {
                var firstItem = result[0];
                bool matchFound = false;
                List<String> binDetails = [];

                // Check if binCode.value matches the AbsEntry of the first item
                if (firstItem.absEntry == int.parse(binCode.value)) {
                  controllers[index].text = '${warehouse.value}, ${binCode.value}';
                  verificationMessages[index] = "Bin verification successful: ${firstItem.binName}";
                  Fluttertoast.showToast(
                    msg: verificationMessages[index],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  // Check the remaining items in the result list
                  for (int i = 1; i < result.length; i++) {
                    var currentItem = result[i];
                    if (currentItem.absEntry == int.parse(binCode.value)) {
                      matchFound = true;
                      verificationMessages[index] = "Do you want to override the system bin: ${currentItem.binName}?";
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Override Bin Confirmation"),
                            content: Text(verificationMessages[index]),
                            actions: <Widget>[
                              TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Fill controller with result item[0]
                                  controllers[index].text = '${warehouse.value}, ${firstItem.absEntry}'; // Adjust as per your requirement
                                },
                              ),
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Fill controller with scanned warehouse and bin
                                  controllers[index].text = '${warehouse.value}, ${binCode.value}';
                                },
                              ),
                            ],
                          );
                        },
                      );
                      break; // Exit the loop once a match is found
                    } else {
                      // Clear controller text for non-matching bins
                      controllers[index].clear();
                      // Collect details of all bins that don't match
                      binDetails.add("Bin Name: ${currentItem.binName}, On Hand Quantity: ${currentItem.onHandQty}");
                    }
                  }

                  if (!matchFound) {
                    // Bin code does not match any absEntry, show details of all bins
                    verificationMessages[index] = "Bin code does not match any absEntry.\n\n";
                    verificationMessages[index] += binDetails.join("\n");
                    Fluttertoast.showToast(
                      msg: verificationMessages[index],
                      toastLength: Toast.LENGTH_LONG, // Use LONG to display multiline message
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }
              } else {
                verificationMessages[index] = "Verification result list is empty.";
                Fluttertoast.showToast(
                  msg: verificationMessages[index],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            });
          },
        );
      } else {
        setState(() {
          warehouse.value = 'Invalid';
          binCode.value = 'Invalid';
        });
      }
    } on PlatformException {
      setState(() {
        qrResult.value = 'Fail to read';
        warehouse.value = 'Not found';
        binCode.value = 'Not found';
      });
    }
  }

  String filterOnlyNumbers(String input) {
    final numericRegex = RegExp(r'\d+');
    return numericRegex.allMatches(input).map((m) => m.group(0)).join();
  }


  void _checkFieldsAndProceed() async {
    bool allFieldsFilled = true;
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        allFieldsFilled = false;
        break;
      }
    }

    if (!allFieldsFilled) {
      Fluttertoast.showToast(
        msg: "Please fill all fields before proceeding.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    List<Map<String, dynamic>> selectedItems = [];
    wh.transferReqDetailsList.asMap().forEach((index, wh) {
      selectedItems.add({
        'itemCode': wh.itemCode ?? '',
        'quantity': wh.quantity ?? '', // Use the updated quantity
        'frombincode': binCode.value ?? '',
      });
    });
    tc.data = List<Map<String, dynamic>>.from(selectedItems);
    try {
      tc.proddocEntry = widget.docEntry.toString();
      final response = await tc.stockTransfer();
      var decodedValue = response;
      if (decodedValue["Status"] == "success") {
        QuickAlert.show(
          context: context,
          title: 'Success',
          type: QuickAlertType.success,
          text: 'Inventory transfer successful',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Get.to(() => HomeScreen());
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          title: 'Failed',
          type: QuickAlertType.error,
          text: '$decodedValue',
        );
      }
    } catch (e) {
      QuickAlert.show(
        context: context,
        title: 'Failed',
        type: QuickAlertType.error,
        text: 'Failed inventory transfer. Please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
  //  print('binqty : $binCode');
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Navigate back to the previous screen
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        backgroundColor: AppColors.mainblue,
        title: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Inventory Transfer - ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: '${widget.docnum}',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonRichText(
                        label: 'WO: ',
                        value: '${widget.docnum}',
                      ),
                      SizedBox(width: width*0.05),

                      CommonRichText(
                        label: 'OA:',
                        value: '${widget.docEntry}',
                      ),
                      SizedBox(width: width*0.05),

                      CommonRichText(
                        label: 'Date: ',
                        value:
                        '${widget.startDate.year}-${widget.startDate.month.toString().padLeft(2, '0')}-${widget.startDate.day.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                  Text(
                    'Components',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (wh.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (wh.errorMessage.isNotEmpty) {
                  return Center(
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('lib/ui/assets/undraw_Empty_re_opql.png'),
                    ),
                  );
                } else {
                  // Initialize quantities if not already initialized
                  if (quantities.isEmpty) {
                    quantities = List.filled(wh.transferReqDetailsList.length, '');
                  }

                  return ListView.builder(
                    itemCount: wh.transferReqDetailsList.length,
                    itemBuilder: (context, index) {
                      final details = wh.transferReqDetailsList[index];
                      tc.toWarehouse = details.toWhsCode    ;
                      tc.toBinCode = (widget.bincode).toString();
                      tc.fromWarehouse = warehouse.value;
                      // Initialize controller for each TextField if not already initialized
                      if (controllers.length <= index) {
                        controllers.add(TextEditingController());
                        verificationMessages.add(""); // Initialize message for each index

                      }

                      void updateQuantity(String value) {
                        setState(() {
                          quantities[index] = value.trim(); // Update quantity in the list
                        });
                      }

                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.fiber_manual_record,
                                  color: Color(0xFFC09500),
                                  size: 10,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${details.itemCode}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.mainblue,
                                      fontFamily: 'RobotoMono',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(children: [
                            CommonRichText(
                              label: 'fromwhs:  ',
                              value: '${details.fromWhsCode}',
                            ),
                            Spacer(),
                            CommonRichText(
                              label: 'Towhs:  ',
                              value: '${details.toWhsCode}',
                            ),
                            ],),
                            CommonRichText(
                              label: 'BinName:  ',
                              value: '${details.binName}',
                            ),
                            CommonRichText(
                              label: ' Quantity:  ',
                              value: '${details.quantity}',
                            ),
                            Row(

                              children: [
                                CommonRichText(
                                  label: 'BINQTY:',
                                  value: '${details.binQty}',
                                ),



                                Spacer(),
                                Expanded(
                                  child: Container(
                                    height: height * 0.03,
                                    child: TextField(
                                      controller: controllers[index],
                                      onChanged: updateQuantity,
                                      // Call updateQuantity when text changes
                                    //  keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        hintText: 'click to scan',
                                        hintStyle: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                ),

                                  Container(
                                  height: height * 0.03,
                                 child:
                                IconButton(
                                  icon: Icon(Icons.qr_code_scanner,size: 14,),
                                   onPressed: () => scanQR(index,details),
                                ),),
                              ],
                            ),
                            if (verificationMessages[index].isNotEmpty)
                              Text(
                                verificationMessages[index],
                                style: TextStyle(
                                  color: verificationMessages[index].contains('successful') ? Colors.green : Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            Divider(color: Colors.red),

                          ],
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            SizedBox(width: width * 0.01),
            ElevatedButton(
              style: CommonWidget.commonbuttonStyle,
              onPressed: _checkFieldsAndProceed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                        () => tc.loadingBar.value
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                        : Text(
                      "Post Inv Transfer",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: tc.loadingBar.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
