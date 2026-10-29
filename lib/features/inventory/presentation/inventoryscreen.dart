import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:flutter/services.dart';

import 'package:sap/features/stockreport/controller/stock_report_controller.dart';
import 'package:sap/features/inventory/controller/inventory_controller.dart';
import 'package:sap/features/homeScreen/presentation/homeScreen.dart';
import '../../homeScreen/controller/bin_controller.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:sap/ui/CommonWidget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
enum select {scan, manually,view}

class InventoryScreen extends StatefulWidget {

  final String warehouse;
  final String binCode;
  final String binName;

  InventoryScreen({
    required this.warehouse,
    required this.binCode,    required this.binName,
  });
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int? selectedIndex;
  String selectedItemCode = '';
  dynamic selectedQuantity;
  var qrResult = ''.obs;
  var warehouse1 = ''.obs;
  var binCode1 = ''.obs;
  var binName1 = ''.obs;
  var isLoading = false.obs;
  bool checkBoxValue1 = false;
  int? selectedOption;
  select? _selectedType;

  List<int> selectedIndices = [];
  List<Map<String, String>> selectedItems = [];
  final InventoryController ic = Get.put(InventoryController());
  final StockReportController controller = Get.put(StockReportController());
  TextEditingController toWarehouseController = TextEditingController();
  TextEditingController toBinCodeController = TextEditingController();

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
      List<String> lines = qrcode.split('\n');
      if (lines.length >= 2) {
        String warehouse = filterOnlyNumbers(lines[0].split(':').skip(1).join(':').trim());
        String binCode = lines[1].split(':').skip(1).join(':').trim();
        warehouse1.value = warehouse;
        binCode1.value = binCode;
        updateTextFieldsFromScan(warehouse, binCode);
      }else {
        Fluttertoast.showToast(
          msg: 'Invalid QR Code format',
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on PlatformException {
      Fluttertoast.showToast(
        msg: 'Failed to read QR Code',
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  String filterOnlyNumbers(String input) {
    final numericRegex = RegExp(r'\d+');
    return numericRegex.allMatches(input).map((m) => m.group(0)).join();
  }


  @override
  void dispose() {
    toWarehouseController.dispose();
    toBinCodeController.dispose();
    super.dispose();

  }
  void clearTextFields() {

    toWarehouseController.clear();
    toBinCodeController.clear();
  }
  void updateTextFieldsFromScan(String warehouse1, String binCode1) {
    toWarehouseController.text = warehouse1;
    toBinCodeController.text = binCode1;
    ic.toBinCode = binCode1;
    ic.toWarehouse = warehouse1;
    print("Warehouse: $warehouse1");
    print("Bin Code: $binCode1");
  }



  Widget _showDropDownModal(BuildContext context) {
    ic.toBinCode = binCode1.value;
    ic.fromBinCode = widget.binCode;
    ic.fromWarehouse = widget.warehouse;
    ic.toWarehouse = warehouse1.value;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text('From Ware House'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: TextField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            onChanged: (value) {
                              ic.fromWarehouse = value.trim();
                            },
                            controller: TextEditingController(text: widget.warehouse),
                            readOnly: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text('BinCode'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            onChanged: (value) {
                              ic.fromBinCode = value.trim();
                            },
                            controller: TextEditingController(text: widget.binCode),
                            readOnly: true,

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.blue,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(' To Ware House'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: TextField(
                            controller: toWarehouseController,
                            enabled: (_selectedType == select.manually), // Enable only if manually selected

                            decoration:InputDecoration.collapsed(hintText: ' enter warehouse',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),


                            ),
                            onChanged: (value) {
                              setState(() {
                                // Update the value of warehouse1 when the text field changes
                                warehouse1.value = value;
                              });
                            },

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(' To BinCode'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: TextField(
                            controller: toBinCodeController,
                            enabled: (_selectedType == select.manually), // Enable only if manually selected

                            decoration: InputDecoration.collapsed(
                              hintText: '  enter bin',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)), // Adjust opacity level as needed
                            ),
                            onChanged: (value) {
                              setState(() {
                                binCode1.value = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),


        Container(
          child: Text(
            "$selectedItems",
            style: TextStyle(color: Colors.purple),
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            if (ic.toBinCode.trim().isEmpty) {
              Fluttertoast.showToast(
                msg: 'Enter tobin details',
                gravity: ToastGravity.CENTER_LEFT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              return;
            }
            if (ic.toWarehouse.trim().isEmpty) {
              Fluttertoast.showToast(
                msg: 'Enter towarehouse details',
                gravity: ToastGravity.CENTER_LEFT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              return;
            }

            if (ic.fromBinCode == ic.toBinCode) {
              Fluttertoast.showToast(
                msg: 'bin location not to be same',
                gravity: ToastGravity.CENTER_LEFT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              return;
            }
            // Check if selectedItems is null or empty
            if (selectedItems == null || selectedItems.isEmpty) {
              Fluttertoast.showToast(
                msg: 'Please add items to transfer',
                gravity: ToastGravity.CENTER_LEFT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              return;
            }

// Check if any selected item is missing quantity
            if (selectedItems.any((item) => item['quantity'] == null || item['quantity']!.isEmpty)) {
              Fluttertoast.showToast(
                msg: 'Please add quantity for all selected items',
                gravity: ToastGravity.CENTER_LEFT,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );

              return;
            }


            else {
              try {
                ic.loadingBar.value = true;

                final response = await ic.stockTransfer();
                var decodedValue = response;
                print(decodedValue);
                if (decodedValue["Status"] == "success") {
                  QuickAlert.show(
                    context: context,
                    title: 'Success',
                    type: QuickAlertType.success,
                    text: 'Stock transfer successful',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                      Get.to(() =>  HomeScreen());
                    },
                  );
                  ic.loadingBar.value = false;

                } else {
                  QuickAlert.show(
                    context: context,
                    title: 'Failed',
                    type: QuickAlertType.error,
                    text: '$decodedValue',
                  );
                }
              } catch (e) {
                print('Server error: $e');
                QuickAlert.show(
                  context: context,
                  title: 'Failed',
                  type: QuickAlertType.error,
                  text: 'Failed to transfer stocks. Please try again later.',
                );

              }finally {
                // Set loading back to false after the API call is completed
                ic.loadingBar.value = false;
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save, color: Colors.white),
                SizedBox(width: 8),
                Obx(() {
                  return ic.loadingBar.value
                      ? CircularProgressIndicator()
                      : Text(
                    "Transfer Stocks",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: ic.newTransfer.value
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String _getSaleTypeText(select type) {
    switch (type) {
      case select.scan:
        return 'Scan QR';
      case select.manually:
        return 'Manually ';


      default:
        return '';
    }
  }
  @override
  Widget build(BuildContext context) {
    final StockReportController controller = Get.put(StockReportController());
    final BinController binController = Get.put(BinController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainblue,
        leading: GestureDetector(
          onTap: () {
            // Navigate back to the previous screen
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        title: Row(
          children: [

            SizedBox(width: MediaQuery.of(context).size.width*0.2),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8), // Adjust horizontal padding
                child: Card(
                  elevation: 19,

                  child:

                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.mainblue, // Set the background color of the container

                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),

                    ),
                    child: DropdownButtonFormField<select>(
                        value: _selectedType,
                        onChanged: (selectedType) async {
                          setState(() {
                            _selectedType = selectedType;
                          });
                          if (_selectedType == select.scan) {
                            await scanQR();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return _showDropDownModal(context);
                              },
                            ).whenComplete(() => clearTextFields());
                          } else if (_selectedType == select.manually) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return _showDropDownModal(context);
                              },
                            ).whenComplete(() => clearTextFields());
                          }
                        },
                        items: select.values.map((type) {
                          return DropdownMenuItem<select>(
                            value: type,
                            child: Text(_getSaleTypeText(type)),
                          );
                        }).toList(),
                        isDense: true,
                        hint: Text('Select transfer type',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),), // Hint text
                        // Reduce vertical padding
                        style: TextStyle(
                          color: Colors.white,
                          // Set the text color of the dropdown
                        ),

                        iconEnabledColor: Colors.white , // Set the dropdown icon color
                        dropdownColor: AppColors.mainblue // Set the dropdown background color
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),

      ),

      body: Column(
        children: [
          Card(
            elevation: 4,

            child:
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WareHouse:${widget.warehouse}'),
                      Text('BinCode:${widget.binCode}'),
                    ],
                  ),
                  SizedBox(width: 15,),
                  Flexible(
                    child: Text(
                      'Bin Name: ${binController.binNameModel.value.BinName}',
                      maxLines: 10, // Set max lines to 3
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child:
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text('Error: ${controller.errorMessage.value}'),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.stockData.length,
                  itemBuilder: (context, index) {
                    final stock = controller
                        .stockData[index]; // Access individual StockReportModel
                    return Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: selectedItems
                                        .any((item) =>
                                    item['itemCode'] == stock.itemCode),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selectedIndices.add(index);
                                          selectedItems.add({
                                            'itemCode': stock.itemCode ?? '',
                                            'quantity': '',
                                            // Assuming rate is another field you're using
                                          });
                                        } else {
                                          selectedIndices.remove(index);
                                          selectedItems.removeWhere(
                                                  (item) =>
                                              item['itemCode'] ==
                                                  stock.itemCode);
                                          final itemIndex = selectedItems.indexWhere((item) => item['itemCode'] == stock.itemCode);
                                        }
                                        print('Selected Items: $selectedItems');
                                        ic.data = selectedItems;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      stock.itemCode,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.mainblue,
                                          fontFamily: 'RobotoMono',
                                          fontWeight: FontWeight.w500
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      stock.itemName,style: CommonWidget.commontextstyle,
                                      // Access itemName from individual StockReportModel
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(

                                    child: Row(children: [


                                      Text(
                                        'Quantity: ',style: CommonWidget.commonboldTextStyle,
                                        // Access onHandQty from individual StockReportModel
                                      ),

                                      Text(stock.onHandQty,style: CommonWidget.commontextstyle,),
                                    ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter Transfer Qty',
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          final itemIndex = selectedItems.indexWhere((item) => item['itemCode'] == stock.itemCode);
                                          if (selectedIndices.contains(index)) { // Checkbox is checked
                                            if (itemIndex != -1) {
                                              selectedItems[itemIndex]['quantity'] = value.trim();
                                              ic.data = selectedItems;
                                            } else {
                                              // This should not happen, but just in case
                                              Fluttertoast.showToast(
                                                msg: "Error: Checkbox is checked but item not found in selectedItems.",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          } else { // Checkbox is not checked
                                            // Show toast message indicating to check the checkbox first
                                            Fluttertoast.showToast(
                                              msg: "Please select an item before adding quantity.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Clear the value entered in the TextField
                                            // Optionally, you can also reset the quantity in the selectedItems list
                                            // based on your app's logic
                                          }
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      readOnly: !selectedIndices.contains(index), // Enable TextField if checkbox is checked
                                    ),
                                  ),

                                ],),
                            ],
                          ),

                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),

    );
  }
}

