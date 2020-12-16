import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quran/main.dart';

class QiblaaPage extends StatefulWidget {
  @override
  _QiblaaPageState createState() => _QiblaaPageState();
}

class _QiblaaPageState extends State<QiblaaPage> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    _checkLocationStatus();

    super.initState();
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();

    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final status = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(status);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationStreamController.close();
    FlutterQiblah().dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'اتجاه القبلة',
        context: context,
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          print(snapshot.data?.status);
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingIndicator();
          if (snapshot.data.enabled == true) {
            switch (snapshot.data.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return QiblahCompassWidget();

              case LocationPermission.denied:
                return LocationEnabledWidget(
                  title: 'لقد تم رفض صلاحية الوصول للموقع',
                  message: 'اضفط على الزر بالاسفل لمنح الصلاحية وعرض القبلة',
                  callback: () async {
                    await Geolocator.openLocationSettings();

                  },
                );
              case LocationPermission.deniedForever:
                return LocationEnabledWidget(
                  title: 'لقد تم رفض صلاحية الوصول للموقع للابد',
                  message: 'قم بالذهاب الى الاعدادات لاعادة منح الصلاحية',
                  callback: () async {
                   await Geolocator.openLocationSettings();

                  },
                );
              default:
                return Container();
            }
          } else {
            return LocationEnabledWidget(
              title: 'لقد تم رفض صلاحية الوصول للموقع',
              message: 'اضفط على الزر بالاسفل لمنح الصلاحية وعرض القبلة',
              callback: () async {
                await Geolocator.openLocationSettings();

              },
            );
          }
        },
      ),
    );
  }
}

class LocationEnabledWidget extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  final String message;

  const LocationEnabledWidget({
    Key key,
    this.callback,
    this.title,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/ic_compass.svg'),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
            callback == null
                ? Container()
                : OutlinedButton(
                    onPressed: () {
                      callback();
                    },
                    child: Text('اضغظ لمنح صلاحية الوصول للموقع'))
          ],
        ),
      ),
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  final _compassSvg = SvgPicture.asset('assets/compass.svg');
  final _needleSvg = SvgPicture.asset(
    'assets/needle.svg',
    fit: BoxFit.contain,
    height: 300,
    alignment: Alignment.center,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingIndicator();

        final qiblahDirection = snapshot.data;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: ((qiblahDirection.direction ?? 0) * (pi / 180) * -1),
              child: _compassSvg,
            ),
            Transform.rotate(
              angle: ((qiblahDirection.qiblah ?? 0) * (pi / 180) * -1),
              alignment: Alignment.center,
              child: _needleSvg,
            ),
            Positioned(
              bottom: 8,
              child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
            )
          ],
        );
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widget = (Platform.isAndroid)
        ? CircularProgressIndicator()
        : CupertinoActivityIndicator();
    return Container(
      alignment: Alignment.center,
      child: widget,
    );
  }
}

class LocationErrorWidget extends StatelessWidget {
  final String error;
  final Function callback;

  const LocationErrorWidget({Key key, this.error, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(height: 32);
    final errorColor = Color(0xffb00020);

    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.location_off,
              size: 150,
              color: errorColor,
            ),
            box,
            Text(
              error,
              style: TextStyle(color: errorColor, fontWeight: FontWeight.bold),
            ),
            box,
            RaisedButton(
              child: Text("Retry"),
              onPressed: () {
                if (callback != null) callback();
              },
            )
          ],
        ),
      ),
    );
  }
}
