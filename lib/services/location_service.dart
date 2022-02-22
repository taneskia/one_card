import 'package:google_place/google_place.dart';
import 'package:location/location.dart' as loc;

import '../models/market_card.dart';

class LocationService {
  static final LocationService _locationService = LocationService._private();
  static final GooglePlace _googlePlace =
      GooglePlace("AIzaSyBmn6M_QGSyOi2mLZ8r9-t22FwRYSd99k4");

  LocationService._private();

  factory LocationService() {
    return _locationService;
  }

  Future<List<MarketCard>> filerNearbyPlaces(List<MarketCard> cards) async {
    List<MarketCard> nearbyMarkets = [];

    Location currentLocation = await _getCurrentLocation();

    for (MarketCard card in cards) {
      var nearBySearchResponse = await _googlePlace.search.getNearBySearch(
          currentLocation, 50,
          keyword: card.marketName.toLowerCase());

      if (nearBySearchResponse!.results!.isEmpty) {
        continue;
      }

      for (var res in nearBySearchResponse.results!) {
        if (res.name!.toLowerCase().contains(card.marketName.toLowerCase())) {
          nearbyMarkets.add(card);
        }
      }
    }

    return nearbyMarkets;
  }

  Future<Location> _getCurrentLocation() async {
    final loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error(loc.PermissionStatus.denied);
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return Future.error(loc.PermissionStatus.denied);
      }
    }

    loc.LocationData locationData = await location.getLocation();

    return Location(lat: locationData.latitude, lng: locationData.longitude);
  }
}
