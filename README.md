# OneCard

## Introduction

---

OneCard is an Android application created to ease the use and management of store membership cards that are based on barcodes. The main purpose of the application is to enable the user to add, remove and use store membership cards. These functionalities are enhanced with the use of location services that provide the user with suggestions based on nearby stores.

## Components

---

### Screens

---


The application consists of two screens:
* main screen represented by `MainScreen`
* screen for adding cards represented by `AddCardScreen`.

#### Main screen
The purpose of the main screen is to list all the cards in two sections:
* Suggested - lists all cards that belong to nearby shops
* All - lists all the cards in two rows for a better view

This screen also uses few data sources which will be like data source for all the cards and location data.

#### Add card screen
This screen allows the user to enter the shop name and then using the local database and the service that manages it, finds the corresponding picture (or loads a generic one if no matches are found). This screen also uses the **barcode scanner** widget to allow the user to scan the card's barcode with a camera view.

### Widgets

---

#### `CustomBarcodeScanner`

This widget is created to join the functionalities of few dart packages and provide the app with an easy to use functions. The widget is able to scan a barcode using `barcode_scan` package and then display the result using the `barcode_widget` package. It is important to note that tying these two packages together is the `BarcodeService` which translates how each package refers to the different types of barcode standards.

#### `MarketCardDisplay`
Used to display the `MarketCard` model, it also features few enhancing functionalities. The widget is basically a card which can handle taps to show the the barcode in a popup dialog. When the dialog is shown, to provide better visibility the following code is executed:

``` dart
DeviceDisplayBrightness.setBrightness(0.85);

await showDialog(
    context: context, builder: (_) => _buildBarcodeDialog(context));

DeviceDisplayBrightness.setBrightness(_brightness);
```

Here the display brightness is set to 85% and when the dialog is closed it is reverted to the original brightness saved in the `_brightness` variable.

#### `MarketImagePicker`
The widget is used in the `AddCardScreen` to display all known markets or shops (cards for which there is a name and picture saved in the local DB).
It reuses the `MarketCardDisplay` in such a way that taps result the market name being returned instead of opening a barcode popup dialog. The data about known shops is pulled from the `MarketCardService`.

#### `Subtitle`

Simple widget that wraps a repetitive subtitle code and its properties which results in simple code throughout the application.

#### `WideButton`

Button which is reused in a few places in the app and simplifies updating of the layout of all its instances.

### Models

---

#### `MarketCard`
This is the main model which is used throughout the application to represent all data that consists a card. Beside its properties, the model has two methods that enable storing and reading the model to and from the database: 

``` dart
Map<String, dynamic> toMap() {
    return {
      'market_name': _marketName,
      'barcode': _barcode,
      'barcode_type': _barcodeType,
      'image_path': _imagePath
    };
}

  factory MarketCard.fromMap(Map<String, dynamic> map) => MarketCard(
      map['market_name'],
      map['barcode'],
      map['barcode_type'],
      map['image_path'],
      map['id']);
}
```

### Services

---

#### `BarcodeService`
A service that is used to translate barcode types to models and formats that the `barcode_scan` and `barcode_widget` packages use. This enables widgets such as `AddCardScreen` to use the `barcode_scan` package to scan a barcode then translate the barcode type and pass it along with the barcode data to the `barcode_widget` which displays the scanned barcode in its original format.

#### `DbService`
This service is responsible for initializing and interacting with the local database which is a SQLite instance. The service has an `_initDb` method which checks if the database is created, creates it if not, and the connects to it:

``` dart
_initDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cards.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE cards('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'market_name TEXT,'
          'barcode TEXT,'
          'barcode_type TEXT,'
          'image_path TEXT'
          ')',
        );
      },
      version: 1
    );
  }
```

This service like most of the others is a singleton, meaning only one shared instance is present in the app at all times. This is achieved with the following code snippet:

``` dart
static final DbService _dbService = DbService._private();

DbService._private();

factory DbService() {
    return _dbService;
}
```

