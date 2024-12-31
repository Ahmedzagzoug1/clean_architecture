import 'package:clean_architecture/domin/models.dart';
import 'package:clean_architecture/presentation/onboarding/onboarding_viewmodel/onboarding_viewmodel.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/constants_manager.dart';
import 'package:clean_architecture/presentation/resources/routes_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/value_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final OnboardingViewmodel _viewmodel = OnboardingViewmodel();
  final PageController _pageController = PageController(initialPage: 0);
  _bind() {
    _viewmodel.start();
  }

  @override
  void initState() {
    _bind();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return StreamBuilder<SliderViewObject>(
        stream: _viewmodel.outputSliderViewObject,
        builder: (context, snapshot) {
          return _getContentWidget(snapshot.data);
        });
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarBrightness: Brightness.dark),
        ),
        body: PageView.builder(
            controller: _pageController,
            itemCount: sliderViewObject.numberOfSlider,
            onPageChanged: (index) {
              _viewmodel.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              return OnBoardingPage(sliderViewObject.sliderObject);
            }),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(
                    AppStrings.skip,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),

              // widgets indicator and arrows
              _getBottomSheetWidget(sliderViewObject)
            ],
          ),
        ),
      );
    }
  
   
}
  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // left arrow
        Padding(
          padding: EdgeInsets.all(AppPadding.p14),
          child: GestureDetector(
            child: SizedBox(
              height: AppSize.s20,
              width: AppSize.s20,
              child: SvgPicture.asset(ImageAssets.leftArrowIc),
            ),
            onTap: () {
              _pageController.animateToPage(
                _viewmodel.goPrevious(),duration: Duration(milliseconds: AppConstants.sliderAnimationTime),
                curve: Curves.bounceInOut);
              // go to next slide
            },
          ),
        ),

        // circles indicator
           Row(
            children: [
              for (int i = 0; i < sliderViewObject.numberOfSlider; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject.currentSlider),
                )
            ],
          ),
        // right arrow
        Padding(
          padding: EdgeInsets.all(AppPadding.p14),
          child: GestureDetector(
            child: SizedBox(
              height: AppSize.s20,
              width: AppSize.s20,
              child: SvgPicture.asset(ImageAssets.rightarrowIc),
            ),
            onTap: () {
              
              _pageController.animateToPage(
                _viewmodel.goNext(),duration: Duration(milliseconds: AppConstants.sliderAnimationTime),
                curve: Curves.bounceInOut);
              // go to next slide
            },
          ),
        )
      ],
    );
  }

  Widget _getProperCircle(int index, int currentSlider, ) {
    if (index == currentSlider) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc); // selected slider
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc); // unselected slider
    }
  }

  
  @override
  void dispose() {
    _viewmodel.dispose();
    super.dispose();
  }
}


class OnBoardingPage extends StatelessWidget {
  SliderObject _sliderObject;

  OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(
          height: AppSize.s60,
        ),
        SvgPicture.asset(_sliderObject.image)
      ],
    );
  }
  
  
}
