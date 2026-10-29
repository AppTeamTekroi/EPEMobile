import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/ui/CommonWidget.dart';
import 'package:sap/ui/color/appColor.dart';
import '../presentation/transferreq_details.dart';
import '../controller/transferreq_controller.dart';
import 'package:sap/features/workorder/controller/workorder_controller.dart';
import 'package:sap/features/transfer/controller/transfer_controller.dart';
class TransferReq extends StatefulWidget {
  const TransferReq({super.key});

  @override
  State<TransferReq> createState() => _TransferReqState();
}

class _TransferReqState extends State<TransferReq> {
  String dropdownValue = '';
  TextEditingController searchController = TextEditingController();
  final WorkOrderController _controller = Get.put(WorkOrderController());
  WarehouseController TR = Get.put(WarehouseController());
  final TransferController transferController = Get.put(TransferController());

  @override
  void initState() {
    super.initState();
    transferController.fetchTransfer();
  }

  bool _showDropdown = false;
  var _selectedItem;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // Navigate back to the previous screen
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        title: Text('Open Stock Transfer Req', style: CommonWidget.gogo),
        backgroundColor: AppColors.mainblue,
      ),
      body: Obx(() {
        if (transferController.isLoadingtransferdata.value) {
          // Show loading indicator while data is being fetched
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (transferController.errorMessagestocks.isNotEmpty) {
          // Show error message if there's an error
          return Center(
            child: Image.asset(
              'lib/ui/assets/undraw_Empty_re_opql.png', // Adjusted path to asset
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                height: height * 0.07,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by DocEntry',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: transferController.transferData.length,
                  itemBuilder: (context, index) {
                    final transfer = transferController.transferData[index];
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: () async {
                            await TR.getTransferReqDetails(
                                transfer.docEntry);
                            await TR.fetchwarehouse();
                            Get.to(() => TransferDetails(
                              docEntry: transfer.docEntry!,
                              itemcode: transfer.itemCode!,
                              docnum: transfer.docNum!,
                              startDate: transfer.startDate!,
                              prod: transfer.prodName!,
                              po: transfer.plannedQty!,
                              co: transfer.cmpltQty!,
                              op: transfer.openQty!,
                              binname: transfer.BinName!,
                              bincode: transfer.BinCode,
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
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
                                        transfer.itemCode,
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

                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('WO: ${transfer.docNum}'),
                                    Text('OA: ${transfer.docEntry}'),
                                    Text(
                                      '${transfer.startDate.year}-${transfer.startDate.month.toString().padLeft(2, '0')}-${transfer.startDate.day.toString().padLeft(2, '0')}',
                                    ),
                                  ],
                                ),
                                Text(
                                  transfer.prodName,
                                  style: CommonWidget.commontextstyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'PO: ${transfer.plannedQty}',
                                      style: CommonWidget.commontextstyle,
                                    ),
                                    Spacer(),
                                    Text(
                                      'CO: ${transfer.cmpltQty}',
                                      style: CommonWidget.commontextstyle,
                                    ),
                                    Spacer(),
                                    Text(
                                      'OQ: ${transfer.openQty}',
                                      style: CommonWidget.commontextstyle,
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: "${transfer.BinFlag}" == "Yes"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                            color: "${transfer.BinFlag}" == "Yes"
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