#### `LocationService`
This service is responsible for filtering cards by location, meaning for all the cards that the user has saved, this service looks (by market name) if any of the cards are relevant in that area.

The service uses the `google_place` package which provides access to the Google Places API. After acquiring a Google Places API key the process of searching for nearby places is pretty straight forward. 

The following code snippet demonstrates how the app filters locally relevant cards:

``` dart
// cards are passed by the calling widget
Future<List<MarketCard>> filerNearbyPlaces(List<MarketCard> cards) async {
    List<MarketCard> nearbyMarkets = [];

    // current location is acquired through a helper method 
    Location currentLocation = await _getCurrentLocation();

    for (MarketCard card in cards) {
        var nearBySearchResponse = await _googlePlace.search.getNearBySearch(
            // search around this location
            currentLocation, 
            // with a radius of 50 meters
            50,
            // for the following keyword
            keyword: card.marketName.toLowerCase());

        //if there is an empty response skip rest of the for loop
        if (nearBySearchResponse == null ||
            nearBySearchResponse.results == null ||
            nearBySearchResponse.results!.isEmpty) {
        continue;
        }

        // check if one of the response items contains the market name
        for (var res in nearBySearchResponse.results!) {
        if (res.name!.toLowerCase().contains(card.marketName.toLowerCase())) {
            // if so, add the market to the filtered list
            nearbyMarkets.add(card);
        }
        }
    }

    if(nearbyMarkets.isEmpty) {
        throw Exception("No nearby places matching given cards found.");
    }

    return nearbyMarkets;
}
```

As we can see the app tries to find local places through the Google Places API that are possible matches for the cards we have. However results cannot be accurate every time as we are searching by the name only.

In this service is also the logic for retrieving the current location and asking the user for location permissions if the app is being used for the first time or the user has revoked the permissions.

``` dart
Future<Location> _getCurrentLocation() async {

    final loc.Location location = loc.Location();

    // check if the location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // if not, request access
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error(loc.PermissionStatus.denied);
      }
    }

    // check if user granted permissions before
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      // if not request permissions
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return Future.error(loc.PermissionStatus.denied);
      }
    }

    loc.LocationData locationData = await location.getLocation();

    return Location(lat: locationData.latitude, lng: locationData.longitude);
  }
```

#### `MarketCardService`

This service is at the center of most of what the application offers. It uses the described `DbService` to provide saving and retrieving of cards to and from the database. The service also provides some additional functionalities that support the rest of the application.

Because the `MarketCard` model does not contain a serialized image that is saved in the database but has only a path to that image, this service helps determine what that image path should be based on the card name.

``` dart
Future<String> _findImagePathForName(String name) async {
    // load paths for all images present in the app resources directory
    if (_imagePaths.isEmpty) {
        await _loadImagePaths();
    }

    // try to find a match by image name or return the generic image path
    return _imagePaths.firstWhere(
        (element) => element.toLowerCase().contains(name.toLowerCase()),
        orElse: () => "assets/images/other.png");
  }
```

The `_loadImagePaths` helper method:

``` dart
  Future _loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    _imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/images'))
        .toList();
  }
```

## Location Update Logic

---

Managing location updates is very important as frequent updates can greatly impact battery life. This is why some logic is needed as to when and how location will be checked and cards filtered by the new location.

This is managed by the main screen widget as the lowest widget in the widget hierarchy that calls the location service. This is important because only widgets have access to event methods that are executed in certain states of the app.

When the app is started the time is noted as follows

``` dart 
DateTime _lastLoadedSuggested = DateTime.now();
```
and is used as a starting reference for location updates. This means that restarting the app has the effect of triggering a location update.

The location is updated and cars are refiltered on the following widget lifecycle event.

``` dart 
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        DateTime.now().difference(_lastLoadedSuggested).inMinutes > 5) {
      _lastLoadedSuggested = DateTime.now();
      loadCards();
    }
  }
```

This means that if the app is left running in the background, on every open from recent apps, the widget checks if the app is being resumed and the last update was longer than 5 minutes ago. If so the location is updated and cards are filtered again by location.
