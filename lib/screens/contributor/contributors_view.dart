import 'package:flutter/material.dart';

import 'package:flutter_test_project/screens/contributor/contributor.dart';
import 'package:flutter_test_project/screens/contributor/contributor_card.dart';

class ContributorsView extends StatelessWidget {
  ContributorsView({Key? key}) : super(key: key);

  final List<Contributor> contributors = [
    const Contributor(
      login: 'kladvirov',
      avatarUrl: 'https://avatars.githubusercontent.com/u/119174242?v=4',
      htmlUrl: 'https://github.com/kladvirov',
      contributions: 19,
    ),
    const Contributor(
      login: 'AndrejSuslov',
      avatarUrl: 'https://avatars.githubusercontent.com/u/122020647?v=4',
      htmlUrl: 'https://github.com/AndrejSuslov',
      contributions: 16,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<ContributorsBloc, ContributorsState>(
    //   listener: (context, state) {
    //     if (state.status == ContributorsStatus.failure) {
    //       ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(
    //           const SnackBar(
    //             content: Text('Ошибка при загрузке контрибьюторов'),
    //           ),
    //         );
    //     }
    //   },
    //   builder: (context, state) {
    //     if (state.status == ContributorsStatus.loading) {
    //       return SizedBox(
    //         height: 177,
    //         child: ListView.builder(
    //           physics: const NeverScrollableScrollPhysics(),
    //           padding: const EdgeInsets.symmetric(horizontal: 24),
    //           scrollDirection: Axis.horizontal,
    //           itemCount: 10,
    //           itemBuilder: (context, index) {
    //             return const SkeletonContributorCard();
    //           },
    //         ),
    //       );
    //     } else if (state.status == ContributorsStatus.loaded) {
    //       return SizedBox(
    return SizedBox(
      height: 177,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          final contributor = contributors[index];
          return ContributorCard(contributor: contributor);
        },
      ),
    );
  }
}
