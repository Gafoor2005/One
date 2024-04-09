// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/features/home/screens/forms_controller.dart';
import 'package:one/features/home/screens/my_ids.dart';
import 'package:routemaster/routemaster.dart';

class SubjectsPage extends ConsumerWidget {
  final String regulationId;
  final String electiveId;
  const SubjectsPage({
    super.key,
    required this.regulationId,
    required this.electiveId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(singleRegulationProvider(regulationId)).when(
          data: (regulation) {
            return ref
                .watch(electiveProvider(
                    MyIds(regulationId: regulationId, electiveId: electiveId)
                        .toJson()))
                .when(
                  data: (elective) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('${regulation.name} / ${elective.name}'),
                      ),
                      body: ref
                          .watch(subjectsProvider(MyIds(
                                  regulationId: regulationId,
                                  electiveId: electiveId)
                              .toJson()))
                          .when(
                            data: (subjects) {
                              if (subjects.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "no subjects\nList is empty",
                                        textAlign: TextAlign.center,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Routemaster.of(context).push(
                                              "/regulations/$regulationId/$electiveId/create");
                                        },
                                        child: Text("create one"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: subjects.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    trailing: Wrap(
                                      children: [
                                        Icon(Icons.people),
                                        Text("${subjects[index].limit}"),
                                      ],
                                    ),
                                    title: Text(
                                      subjects[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "Offered by ",
                                          ),
                                          TextSpan(
                                            text: subjects[index]
                                                .offeredBy
                                                .name
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {},
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) =>
                                Text("error: ${error.toString()}"),
                            loading: () => const Loader(),
                          ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Routemaster.of(context).push(
                              "/regulations/$regulationId/$electiveId/create");
                        },
                        tooltip: "add subject",
                        child: const Icon(Icons.add),
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      Text("error ${error.toString()}"),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => Text("error ${error.toString()}"),
          loading: () => const Loader(),
        );
  }
}
