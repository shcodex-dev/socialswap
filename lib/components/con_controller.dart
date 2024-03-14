import 'package:get/get.dart';
import 'package:socialswap/models/coin.dart';
import 'package:http/http.dart' as http;

class CoinController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Coin> coinsList = <Coin>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchCoins();
  }

  fetchCoins() async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'));

      List<Coin> coins = coinFromJson(response.body);
      coinsList.value = coins;
    } finally {
      isLoading(false);
    }
  }
}
