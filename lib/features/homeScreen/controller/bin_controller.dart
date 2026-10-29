import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:sap/features/homeScreen/data/datasource/bin_datasource_repository_impl.dart';
import 'package:sap/features/homeScreen/data/model/get_bin_model.dart';
import 'package:sap/core/error/failure.dart';

class BinController extends GetxController {
  late final BinNameDataSourceImpl binDataSourceImpl = BinNameDataSourceImpl();
  var binNameModel = BinNameModel(BinName: '').obs;
  // var warehouse = ''.obs;
  // var binCode = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var bin_name = <BinNameModel>[].obs;

  Future<String> fetchbinName(String warehouse, String binCode) async {
    try {
      print('hitting bin controller');
      isLoading.value = true;
      final result = await binDataSourceImpl.fetchbinName(warehouse, binCode);

      return result.fold(
            (failure) {
          errorMessage.value = 'Failed';
          isLoading.value = false;
          bin_name.value = [];
          return 'Error: ${failure.message}';
        },
            (resData) {
          bin_name.value = [resData];
          binNameModel.value = resData;
          errorMessage.value = '';
          isLoading.value = false;
          print('Successfully fetched bin name');
          return 'Bin name fetched successfully';
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: $e';
      print('Failed to fetch bin name');
      return 'Error: $e';
    }
  }
}
