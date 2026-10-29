import 'package:get/get.dart';
import 'package:sap/features/workorder/data/model/get_workorderView_model.dart';
import 'package:sap/features/workorder/data/model/get_workorder_model.dart';
import 'package:sap/features/workorder/data/datasource/workorder_datasource_impl.dart';

class WorkOrderController extends GetxController {
  late final WorkOrderDataSourceImpl workOrderDataSourceImpl = WorkOrderDataSourceImpl();

  var workorder = <WorkOrderModel>[].obs;
  var isLoading = false.obs;
  var isworkorderLoading = false.obs;
  var errorMessage = ''.obs;
  var workorderview = <WorkOrderView>[].obs;

  Future<void> getWorkOrder() async {
    try {
      isworkorderLoading.value = true;
      final result = await workOrderDataSourceImpl.getworkorder();
      result.fold(
            (failure) {
              workorder.clear();
          errorMessage.value = 'Failed to fetch work order data: ${failure.message}';
          print('failure work order${failure.message}');
              isworkorderLoading.value = false;
        },
            (List<WorkOrderModel> responseData) {
              print(responseData);
          workorder.value = responseData; // Update workorder value directly
          errorMessage.value = '';
          isworkorderLoading.value = false;
          print('success fetching work order');
        },
      );

    } catch (e) {
      // Handle error
      errorMessage.value = 'An error occurred: $e';
      isworkorderLoading.value = false;
    }
  }


  @override

  Future<void> getWorkOrderView(int DocEntry, String bincode) async {
    try {
      isLoading.value = true;
      final result = await workOrderDataSourceImpl.getworkorderView(DocEntry,bincode);
      result.fold(
            (failure) {
              workorder.clear();

              errorMessage.value = 'Failed to fetch work order View data: ${failure.message}';
          print('failure work order');
          isLoading.value = false;
        },
            (responseData) {
              workorderview.value = responseData;
          errorMessage.value = '';
          isLoading.value = false;
          print('success fetching work order View');
        },
      );

    } catch (e) {
      // Handle error
      errorMessage.value = 'An error occurred: $e';
      isLoading.value = false;
    }
  }
}
