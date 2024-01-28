import 'package:flutter/material.dart';
import 'package:flutter_test_project/widgets/typography.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.serviceTitle,
    required this.serviceIcon,
    this.onServiceTap,
    this.serviceUrl,
    this.serviceDescription,
    this.launchMode = LaunchMode.externalApplication,
  }) : super(key: key);

  final String serviceTitle;
  final String? serviceUrl;
  final Widget serviceIcon;
  final LaunchMode launchMode;
  final String? serviceDescription;
  final VoidCallback? onServiceTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 156, maxHeight: 192),
      child: Card(
        // color: AppTheme.colors.background02,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (onServiceTap != null) {
              onServiceTap!();
              return;
            }
            if (this.serviceUrl == null) {
              return;
            }
            final Uri url = Uri.parse(this.serviceUrl!);
            launchUrl(url, mode: launchMode);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                serviceIcon,
                const SizedBox(height: 12),
                Text(
                  serviceTitle,
                  style: Style.bodyBold.copyWith(
                      // color: AppTheme.colors.active,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (serviceDescription != null) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      serviceDescription!,
                      style: Style.body.copyWith(
                        //  color: Color(0xFF5E6272),
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
