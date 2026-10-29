import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/ui/CommonWidget.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:sap/features/workorder/presentation/workorder_details_page.dart';
import 'package:sap/features/transfer_req/controller/transferreq_controller.dart';
import 'package:sap/features/workorder/controller/workorder_controller.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferReqState();
}

class _TransferReqState extends State<TransferScreen> {
  String dropdownValue = '';
  WarehouseController warehouseController = Get.put(WarehouseController());
  TextEditingController searchController = TextEditingController();
  final WorkOrderController _controller = Get.put(WorkOrderController());
  late List<dynamic> filteredWorkOrders;
  WarehouseController TR = Get.put(WarehouseController());

  @override
  void initState() {
    super.initState();
    filteredWorkOrders = warehouseController.transfer;
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
        title: Text('Open Stock Transfer neg',style: CommonWidget.gogo),
        backgroundColor: AppColors.mainblue,
      ),
      body:Obx(() {
        if (warehouseController.istransferLoading.value) {
          // Show loading indicator while data is being fetched
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (warehouseController.errorMessage.isNotEmpty) {
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
                height: height*0.07,
                child:Padding(
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
                    onChanged: (value) {
                      setState(() {
                        filteredWorkOrders = warehouseController.transfer
                            .where((order) =>
                            order.docEntry.toString().contains(value))
                            .toList();
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredWorkOrders.length,
                  itemBuilder: (context, index) {
                    final workOrder = filteredWorkOrders[index];
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
                        child:  InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: () async {
                            await _controller.getWorkOrderView(
                                workOrder.docEntry,workOrder.BinCode
                            );
                            await TR.fetchwarehouse();
                            Get.to(() => WorkorderDetails(
                                  docEntry: workOrder.docEntry!,
                                  itemcode: workOrder.itemCode!,
                                  docnum: workOrder.docNum!,
                                  startDate: workOrder.startDate!,
                                  prod: workOrder.prodName!,
                                  po: workOrder.plannedQty!,
                                  co: workOrder.cmpltQty!,
                                  op: workOrder.openQty!,
                                  bincode: workOrder.BinCode!,
                                  binname: workOrder.BinName!,
                                  color: "${workOrder.BinFlag}" == "Yes"
                                      ? Colors.green
                                      : Colors.red,
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
                                        workOrder.itemCode,
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
                                    Text('WO: ${workOrder.docNum}'),
                                    Text('OA: ${workOrder.docEntry}'),
                                    Text(
                                      '${workOrder.startDate.year}-${workOrder.startDate.month.toString().padLeft(2, '0')}-${workOrder.startDate.day.toString().padLeft(2, '0')}',
                                    ),
                                  ],
                                ),
                                Text(
                                  workOrder.prodName,
                                  style: CommonWidget.commontextstyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'PO: ${workOrder.plannedQty}',
                                      style: CommonWidget.commontextstyle,
                                    ),
                                    Spacer(),
                                    Text(
                                      'CO: ${workOrder.cmpltQty}',
                                      style: CommonWidget.commontextstyle,
                                    ),
                                    Spacer(),
                                    Text(
                                      'OQ: ${workOrder.openQty}',
                                      style: CommonWidget.commontextstyle,
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: "${workOrder.BinFlag}" == "Yes"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                            color:
                                                "${workOrder.BinFlag}" == "Yes"
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
