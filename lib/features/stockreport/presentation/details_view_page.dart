import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sap/features/stockreport/controller/stock_report_controller.dart';
import 'package:sap/ui/color/appColor.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:sap/features/stockreport/data/model/get_stockdetails_model.dart';

class DetailsView extends StatefulWidget {
  final String itemcode;
  final String itemname;
  const DetailsView({
    required this.itemcode,
    required this.itemname,
    Key? key,
  }) : super(key: key);
  @override
  State<DetailsView> createState() => _DetailsViewState();
}
class _DetailsViewState extends State<DetailsView> {
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  final StockReportController controller = Get.put(StockReportController());
  String fromdate = "";
  var todate = "";
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      start();
    });
  }

  start() async {
    print(widget.itemcode);

    // Use the provided dates if available, otherwise use the default dates
    String fromDate =
    fromdate != null && fromdate.isNotEmpty
        ? fromdate
        : _fromDateController.text.isNotEmpty
        ? _fromDateController.text
        : "20231226";
    String toDate =
    todate != null && todate.isNotEmpty
        ? todate
        : _toDateController.text.isNotEmpty
        ? _toDateController.text
        : "20240602";

    print("Using from date for fetching: $fromDate");
    print("Using to date for fetching: $toDate");

    await controller.fetchStockDetails(widget.itemcode, fromDate, toDate);
  }
  @override
  Widget build(BuildContext context) {
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
        title: Text('Stock Details',style: TextStyle(color: Colors.white,fontSize: 18),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0), // Adjust the height as needed
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        readOnly: true,
                        controller: _fromDateController,
                        decoration: InputDecoration(
                          hintText: 'FromDate',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                          ),
                          contentPadding: EdgeInsets.all(8),
                        ),

                        onTap: () {
                          _selectDate(_fromDateController);
                        },
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Color(0xFFC09500),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _toDateController,
                        decoration: InputDecoration(
                          hintText: 'ToDate',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                          contentPadding: EdgeInsets.all(8),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(_toDateController);
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:   Color(0xFFC09500),
                      foregroundColor: AppColors.mainblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      start();
                    },
                    child: Text('GO'),
                  ),
                ],
              ),
             // Padding(padding: EdgeInsets.all(10)),

              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('ItemCode :',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.mainblue ),),
                        Text(
                          '${widget.itemcode}',
                          style: TextStyle(fontSize: 13,color: Colors.black),

                        ),
                      ],
                    ),
    RichText(
    text: TextSpan(
    text: 'ItemName : ',
    style: TextStyle(
    color: AppColors.mainblue,
      fontWeight: FontWeight.bold,
    ),
    children: [
    TextSpan(
    text: '${widget.itemname}',
      style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.normal,),

    ),
    ],
    ),
    ),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else {
            return _getBodyWidget(controller.stockDetails);
          }
        },
      ),
    );
  }

  Widget _getBodyWidget(List<StockDetailsModel> stockDetails) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: HorizontalDataTable(
          leftHandSideColumnWidth: 100,
          rightHandSideColumnWidth: 390,
          isFixedHeader: true,
          headerWidgets: _getTitleWidget(),
          leftSideItemBuilder: _generateLeftHandSideColumnRow,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: stockDetails.length,
          rowSeparatorWidget: const Divider(
            color: Colors.black54,
            height: 0,
            thickness: 0.0,
          ),
          leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
          rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
          verticalScrollbarStyle: const ScrollbarStyle(
            thumbColor: Colors.yellow,
            isAlwaysShown: true,
            thickness: 4.0,
            radius: Radius.circular(5.0),
          ),
          horizontalScrollbarStyle: const ScrollbarStyle(
            thumbColor: Colors.red,
            isAlwaysShown: true,
            thickness: 4.0,
            radius: Radius.circular(5.0),
          ),
        ),
        width: MediaQuery
            .of(context)
            .size
            .width,
      ),
    );
  }
  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Date', 98),
      _getTitleItemWidget('Memo', 100),
      _getTitleItemWidget('OBQty', 80),
      _getTitleItemWidget('In Qty', 80),
      _getTitleItemWidget('Out Qty', 80),
      _getTitleItemWidget('Whs', 50),
    ];
  }
  Widget _generateLeftHandSideColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(controller.stockDetails[index].docDate,
          style: TextStyle(color: AppColors.mainblue)),
      width: 98,
      height: 60,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
      width: width,
      height: 60,
      color: AppColors.mainblue,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }



  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var stock = controller.stockDetails[index];
    return Row(
      children: <Widget>[

        Container(
          child: Text(stock.jrnlMemo),
          width: 100,
          height: 60,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(stock.obQty.toString()),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(stock.inQty.toString()),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(stock.OutQty.toString()),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(stock.warehouse),
          width: 50,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }


  Future<void> _selectDate(TextEditingController dateController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
        if (dateController == _fromDateController) {
          fromdate = dateController.text;
        } else if (dateController == _toDateController) {
          todate = dateController.text;
        }
      });
    }
  }
}
