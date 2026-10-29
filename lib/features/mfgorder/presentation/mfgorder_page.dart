import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/features/mfgorder/controller/mfgorder_controller.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:sap/ui/CommonWidget.dart';
import 'package:sap/features/mfgorder/presentation/mfgdetails_page.dart';

class MfgOrderScreen extends StatefulWidget {
  const MfgOrderScreen({super.key});

  @override
  State<MfgOrderScreen> createState() => _MfgOrderScreen();
}

class _MfgOrderScreen extends State<MfgOrderScreen> {
  MfgOrderController mfgOrdercontroller = Get.put(MfgOrderController());
  TextEditingController searchController = TextEditingController();
  late List<dynamic> filteredWorkOrders;
  @override
  void initState() {
    super.initState();
    filteredWorkOrders = mfgOrdercontroller.MfgOrerData;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


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
        title: const Text(
          'Mfg Order',
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.w400),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (mfgOrdercontroller.isLoadingmfgdata.value) {
                return Center(child: CircularProgressIndicator());

              } else if (mfgOrdercontroller.errorMessagestocks.isNotEmpty) {
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
                          filteredWorkOrders = mfgOrdercontroller.MfgOrerData
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
                  itemCount: mfgOrdercontroller.MfgOrerData.length,
                  itemBuilder: (context, index) {
                    final mfg = mfgOrdercontroller.MfgOrerData[index]; // Access individual StockReportModel
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
                    await mfgOrdercontroller.fetchMfgDetails(mfg.docEntry,mfg.BinCode);
                    Get.to(() => MfgDetails(
                    itemcode: mfg.itemCode!,
                      docEntry: mfg.docEntry!,
                      docnum: mfg.docNum!,
                      startDate: mfg.startDate!,
                      prod: mfg.prodName!,
                      po: mfg.plannedQty!,
                      co: mfg.cmpltQty!,
                      op: mfg.openQty!,
                      binname: mfg.BinName,
                      bincode: mfg.BinCode,

                      color: "${mfg.BinFlag}" == "Yes"
                          ? Colors.green
                          : Colors.red,
                    ));
                    },
                    child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:Column(
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
                                      mfg.itemCode,
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
                                  Text('WO: ${mfg.docNum}'),
                                  Text('OA: ${mfg.docEntry}'),
                                  Text(
                                    '${mfg.startDate.year}-${mfg.startDate.month.toString().padLeft(2, '0')}-${mfg.startDate.day.toString().padLeft(2, '0')}',
                                  ),
                                ],
                              ),
                              Text(
                                mfg.prodName,
                                style: CommonWidget.commontextstyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'PO: ${mfg.plannedQty}',
                                    style: CommonWidget.commontextstyle,
                                  ),
                                  Spacer(),
                                  Text(
                                    'CO: ${mfg.cmpltQty}',
                                    style: CommonWidget.commontextstyle,
                                  ),
                                  Spacer(),
                                  Text(
                                    'OQ: ${mfg.openQty}',
                                    style: CommonWidget.commontextstyle,
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: "${mfg.BinFlag}" == "Yes"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'View',
                                        style: TextStyle(
                                          color: "${mfg.BinFlag}" == "Yes"
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
          ),
        ],
      ),
    );
  }
}
