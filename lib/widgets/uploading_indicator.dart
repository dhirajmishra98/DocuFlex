import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UploadingIndicator extends StatelessWidget {
  const UploadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SpinKitWaveSpinner(
          color: Colors.deepPurple.shade600,
          waveColor: Colors.deepPurple.shade300,
        ),
      );
  }
}