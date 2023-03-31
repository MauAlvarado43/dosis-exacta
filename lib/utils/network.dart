import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { ONLINE, OFFLINE }

class NetworkStatusService {

  NetworkStatus getNetworkStatus(ConnectivityResult status) =>
      status == ConnectivityResult.mobile || status == ConnectivityResult.wifi
          ? NetworkStatus.ONLINE
          : NetworkStatus.OFFLINE;

}