import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one/core/common/error_text.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/forms_controller.dart';
import 'package:one/features/home/screens/news.dart';
import 'package:one/features/home/screens/news_controller.dart';
import 'package:one/features/settings/screens/account_page.dart';
import 'package:routemaster/routemaster.dart';

Map<String, String> headers = {
  'Accept':
      'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
};
String sessionId = '';
String frmAuth = '';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userModel = ref.watch(userProvider)!;
    return Scaffold(
      // appBar: AppBar(
      //   leadingWidth: 70,
      //   leading: Row(
      //     children: [
      //       const SizedBox(
      //         width: 15,
      //       ),
      //       IconButton.filledTonal(
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //         icon: const Icon(Icons.menu),
      //       ),
      //     ],
      //   ),
      //   title: SvgPicture.asset('assets/icons/devloopers.svg'),
      //   titleSpacing: 0,
      // ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(21),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AccountPage())),
                    child: Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(userModel.profilePic),
                            // onBackgroundImageError: (exception, stackTrace) =>
                            //     showSnackBar(context, exception.toString()),
                            radius: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "AlegreyaSans",
                                  ),
                                ),
                                Text(
                                  userModel.rollNO ?? "null😅",
                                  style: const TextStyle(
                                    fontFamily: "Monospace",
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SideTitle(titleText: 'Forms'),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: ref.watch(formsProvider).when(
                        data: (forms) => Row(
                          children: forms
                              .map(
                                (form) => GestureDetector(
                                  onTap: () => Routemaster.of(context)
                                      .push("/form/${form.id}"),
                                  child: Container(
                                    padding: const EdgeInsets.all(19),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      // color: Color.fromRGBO(208, 208, 208, 0.39),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      // color: Colors.white,
                                      // border: Border.all(
                                      //     color: Colors.greenAccent,
                                      //     ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 3,
                                          spreadRadius: -1,
                                          color: Colors.black38,
                                        )
                                      ],
                                    ),
                                    clipBehavior: Clip.none,
                                    margin: const EdgeInsets.only(
                                      right: 10,
                                      bottom: 10,
                                    ),
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 16 * 1,
                                          child: Text(
                                            form.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontWeight: FontWeight.w800,
                                              // fontSize: 16,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          form.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            height: 1.4,
                                            // color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "${form.electiveId} | ${form.regulationId} | ${form.batch}-${form.batch + 4}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                fontFamily: 'NotoSans',
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const Loader(),
                      ),
                ),

                // const Text("data"),
                // ref.watch(bioProvider) == null
                //     ? ElevatedButton(
                //         onPressed: () {

                //           Routemaster.of(context).push("/demo");
                //         },
                //         child: const Text("get"),
                //       )
                //     : Column(
                //         children: [
                //           Text(ref.watch(bioProvider)!.name),
                //           Text(ref.watch(bioProvider)!.dob),
                //           Text(ref.watch(bioProvider)!.rollNo),
                //         ],
                //       ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _EventCardSeeMore extends StatelessWidget {
  const _EventCardSeeMore();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: 270,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.orange,
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            spreadRadius: -2,
            offset: Offset(1, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
          child: Text(
        'See more',
        style: TextStyle(
          fontFamily: 'AlegreyaSans',
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      )),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String month;
  final String eventTitle;
  final String? organizers;
  final String shortVenu;

  const EventCard({
    super.key,
    required this.date,
    required this.month,
    required this.eventTitle,
    this.organizers,
    required this.shortVenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: 270,
      height: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            spreadRadius: -2,
            offset: Offset(1, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            color: Colors.orange,
            width: 87,
            height: 87,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontFamily: "BlackHanSans",
                            fontSize: 35,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          month,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "BlackHanSans",
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventTitle,
                    style: const TextStyle(
                      fontFamily: "BlackHanSans",
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: organizers != null ? 1 : 2,
                  ),
                  organizers != null
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/micro_team.svg",
                              width: 15,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              organizers!,
                              style: const TextStyle(
                                fontFamily: "NotoSans",
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Color.fromRGBO(0, 0, 0, 0.48),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/micro_map.svg",
                        width: 15,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        shortVenu,
                        style: const TextStyle(
                          fontFamily: "NotoSans",
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomePageBanners extends StatefulWidget {
  const HomePageBanners({
    super.key,
    required this.constraints,
  });

  final BoxConstraints constraints;

  @override
  State<HomePageBanners> createState() => _HomePageBannersState();
}

class _HomePageBannersState extends State<HomePageBanners> {
  late ScrollController scrollController;
  late Timer timer;

  final banners = 3;
  int position = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();

    setTimer();
  }

  void setTimer() {
    timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      // debugPrint(timer.tick.toString());
      if (position < banners - 1) {
        position++;
      } else {
        position = 0;
      }
      scrollController.animateTo(
        (widget.constraints.maxWidth - 21) * position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragDown: (details) {
        // debugPrint("down");
        timer.cancel();
        Timer(const Duration(seconds: 10), () {
          // debugPrint("up");
          if (timer.isActive) timer.cancel();
          setTimer();
        });
      },
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          top: 21,
          left: 21,
          right: 21,
        ),
        child: Row(
          children: [
            Container(
              width: widget.constraints.maxWidth != 0
                  ? widget.constraints.maxWidth - 42
                  : 100,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text("The"),
              ),
            ),
            const SizedBox(
              width: 21,
            ),
            Container(
              width: widget.constraints.maxWidth - 42,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text("animated"),
              ),
            ),
            const SizedBox(
              width: 21,
            ),
            Container(
              width: widget.constraints.maxWidth - 42,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text("Banners"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideTitle extends StatelessWidget {
  final String titleText;
  const SideTitle({
    super.key,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 21.0,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider(),
          Text(
            titleText,
            style: const TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String desc;
  final String timestamp;
  const NewsCard({
    super.key,
    required this.title,
    required this.desc,
    required this.timestamp,
  });

  NewsCard.fromNews({super.key, required News news})
      : title = news.title,
        desc = news.description,
        timestamp = news.sentBy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        // color: Color.fromRGBO(208, 208, 208, 0.39),
        color: Theme.of(context).colorScheme.onSecondary,
        // color: Colors.white,
        // border: Border.all(
        //     color: Colors.greenAccent,
        //     ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: -1,
            color: Colors.black38,
          )
        ],
      ),
      clipBehavior: Clip.none,
      margin: const EdgeInsets.only(
        right: 10,
        bottom: 10,
      ),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16 * 1,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'AlegreyaSans',
                fontWeight: FontWeight.w800,
                fontSize: 16,
                height: 1,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            desc,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timestamp,
                style: const TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  // color: Color.fromRGBO(151, 115, 115, 1),
                  color: Colors.black45,
                ),
              ),
              // const Text(
              //   'read more',
              //   style: TextStyle(
              //     fontFamily: 'NotoSans',
              //     fontWeight: FontWeight.w800,
              //     fontSize: 12,
              //     color: Colors.black45,
              //     // decoration: TextDecoration.underline,
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
