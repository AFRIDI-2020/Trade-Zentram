import 'package:flutter/material.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/img_no_internet.jpg", width: MediaQuery.sizeOf(context).width/1.3,),
            const SizedBox(height: 20,),
            Text("Whoops!", style: theme.textTheme.displayMedium,),
            const SizedBox(height: 10,),
            Text("Slow or no internet connections!", style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey, fontSize: 16),),
            Text("Please check your internet connection.", style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey,fontSize: 16),),
            const SizedBox(height: 25,),
            ElevatedButton(onPressed: (){}, child: const Text("Try Again!")),
          ],
        ),
      ),
    );
  }
}
