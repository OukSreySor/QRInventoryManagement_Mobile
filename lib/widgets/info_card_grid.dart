import 'package:flutter/material.dart';
import '../theme/theme.dart';

class InfoCardData {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const InfoCardData({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });
}

class InfoCardGrid extends StatelessWidget {
  final List<InfoCardData> cards;

  const InfoCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 2.4,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return InfoCard(
          icon: card.icon,
          title: card.title,
          value: card.value,
          iconColor: card.iconColor,
        );
      },
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.borderContainer, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.0),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: AppTextStyles.labelStyle
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              value,
              style: AppTextStyles.valueStyle
            ),
          ),
        ],
      ),
    );
  }
}
