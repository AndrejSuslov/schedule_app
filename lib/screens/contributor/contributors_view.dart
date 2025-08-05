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
      login: 'qhsdkx',
      avatarUrl: 'https://avatars.githubusercontent.com/u/122020647?v=4',
      htmlUrl: 'https://github.com/qhsdkx',
      contributions: 16,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
