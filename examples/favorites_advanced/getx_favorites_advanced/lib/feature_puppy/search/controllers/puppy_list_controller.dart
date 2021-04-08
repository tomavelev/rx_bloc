import 'dart:async';

import 'package:get/get.dart';

import 'package:favorites_advanced_base/repositories.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:getx_favorites_advanced/base/controllers/mediator_controller.dart';

class PuppyListController extends GetxController with StateMixin {
  PuppyListController(this._repository, this._mediatorController);

  final PuppiesRepository _repository;
  final MediatorController _mediatorController;

  final _puppies = <Puppy>[].obs;

  @override
  Future<void> onInit() async {
    change(_puppies, status: RxStatus.loading());
    await _initPuppies();
    super.onInit();
  }

  List<Puppy> searchedPuppies() => [..._puppies];

  Future<void> onReload() async {
    await _initPuppies();
    _mediatorController.clearFetchedExtraDetails();
  }

  void updatePuppiesWithExtraDetails(List<Puppy> puppiesToUpdate) {
    _puppies.mergeWith(puppiesToUpdate);
  }

  void onPuppyUpdated(List<Puppy> puppiesToUpdate) {
    puppiesToUpdate.forEach((puppy) {
      final currentIndex =
          _puppies.indexWhere((element) => element.id == puppy.id);
      _puppies.replaceRange(currentIndex, currentIndex + 1, [puppy]);
    });
  }

  Future<void> _initPuppies() async {
    try {
      final puppies = await _repository.getPuppies(query: '');
      _puppies.assignAll(puppies);
      change(_puppies, status: RxStatus.success());
    } catch (e) {
      change(_puppies, status: RxStatus.error(e.toString().substring(10)));
      print(e.toString());
    }
  }

  @override
  void onReady() {
    ever(_mediatorController.lastFetchedPuppies, (_) {
      updatePuppiesWithExtraDetails(
          _mediatorController.lastFetchedPuppies);
    });
    ever(_mediatorController.puppiesToUpdate, (_) {
      onPuppyUpdated(_mediatorController.puppiesToUpdate);
    });
    super.onReady();
  }
}
