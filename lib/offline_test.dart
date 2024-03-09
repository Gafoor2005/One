import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:one/features/home/screens/home_frame.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Demo1(),
    );
  }
}

class Demo1 extends StatefulWidget {
  const Demo1({Key? key}) : super(key: key);

  @override
  State<Demo1> createState() => _Demo1State();
}

class _Demo1State extends State<Demo1> {
  double top = 0;

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final connected = connectivity != ConnectivityResult.none;
        // final connected = false;

        return SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              AnimatedSwitcher(
                duration: const Duration(microseconds: 500),
                child: connected
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: const BoxDecoration(
                          color: Colors.white60,
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(15),
                            width: connected ? 0 : 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: connected
                                  ? const Color(0xFF00EE44)
                                  : const Color(0xFFEE4400),
                            ),
                            duration: const Duration(milliseconds: 350),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              child: connected
                                  ? const Text('ONLINE')
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'OFFLINE',
                                          style: TextStyle(
                                            fontFamily: "AlegreyaSans",
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        SizedBox(
                                          width: 12.0,
                                          height: 12.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
      child: const HomeFrame(),
    );
  }
}
