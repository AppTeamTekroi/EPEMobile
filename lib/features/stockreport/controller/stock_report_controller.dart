import 'package:get/get.dart';
import 'package:sap/features/stockreport/data/model/get_stockdetails_model.dart';
import 'package:sap/features/stockreport/data/datasource/stock_report_datasource_repository_impl.dart';
import 'package:sap/features/stockreport/data/model/get_stockreport_model.dart';

class StockReportController extends GetxController {
  late final StockReportDataSourceImpl stockReportDataSourceImpl = StockReportDataSourceImpl();

  var stockData = <StockReportModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var errorMessagestocks = ''.obs;

  var stockDetails = <StockDetailsModel>[].obs;
var isLoadingstockdata = false.obs;
  Future<void> fetchStockData(String warehouse, String binCode) async {
    try {
      isLoadingstockdata.value = true;

      final result = await stockReportDataSourceImpl.fetchStockData(warehouse, binCode);
      result.fold(
            (failure) {
              stockData.clear(); // Ensure you clear the correct list
        },
            (List<StockReportModel> responseData) {
          // Assign the list of StockReportModel objects directly to stockData
          stockData.value = responseData;
          errorMessagestocks.value = '';
          isLoadingstockdata.value = false;

          print('Successfully fetched stock data');
        },
      );

    }catch (e) {
      isLoadingstockdata.value = false;
      errorMessagestocks.value = 'An error occurred: $e';
      print('Failed to fetch stock data');
    }
  }
@override
  Future<void> fetchStockDetails(String itemcode, String fromdate, String todate) async {
    try {
      isLoading.value = true;
      final result = await stockReportDataSourceImpl.fetchStockDetails(itemcode, fromdate, todate);
      result.fold(
            (failure) {
          errorMessage.value = 'Failed to fetch stock details: ${failure.message}';
          isLoading.value = false;
          stockDetails.clear(); // Ensure you clear the correct list
        },
            (details) {
          stockDetails.value = details;
          errorMessage.value = '';
          isLoading.value = false;
          print('Successfully fetched stock details......');
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: $e';
      print('Failed to fetch stock details');
    }
  }
}
