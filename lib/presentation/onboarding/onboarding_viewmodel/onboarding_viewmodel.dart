import 'dart:async';

import 'package:clean_architecture/domin/models.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';

class OnboardingViewmodel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  StreamController<SliderViewObject> _streamController = StreamController();
  late final List<SliderObject> _list;
  int _currentIndex = 0;

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    _postDataToView();
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
    // TODO: implement goNext
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
    // TODO: implement goPrevious
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
    // TODO: implement onPageChanged
  }

  @override
  // TODO: implement inputSliderViewObject
  Sink get inputSliderViewObject => _streamController.sink;

  @override
  // TODO: implement outputSliderViewObject
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);
  //private functions
  List<SliderObject> _getSliderData() => [
        SliderObject(AppStrings.onBoardingSubTitle1,
            AppStrings.onBoardingSubTitle1, ImageAssets.onboardingLogo1),
        SliderObject(AppStrings.onBoardingSubTitle2,
            AppStrings.onBoardingSubTitle2, ImageAssets.onboardingLogo2),
        SliderObject(AppStrings.onBoardingSubTitle3,
            AppStrings.onBoardingSubTitle3, ImageAssets.onboardingLogo3),
        SliderObject(AppStrings.onBoardingSubTitle4,
            AppStrings.onBoardingSubTitle4, ImageAssets.onboardingLogo4)
      ];
  _postDataToView() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}

//orders recieved from view
mixin OnBoardingViewModelInputs {
  void goNext(); //right arrow
  void goPrevious(); //left arrow
  void onPageChanged(int index);
  Sink get inputSliderViewObject; //sink in
}

mixin OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject; //stream out
}
