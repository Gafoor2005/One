// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:one/core/common/error_text.dart';
import 'package:one/core/models/regulation_model.dart';
import 'package:one/features/home/screens/forms_controller.dart';
import 'package:one/features/home/screens/forms_repository.dart';
import 'package:routemaster/routemaster.dart';

class RegulationsPage extends ConsumerWidget {
  const RegulationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regulations"),
      ),
      body: SafeArea(
        child: ref.watch(regulationProvider).when(
              data: (data) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == data.length) {
                      return ListTile(
                        title: const Text("add new Regulation"),
                        leading: const Icon(Icons.add_circle),
                        onTap: () {
                          Routemaster.of(context)
                              .push("/regulations/create-regulation");
                        },
                      );
                    }
                    return _RegulationCard(
                      regulation: data[index],
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () => Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Theme.of(context).colorScheme.onSecondary,
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lorem ipsum dolor sit amet.",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'FlowCircular',
                        fontSize: 16,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto beatae laudantium commodi tempora accusantium incidunt.",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'FlowCircular',
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Lorem, ipsum.",
                          style: TextStyle(
                            fontFamily: 'FlowCircular',
                            fontSize: 12,
                            // color: Color.fromRGBO(151, 115, 115, 1),
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _RegulationCard extends ConsumerWidget {
  final Regulation regulation;
  const _RegulationCard({
    required this.regulation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        onTap: () async {
          Routemaster.of(context).push("/regulations/${regulation.id}");
          // ref
          //     .watch(formsRepositoryProvider)
          //     .getElectives(regulation.id)
          //     .listen((event) {
          //   event.forEach((element) {
          //     log(element.toString());
          //   });
          // });
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              regulation.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "NotoSans",
              ),
            ),
            Text(
              "${regulation.startYear} - ${regulation.startYear + regulation.lifeSpan - 1}",
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: "NotoSans",
              ),
            ),
          ],
        ));
  }
}
