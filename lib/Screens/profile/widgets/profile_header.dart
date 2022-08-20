import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                
                
                
                borderRadius: BorderRadius.circular(40),
              ),
              child:const CircleAvatar(
                backgroundColor: Color(0xff1F1D2B),
                child: Icon(Icons.person,size: 55),
              ),
            ),
            Consumer<ProfileChangeNotifier>(
              builder: (context, profileNotifier, _) {
                var state = profileNotifier.profile;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      width: 200,
                      child: Text(
                        state.firstName.isEmpty
                            ? 'Name'
                            : '${state.firstName} ${state.middleName} ${state.lastName}',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    
                  ],
                );
              },
            ),
          ],
        ),
       const SizedBox(height: 10,),
        Consumer<ProfileChangeNotifier>(
              builder: (context, profileNotifier, _) {
                var states = profileNotifier.profile;

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:30),
                  child: Text(
                                'Referral Code: ${states.referalCode}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                ),
                            IconButton(onPressed:(){},icon:const Icon(Icons.copy,color: Colors.white,size: 20,),),
                             IconButton(onPressed:(){},icon:const Icon(Icons.share,color: Colors.white,size: 20,),),
              ],
            );
          },
        ),
      ],
    );
  }
}
