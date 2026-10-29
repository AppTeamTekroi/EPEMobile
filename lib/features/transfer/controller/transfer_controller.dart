import 'package:get/get.dart';
import 'package:sap/features/transfer/data/model/transfer_model.dart';
import 'package:sap/features/transfer/data/datasource/transfer_datasource_impl.dart';

class TransferController extends GetxController {
  late final TransferDataSourceImpl stockReportDataSourceImpl = TransferDataSourceImpl();

  var transferData = <TransferModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var errorMessagestocks = ''.obs;

  var isLoadingtransferdata = false.obs;
  Future<void> fetchTransfer() async {
    try {
      isLoadingtransferdata.value = true;

      final result = await stockReportDataSourceImpl.fetchTransfer();
      result.fold(
            (failure) {
              transferData.clear(); // Ensure you clear the correct list
        },
            (List<TransferModel> responseData) {
          // Assign the list of StockReportModel objects directly to stockData
              transferData.value = responseData;
          errorMessagestocks.value = '';
          isLoadingtransferdata.value = false;

          print('Successfully fetched stock data');
        },
      );

    }catch (e) {
      isLoadingtransferdata.value = false;
      errorMessagestocks.value = 'An error occurred: $e';
      print('Failed to fetch stock data');
    }
  }

}
