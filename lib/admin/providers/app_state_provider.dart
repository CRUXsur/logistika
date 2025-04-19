import 'package:flutter/material.dart' show AppLifecycleState;

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Lo que yo quiero almacenar aquí son estos valores, estos posibles valores;
/*
    |  resumed
    |  inactive
    |  paused
    |  detached
    */

final AppStateProvider = StateProvider<AppLifecycleState>((ref){
  return AppLifecycleState.resumed;
});
