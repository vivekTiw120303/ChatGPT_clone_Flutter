import 'package:flutter/material.dart';

class ThreeDots extends StatefulWidget{

  const ThreeDots({super.key});

  @override
  State<ThreeDots> createState() => _ThreeDotsState();
}

class _ThreeDotsState extends State<ThreeDots> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;

   int _currentIndex = 0;

   @override
  void initState() {

     super.initState();

     _animationController = AnimationController(
         vsync: this, duration: const Duration(milliseconds: 400)
     )..addStatusListener((status) {
       if(status == AnimationStatus.completed){
         _currentIndex++;
         if(_currentIndex == 3){
           _currentIndex = 0;
         }

         _animationController.reset();
         _animationController.forward();
       } // if - statement
     } // addStatusListener
     );
    _animationController!.forward();
  } // initState

   @override
  void dispose() {
     _animationController.dispose();
     super.dispose();
  } // dispose
  
  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child){
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index){
              return Opacity(
                  opacity: index == _currentIndex ? 1.0 : 0.2,
                child : const Text(
                  '.',
                  textScaleFactor: 5,
                ),
              );
            }
            ),
          );
        }
    );

  } // build
} // _ThreeDotsState