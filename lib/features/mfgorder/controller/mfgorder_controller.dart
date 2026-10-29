import 'package:get/get.dart';
import 'package:sap/features/mfgorder/data/model/get_mfgorder_model.dart';
import 'package:sap/features/mfgorder/data/model/get_mfgorder_model.dart';

import '../data/datasource/mfgorder_datasource_impl.dart';
import '../data/model/mfgorder_details_model.dart';

class MfgOrderController extends GetxController {
  late final MfgOrderDataSourceImpl mfgOrderDataSourceImpl = MfgOrderDataSourceImpl();

  var MfgOrerData = <MfgOrderModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var errorMessagestocks = ''.obs;

  var MfgDetails = <MfgDetailsModel>[].obs;
  var isLoadingmfgdata = false.obs;
  Future<void> fetchMfgOrder() async {
    try {
      isLoadingmfgdata.value = true;
      // Inside the fetchStockData method of StockReportController
      // Inside the fetchStockData method of StockReportController
      final result = await mfgOrderDataSourceImpl.fetchMfgOrder();
      var data = result;
      print(" in controler...........$data");
      result.fold(
            (failure) {
          MfgOrerData.clear(); // Ensure you clear the correct list
        },
            (List<MfgOrderModel> responseData) {
          // Assign the list of StockReportModel objects directly to stockData
          MfgOrerData.value = responseData;
          errorMessagestocks.value = '';
          isLoadingmfgdata.value = false;

          print('Successfully fetched MfgOrder data');
        },
      );

    }catch (e) {
      isLoadingmfgdata.value = false;
      errorMessagestocks.value = 'An error occurred: $e';
      print('Failed to fetch stock data');
    }
  }
  @override
  Future<void> fetchMfgDetails(int DocEntry, String bincode) async {
    try {
      isLoading.value = true;
      final result = await mfgOrderDataSourceImpl.fetchMfgDetails(DocEntry,bincode);
      result.fold(
            (failure) {
          errorMessage.value = 'Failed to fetch stock details: ${failure.message}';
          isLoading.value = false;
          MfgDetails.clear(); // Ensure you clear the correct list
        },
            (details) {
              print(details);
          MfgDetails.value = details;
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
