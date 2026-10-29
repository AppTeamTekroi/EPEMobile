import 'package:get/get.dart';
import '../data/datasource/post_datasource_impl.dart';
import '../data/model/post_workorder_model.dart';
import '../data/model/post_workorderneg_model.dart';

class PostWorkOrderController extends GetxController {
  late PostDataSourceImpl postDataSourceImpl;
  var loadingBar = false.obs;
  String baseType = "202";
  int docEntry = 0;
  String warehouse = "";
  List<Map<String, dynamic>> items = [];
//................................

  var fromWarehouse = '';
  var toWarehouse = '';
  var toBinCode = '';
  var toBinName = "";
  var newsale2 = false.obs;
  var newsale1 = false.obs;

  List<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    postDataSourceImpl = PostDataSourceImpl();
  }
  @override

  Future<dynamic> postDocumentLines() async {
    loadingBar.value = true;
    try {
      print(items);
      List<DocumentLine> documentLines = items.map((item) {
        return DocumentLine(
          baseType: baseType,
          baseEntry: docEntry,
          baseLine: item['binline'] ?? 0, // Ensure default value is of type int
          documentLinesBinAllocations: [
            DocumentLinesBinAllocation(
              binAbsEntry: item['binAbEntry'] ?? 0,
              // Ensure default value is of type int
              quantity: double.parse(item['quantity']) ??
                  0.00, // Ensure default value is of type double
            ),
          ],
        );
      }).toList();
      final postIssueProduction = PostIssueModel(documentLines: documentLines);
      final response = await postDataSourceImpl.postData(postIssueProduction);
      var responseData;
      response.fold(
        (failure) {
          responseData.clear();
          loadingBar.value = false;

          print('Failure in issue production : ${failure.message}');
        },
        (res) => responseData = res,

      );
      loadingBar.value = false;

      return responseData;

    } catch (e) {
      print('Exception: $e');
      loadingBar.value = false;
      throw Exception('Failed in issue production: $e');

    }
  }
  void clearData() {
    items.clear(); // Clear items list
  }
  @override
  Future<dynamic> postWorkOrderNeg() async {
    loadingBar.value = true;
       print('neggggggggggggggggggggggggggggggggggggggggggg................');
    print('the elected items $data');
    try {
      List<StockTransferLine> stockTransferLines = data.map((itemneg) {
        return StockTransferLine(
          itemCode: itemneg['itemCode'].toString() ?? '',
          quantity: itemneg['quantity'] ?? '0.00',
          fromWarehouseCode: itemneg['warehouseCode'] ?? '',
          warehouseCode: itemneg['fromWarehouseCode'].toString() ?? "",
          uTrptobin: itemneg['toBinCode'].toString() ?? '',
          uTrptobnm: itemneg['toBinName'].toString() ?? '',
        );
      }).toList();

      // Create an instance of the model and populate it with dynamic data
      final details = WorkOrderNeGModel(
        fromWarehouse: toWarehouse.toString(),
        toWarehouse: fromWarehouse.toString(),
        uTrpfmapp : "Yes",
        uTrppdno : docEntry.toString(),
        stockTransferLines: stockTransferLines,
      );

      final response = await postDataSourceImpl.postWorkNEGData(details);
      print('API Response: $response');

      var responseData;
      response.fold(
            (failure) {
          responseData.clear();
          loadingBar.value = false;

          print('Failure in transfer stocks : ${failure.message}');
          responseData = 'Failure in transfer tocks: ${failure.message}';
        },

          (res) => responseData = res,

      );
      loadingBar.value = false;

      return responseData;
    }catch (e) {
      print('Exception: $e');
      loadingBar.value = false;

      throw Exception('Failed to transfer stocks: $e');
    }
  }

}
