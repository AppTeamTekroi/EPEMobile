import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/features/stockreport/controller/stock_report_controller.dart';
import '../../homeScreen/controller/bin_controller.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:sap/ui/CommonWidget.dart';

import '../presentation/details_view_page.dart';

class StockReportScreen extends StatelessWidget {
  final String warehouse;
  final String binCode;
  final String binName;

  StockReportScreen({
    required this.warehouse,
    required this.binCode,
    required this.binName,
  });

  @override
  Widget build(BuildContext context) {
    final StockReportController controller = Get.put(StockReportController());
    final BinController binController = Get.put(BinController());
    // Fetch stock data when the screen is loaded
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.fetchStockData(warehouse, binCode);
    });

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
        title: Text(
          'Stock Report',
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.w400),
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
                    Text('WareHouse:$warehouse'),
                    Text('BinCode:$binCode'),
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
              if (controller.isLoadingstockdata.value) {
                return Center(child: CircularProgressIndicator());

              } else if (controller.errorMessagestocks.isNotEmpty) {
                return Center(
                  child: Text('Error: ${controller.errorMessagestocks.value}'),
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
                                  Icon(
                                    Icons.fiber_manual_record, // Use the motorcycle icon from Material Icons
                                    color: Color(0xFFC09500),
                                    size: 10,// Gold color
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      stock.itemCode,
style:                                 TextStyle(fontSize: 15,
                                        color: AppColors.mainblue,
                                        fontFamily: 'RobotoMono',
                                        fontWeight: FontWeight.w500
                                    ),                                     overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                    size: 15,
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
                                      'Bin Qty: ',style: CommonWidget.commonboldTextStyle,
                                      // Access onHandQty from individual StockReportModel
                                    ),

                                    Text(stock.onHandQty,style: CommonWidget.commontextstyle,),
                                    ],
                                  ),
                                  ),
                              SizedBox(width: 20),
                                  Expanded(
                                    child: Row(
                                      children: [
                                      Text(
                                      'UoM: ',style: CommonWidget.commonboldTextStyle,
                                      // Access uom from individual StockReportModel
                                    ),
                                        Text(stock.uom,style: CommonWidget.commontextstyle,)
                                 ], ),
                    ),
                                ],
                              ),
                            ],
                          ),
              onTap: () {
                Get.to(() => DetailsView(itemcode:stock.itemCode,itemname:stock.itemName));
                          }
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
