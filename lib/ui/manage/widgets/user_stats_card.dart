import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

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
      padding: const EdgeInsets.all(12.0), 
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderContainer, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.0), 
              const SizedBox(width: 6.0), 
              Expanded( 
                child: Text(
                  title,
                  style: AppTextStyles.labelStyle.copyWith(fontSize: 12.0, fontWeight: FontWeight.bold), 
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              value,
              style: AppTextStyles.valueStyle.copyWith(fontSize: 16.0), 
            ),
          ),
        ],
      ),
    );
  }
}

class UserStatsCard extends StatelessWidget {
  final List<InfoCardData> cards;

  const UserStatsCard({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards.map((cardData) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InfoCard(
              icon: cardData.icon,
              title: cardData.title,
              value: cardData.value,
              iconColor: cardData.iconColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}
