import 'package:get/get.dart';
import '../data/datasource/post_datasource_impl.dart';
import '../data/model/post_receipt_model.dart';

class PostReceiptController extends GetxController {
  late PostDataSourceImpl postDataSourceImpl;

  int baseType = 202;
  int docEntry = 0;
String quantity = "";
  var isLoading = false.obs;
  List<Map<String, dynamic>> headeritems = [];
var loading = false.obs;
  @override
  void onInit() {
    super.onInit();
    postDataSourceImpl = PostDataSourceImpl();
  }
  @override
  Future<dynamic> postreceipt() async{
    loading.value = true;
    try{
      print('post receipt for work order');
      print(quantity);

      List<DocumentLine> documentLines = headeritems.map((item) {
        return DocumentLine(
          baseType: baseType,
          baseEntry: docEntry,
          quantity: double.tryParse(quantity) ?? 0.0,

        //  quantity: double.parse(quantity),
          documentLinesBinAllocations: [
        DocumentLinesBinAllocation(
        binAbsEntry: item['binAbEntry'] ?? "",
          quantity: double.tryParse(quantity) ?? 0.0,

          // quantity: item['quantity'] ?? 0.00, // Ensure default value is of type double
        ),

        ],
        );
      }).toList();

      final postReceipt = PostReceiptModel(documentLines: documentLines);
     print(postReceipt);
      final response = await postDataSourceImpl.postReceiptData(postReceipt);
      var responseData;
      print('in receipt controller');
       response.fold(
            (failure) {
              responseData.clear();
              loading.value = false;

              print('Failure in receipt production : ${failure.message}');
              responseData = 'Failure: ${failure.message}';

            },
            (res) => responseData = res,


      );
      loading.value = false;
     print("in controller $responseData");
      return responseData;

    } catch (e) {
      print('Exception i con: $e');
      loading.value = false;

      throw Exception('Failed in receipt production in con: $e');
    }
  }

  void clearData() {
    headeritems.clear(); // Clear items list
  }
}
