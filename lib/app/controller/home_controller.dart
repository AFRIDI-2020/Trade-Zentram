import 'package:get/get.dart';
import 'package:TradeZentrum/app/repository/home_repository.dart';
import 'package:TradeZentrum/app/services/api_env.dart';
import 'package:TradeZentrum/app/utils/const_funtion.dart';

class HomeController extends GetxController {
  HomeRepository homeRepository = HomeRepository();
  final ApiUrl _apiUrl = ApiUrl();

  RxList taskDataList = [].obs;
  RxBool isFetchTaskData = false.obs;

  @override
  void onInit() async {
    super.onInit();
    listenToLocationUpdates(control: "home", homeController: this);
    getTasks(endPoint: _apiUrl.getTasks);
  }

  getTasks({
    String? endPoint,
  }) async {
    startLoading();
    var response = await homeRepository.getTasks(
      endPoint: endPoint!,
    );
    isFetchTaskData.value = true;
    taskDataList.value = response["data"];
    endLoading();
  }
}
