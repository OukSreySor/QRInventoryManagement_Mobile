import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CardData {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const CardData({
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
      padding: const EdgeInsets.all(8.0), 
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
              Icon(icon, color: iconColor, size: 16.0), 
              const SizedBox(width: 6.0), 
              Expanded( 
                child: Text(
                  title,
                  style: AppTextStyles.labelStyle.copyWith(fontSize: 11.0, fontWeight: FontWeight.bold), 
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
  final List<CardData> cards;
  final double cardWidth;

  const UserStatsCard({super.key, required this.cards, this.cardWidth = 130});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: cards.map((cardData) {
          return Container(
            width: cardWidth, 
            padding: const EdgeInsets.only(right: 8.0),
            child: InfoCard(
              icon: cardData.icon,
              title: cardData.title,
              value: cardData.value,
              iconColor: cardData.iconColor,
            ),
          );
        }).toList(),
      ),
    );
  }
}
