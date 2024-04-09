import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/core/common/loader.dart';
import 'package:one/core/models/regulation_model.dart';
import 'package:one/features/home/screens/forms_controller.dart';
import 'package:one/features/home/screens/forms_repository.dart';
import 'package:routemaster/routemaster.dart';

class ElectivesPage extends ConsumerWidget {
  final String regulationId;
  const ElectivesPage({
    super.key,
    required this.regulationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(singleRegulationProvider(regulationId)).when(
          data: (regulation) {
            return Scaffold(
              appBar: AppBar(
                title: Text(regulation.name),
              ),
              body: ref.watch(electivesProvider(regulationId)).when(
                    data: (electives) {
                      if (electives.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "no electives\nList is empty",
                                textAlign: TextAlign.center,
                              ),
                              TextButton(
                                onPressed: () {
                                  Routemaster.of(context).push(
                                      "/regulations/$regulationId/create-elective");
                                },
                                child: Text("create one"),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: electives.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(electives[index].name),
                            subtitle: Text(electives[index].type.name),
                            onTap: () {
                              Routemaster.of(context).push(
                                  "/regulations/$regulationId/${electives[index].id}");
                            },
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Text("error: ${error.toString()}"),
                    loading: () => const Loader(),
                  ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Routemaster.of(context)
                      .push("/regulations/$regulationId/create-elective");
                },
                tooltip: "create elective",
                label: const Text("add elective"),
                icon: const Icon(Icons.add),
              ),
            );
          },
          error: (error, stackTrace) => Text("error ${error.toString()}"),
          loading: () => const Loader(),
        );
  }
}
