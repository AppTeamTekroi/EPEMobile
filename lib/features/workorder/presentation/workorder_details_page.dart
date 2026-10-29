import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:sap/ui/richtext.dart';
import '../controller/workorder_controller.dart';
import '../controller/post_workorder_controller.dart';
import 'dart:convert';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sap/features/homeScreen/presentation/homeScreen.dart';
import '../controller/post_receipt_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sap/features/transfer_req/controller/transferreq_controller.dart';
import 'package:sap/ui/CommonWidget.dart';
class WorkorderDetails extends StatefulWidget {
  final int docEntry;
  final String itemcode;
  final int docnum;
  final dynamic startDate;
  final String prod;
  final double po;
  final double co;
  final double op;
  final Color color;
final String bincode;
final String binname;
  const WorkorderDetails({
    required this.docEntry,
    required this.itemcode,
    required this.co,
    required this.docnum,
    required this.op,
    required this.po,
    required this.prod,
    required this.startDate,
    required this.color,
    required this.bincode,
    required this.binname,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkorderDetails> createState() => _WorkorderDetailsState();
}

class _WorkorderDetailsState extends State<WorkorderDetails> {
  final WorkOrderController wc = Get.put(WorkOrderController());
  final PostWorkOrderController pc = Get.put(PostWorkOrderController());
  final PostReceiptController pr = Get.put(PostReceiptController());
final WarehouseController wh = Get.put(WarehouseController());
  final TextEditingController qc = TextEditingController();

  List<Map<String, dynamic>> items = []; // Ensure this list is populated correctly
  List<String> quantities = [];
  List<TextEditingController> controllers = [];
  String dropdownValue = '';
  bool _showDropdown = false;
  var _selectedItem;
 double dqty = 0.00;
  var toWarehouse = "";
  bool checkAllQuantitiesFilled() {
    for (var quantity in quantities) {
      if (quantity.isEmpty) {
        return false; // Return false if any quantity is empty
      }
    }
    return true; // Return true if all quantities are filled
  }
  @override
  void initState() {
    super.initState();
    qc.text = widget.op.toString();
    pr.quantity = widget.op.toString();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    pc.docEntry = widget.docEntry;
    pr.docEntry = widget.docEntry;
    dqty = widget.op;

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
        title: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Open Work Details - ',
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
              WidgetSpan(
                child: SizedBox(width: 10), // Spacer
              ),
              WidgetSpan(
                child: Icon(
                  Icons.fiber_manual_record,
                  color: widget.color,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: widget.color == Colors.green
          ? Container(
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
                        CommonRichText(
                          label: 'Item code: ',
                          value: '${widget.itemcode}',
                        ),
                        CommonRichText(
                          label: 'Product: ',
                          value: '${widget.prod}',
                        ),
                        Row(
                          children: [
                            CommonRichText(
                              label: 'PO: ',
                              value: '${widget.po}',
                            ),
                            SizedBox(width: width*0.05),

                            CommonRichText(
                              label: 'CO: ',
                              value: '${widget.co}',
                            ),
                            SizedBox(width: width*0.05),

                            CommonRichText(
                              label: 'OP: ',
                              value: '${widget.op}',
                            ),
                            SizedBox(width: width*0.05),

                            CommonRichText(
                              label: 'BIN: ',
                              value: "${widget.bincode}",
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              'Received Qty -',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            Expanded(
                              child: Container(
                                height: height * 0.05,
                                child: TextField(
                                  controller: qc,
                                  onChanged: (value) async {
                                    setState(() {
                                      pr.quantity = value.isEmpty
                                          ? widget.op.toString()
                                          : value;
                                    });
                                  },

                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: '${widget.op}',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            //................     ...............         //......................................
                            ElevatedButton(
                              style: CommonWidget.commonbuttonStyle,

                              onPressed: () async {
                                pr.headeritems.add({
                                  'binAbEntry': widget.bincode ?? "",
                                  'quantity': widget.po ?? 0.00,
                                });
                            /*    items.clear();
                                wc.workorderview.forEach((workOrder) {
                                  items.add({
                                    'binAbEntry': widget.bincode ?? 0,
                                    'quantity': workOrder.plannedqty ?? '',
                                    'binline': workOrder.lineNum ?? 0,
                                  });
                                });
                                pc.items =
                                    List<Map<String, dynamic>>.from(items);

                                try {
                                  pc.loadingBar.value = true;

                               //   final response = await pc.postDocumentLines();
                                  var decodedValue = response;
                                  print(decodedValue);
                                  if (decodedValue["Status"] == "success") {
                                    Fluttertoast.showToast(
                                      msg: 'Components posted successful',
                                      gravity: ToastGravity.CENTER_LEFT,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                    );*/
                                    //................................try for receipt
                                    // try {
                                    //   pr.isLoading.value = true;
                                    //   final response = await pr.postreceipt();
                                    //   var decodedValue = jsonDecode(response);
                                    //   print(decodedValue);
                                    //   print("Decoded response type: ${response.runtimeType}");
                                    //
                                    //   if (decodedValue["Status"] == "success") {
                                    //     int DocNum = decodedValue['Message']['DocNum'];
                                    //     QuickAlert.show(
                                    //       context: context,
                                    //       title: 'Success',
                                    //       type: QuickAlertType.success,
                                    //       text: ' Receipt successful\nDocNUM: $DocNum',
                                    //       onConfirmBtnTap: () {
                                    //         Navigator.pop(context);
                                    //         Get.to(() => const HomeScreen());
                                    //       },
                                    //     );
                                    //
                                    //     pr.isLoading.value = false;
                                    //   } else {
                                    //     QuickAlert.show(
                                    //       context: context,
                                    //       title: 'Failed',
                                    //       type: QuickAlertType.error,
                                    //       text: '$decodedValue',
                                    //     );
                                    //     pr.headeritems.clear(); // Clear items list
                                    //
                                    //     // Get.to(() => const HomeScreen());
                                    //   }
                                    // } catch (e) {
                                    //   print('Server error: $e');
                                    //   QuickAlert.show(
                                    //     context: context,
                                    //     title: 'Failed',
                                    //     type: QuickAlertType.error,
                                    //     text: 'Failed to get receipt . Please try again later.',
                                    //   );
                                    //   pr.headeritems.clear(); // Clear items list
                                    //
                                    //   // Get.to(() => const HomeScreen());
                                    //
                                    // } finally {
                                    //   // Set loading back to false after the API call is completed
                                    //   pr.isLoading.value = false;
                                    // }
                                // try {
                                //   pr.isLoading.value = true;
                                //
                                //   final response = await pr.postreceipt();
                                //   final decodedValue = jsonDecode(response); // decode once and use
                                //
                                //   print(decodedValue);
                                //   print("Decoded response type: ${decodedValue.runtimeType}");
                                //
                                //   if (decodedValue["Status"] == "success") {
                                //     int docNum = decodedValue['Message']['DocNum'];
                                //
                                //     QuickAlert.show(
                                //       context: context,
                                //       title: 'Success',
                                //       type: QuickAlertType.success,
                                //       text: 'Receipt successful\nDocNUM: $docNum',
                                //       onConfirmBtnTap: () {
                                //         Navigator.pop(context);
                                //         Get.to(() => const HomeScreen());
                                //       },
                                //     );
                                //   } else {
                                //     QuickAlert.show(
                                //       context: context,
                                //       title: 'Failed',
                                //       type: QuickAlertType.error,
                                //       text: decodedValue.toString(), // safer than '$decodedValue'
                                //     );
                                //     pr.headeritems.clear(); // Clear items list
                                //   }
                                // } catch (e) {
                                //   print('Server error: $e');
                                //   QuickAlert.show(
                                //     context: context,
                                //     title: 'Failed',
                                //     type: QuickAlertType.error,
                                //     text: 'Failed to get receipt. Please try again later.',
                                //   );
                                //   pr.headeritems.clear(); // Clear items list
                                // } finally {
                                //   pr.isLoading.value = false;
                                // }
    try {
      final response = await pr.postreceipt();
    var decodedValue = response;
    print(decodedValue);
    if (decodedValue["Status"] == "success") {
        int docNum = decodedValue['Message']['DocNum'];
    QuickAlert.show(
    context: context,
    title: 'Success',
    type: QuickAlertType.success,
    text: 'Receipt successful\nDocNUM: $docNum',
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
    text: 'Failed Receipt . Please try again later.',
    );
    }


//.................................

                                /*  } else {
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
                                    text:
                                        'Failed to post issue. Please try again later.',
                                  );
                                } finally {
                                  pc.loadingBar.value = false;
                                }
                                */
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() => pr.isLoading.value
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                      : Text('Report Completion',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Components',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (wc.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (wc.errorMessage.isNotEmpty) {
                        return Center(
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'lib/ui/assets/undraw_Empty_re_opql.png',
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: wc.workorderview.length,
                          itemBuilder: (context, index) {
                            final workOrder = wc.workorderview[index];
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
                                          '${workOrder.itemcode}',
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

                                  // CommonRichText(
                                  //   label: 'ITEM:  ',
                                  //   value: '${workOrder.itemcode}',
                                  // ),
                                  CommonRichText(
                                    label: 'Bin Name :  ',
                                    value: '${widget.binname}',
                                  ),
                                  CommonRichText(
                                    label: 'Planned Qty :  ',
                                    value: '${workOrder.plannedqty}',
                                  ),

                                  Row(
                                    children: [
                                      CommonRichText(
                                        label: 'Bin Qty :  ',
                                        value: '${workOrder.binqty}',
                                      ),
                                      SizedBox(width: width * 0.3),



                                    ],
                                  ),
                                  Divider(color: Colors.green,),

                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            )
          :
          //.......................else when select red -ve............................
      Container(
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
                  CommonRichText(
                    label: 'Item code: ',
                    value: '${widget.itemcode}',
                  ),
                  CommonRichText(
                    label: 'Product: ',
                    value: '${widget.prod}',
                  ),
                  Row(
                    children: [
                      CommonRichText(
                        label: 'PO: ',
                        value: '${widget.po}',
                      ),
                      SizedBox(width: width*0.05),

                      CommonRichText(
                        label: 'CO: ',
                        value: '${widget.co}',
                      ),
                      SizedBox(width: width*0.05),

                      CommonRichText(
                        label: 'OP: ',
                        value: '${widget.op}',
                      ),
                      SizedBox(width: width*0.05),

                      CommonRichText(
                        label: 'BIN: ',
                        value: "${widget.bincode}",
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
                if (wc.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (wc.errorMessage.isNotEmpty) {
                  return Center(
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('lib/ui/assets/undraw_Empty_re_opql.png'),
                    ),
                  );
                } else {
                  // Initialize quantities if not already initialized
                  if (quantities.isEmpty) {
                    quantities = List.filled(wc.workorderview.length, '');
                  }

                  return ListView.builder(
                    itemCount: wc.workorderview.length,
                    itemBuilder: (context, index) {
                      final workOrder = wc.workorderview[index];
                      pc.fromWarehouse = workOrder.warehouse;

                      // Initialize controller for each TextField if not already initialized
                      if (controllers.length <= index) {
                        controllers.add(TextEditingController());
                      }
                      if (quantities.length <= index) {
                        quantities.add('');
                      }
                      // Update quantity function
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
                                    '${workOrder.itemcode}',
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
                            CommonRichText(
                                label: 'Bin Name:  ',
                                value: '${widget.binname}'
                            ),
                            CommonRichText(
                                label: 'Planned Qty:  ',
                                value: '${workOrder.plannedqty}'
                            ),
                            Row(
                              children: [
                                CommonRichText(
                                    label: 'Bin Qty:  ' ,
                                    value: '${workOrder.binqty}'
                                ),
                              Spacer(),
                                Expanded(
                                  child: Container(
                                    height: height * 0.03,
                                    child: TextField(
                                      controller: controllers[index],
                                      onChanged: updateQuantity,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        hintText: 'Req Qty',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text('WareHouse: '),
                  SizedBox(width: width * 0.01,),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Obx(
                            () => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedItem,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                // Update the selected item and assign it to pc.warehouse
                                setState(() {
                                  _selectedItem = newValue;
                                });
                                toWarehouse = newValue;
                                pc.toWarehouse = newValue;
                              }
                            },
                            items: wh.warehouse.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value.whsCode,
                                child: Text(value.whsCode),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: width * 0.01),
            ElevatedButton(
              style: CommonWidget.commonbuttonStyle,

              onPressed: () async{
                if (checkAllQuantitiesFilled()) {
                  List<Map<String, dynamic>> selectedItems = [];
                    print(' in pre.....$toWarehouse');
                wc.workorderview.asMap().forEach((index, workOrder) {
    selectedItems.add({
      'itemCode': workOrder.itemcode ?? '',
      'quantity': quantities[index], // Use the updated quantity
      'fromWarehouseCode': workOrder.warehouse ?? "",
      'warehouseCode': toWarehouse ?? '', // User selection from dropdown
      'toBinCode': widget.bincode ?? '',
      'toBinName': widget.binname ?? '',
    });
  });
  pc.data = List<Map<String, dynamic>>.from(selectedItems);
  try {
    pr.isLoading.value = true;
    final response = await pc.postWorkOrderNeg();
    var decodedValue = response;
    print(decodedValue);
    if (decodedValue["Status"] == "success") {
      int DocNum = decodedValue['Message']['DocNum']; // Access DocEntry
      QuickAlert.show(
        context: context,
        title: 'Success',
        type: QuickAlertType.success,
        text: 'Post ITR successful\nDocNUM: $DocNum',
        onConfirmBtnTap: () {
          Navigator.pop(context); // Close current screen or dialog
          Get.to(() => HomeScreen()); // Navigate to HomeScreen using GetX navigation
        },
      );
      pr.isLoading.value = false;
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
      text:
      'Failed to  Post ITR . Please try again later.',
    );
  } finally {
    // Set loading back to false after the API call is completed
    pr.isLoading.value = false;
  }
}else{
  Fluttertoast.showToast(
    msg: "please fill all req Qty",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
  return;
}
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8),
                  Obx(
                        () => pc.loadingBar.value
                        ? CircularProgressIndicator()
                        : Text(
                      "Post ITR",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: pc.loadingBar.value
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


