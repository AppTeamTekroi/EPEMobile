import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import '../data/datasource/transferreq_datasource_impl.dart';
import '../data/model/warehouse_model.dart';
import 'package:sap/core/error/failure.dart';
import '../data/model/transfer_model.dart';
import '../data/model/verification_model.dart';
import '../data/model/transferreq_details_model.dart';
class WarehouseController extends GetxController {
  late final WarehouseDataSourceImpl warehouseDataSourceImpl = WarehouseDataSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var warehouse = <WarehouseModel>[].obs;
  var transfer = <TransferModel>[].obs;
  var istransferLoading = false.obs;
  var verifyResult = <VerifyModel>[].obs;
  var isverifyLoading = false.obs;
  var transferReqDetailsList = <Transferreqdetails>[].obs;
  var trfreqdetailsloading = false.obs;
  @override
  Future<dynamic> fetchwarehouse() async {
    try {
      print('hitting warehouse controller');
      isLoading.value = true;
      final result = await warehouseDataSourceImpl.fetchwarehouse();
      print('response from data source warehouse');
      return result.fold(
            (failure) {
          isLoading.value = false;
          warehouse.clear();
          print('failed to fetch warehouse');
          return 'Error: ${failure.message}';
        },
            (List<WarehouseModel> resData) {
          warehouse.value = resData;
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

  @override
  Future<dynamic> fetchtransfer() async {
    try {
      istransferLoading.value = true;
      final result = await warehouseDataSourceImpl.fetchtransfer();
      result.fold(
            (failure) {
          transfer.clear();
          errorMessage.value =
          'Failed to fetch transfer data: ${failure.message}';
          print('failure transfer order${failure.message}');
          istransferLoading.value = false;
        },
            (List<TransferModel> responseData) {
          transfer.value = responseData;
          errorMessage.value = '';
          istransferLoading.value = false;
          print('success fetching transfer');
        },
      );
    } catch (e) {
      // Handle error
      errorMessage.value = 'An error occurred: $e';
      istransferLoading.value = false;
    }
  }
  Future<Either<Failure, List<VerifyModel>>> fetchBinVerify(int bin, int whs, String itemcode) async {
    try {
      isverifyLoading.value = true;
      final result = await warehouseDataSourceImpl.fetchbinverify(bin, whs, itemcode);
      result.fold(
            (failure) {
          verifyResult.clear();
          errorMessage.value = 'Failed to verify: ${failure.message}';
          print('Failure to verify: ${failure.message}');
          isverifyLoading.value = false;
        },
            (List<VerifyModel> responseData) {
          verifyResult.value = responseData;
          errorMessage.value = '';
          isverifyLoading.value = false;
          print('Success verify');
        },
      );
      return result;
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      isverifyLoading.value = false;
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
  @override
  Future<void> getTransferReqDetails(int docEntry) async {
    try {
      trfreqdetailsloading.value = true;
      final result = await warehouseDataSourceImpl.transferreqdetails(docEntry);
      result.fold(
            (failure) {
          transferReqDetailsList.clear();
          errorMessage.value = 'Failed to fetch transfer request details: ${failure.message}';
          print('Failure fetching transfer request details: ${failure.message}');
          trfreqdetailsloading.value = false;
        },

              (List<Transferreqdetails> responseData) {
                transferReqDetailsList.value = responseData;
          errorMessage.value = '';
          trfreqdetailsloading.value = false;
          print('Successfully fetched transfer request details');
        },
      );
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      trfreqdetailsloading.value = false;
    }
  }

}