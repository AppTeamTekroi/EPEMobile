import 'package:get/get.dart';
import 'package:sap/features/inventory/data/model/post_inventory_model.dart';
import 'package:sap/features/inventory/data/datasource/inventory_datasource_impl.dart';

class PostTransferReq extends GetxController {
  late InventoryDataSourceImpl inventoryDataSourceImpl;
  var fromWarehouse = '';
  var toWarehouse = '';
  var fromBinCode = '';
  var toBinCode = '';
  var binActionType1 = 2;
  var binActionType2 = 1;
  var newTransfer = false.obs;
  var loadingBar = false.obs;
  var proddocEntry = "";

  List<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  @override
  void onInit(){
    super.onInit();
    inventoryDataSourceImpl = InventoryDataSourceImpl();
  }
  Future<dynamic> stockTransfer() async {
    loadingBar.value = true;

    print('Initializing new sale controller');
    print('FromWarehouse: $fromWarehouse');
    print('ToWarehouse: $toWarehouse');
    print('FromBinCode: $fromBinCode');
    print('Selected Items: $data');
    try {
      // Create a list of StockTransferLine from data
      List<StockTransferLine> stockTransferLines = data.map((item) {
        return StockTransferLine(
          itemCode: item['itemCode'] ?? '',
          quantity: double.parse(item['quantity'] ?? '0'),
          fromWarehouseCode: fromWarehouse,
          warehouseCode: toWarehouse ?? '',
          stockTransferLinesBinAllocations: [
            StockTransferLineBinAllocation(
              binActionType: binActionType1,
              binAbsEntry: item['frombincode'] ?? '',
              quantity: double.parse(item['quantity'] ?? '0'),
            ),
            StockTransferLineBinAllocation(
              binActionType: binActionType2,
              binAbsEntry: toBinCode,
              quantity: double.parse(item['quantity'] ?? '0'),
            ),
          ],
        );
      }).toList();

      final details = StockTransferModel(
        fromWarehouse: fromWarehouse,
        toWarehouse: toWarehouse,
        yes: "Yes",
        ProdDoc: proddocEntry,

        stockTransferLines: stockTransferLines,
      );
      loadingBar.value = true;
      final response = await inventoryDataSourceImpl.postInventoryData(details);
      print('API Response: $response');
      var responseData;
      response.fold(
            (failure) {
              loadingBar.value = false;
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
      throw Exception('Failed to transfer stocks: $e');
    }
  }

}
