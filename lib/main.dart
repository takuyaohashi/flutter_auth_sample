import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'auth/authenticator.dart';

void main() => runApp(
      Provider<Authenticator>(
        builder: (_) => Authenticator(),
        child: const App(),
      ),
    );
