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
     return Column( 
      mainAxisSize: MainAxisSize.min, 
      children: [
        Row( 
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [
            Expanded( 
              child: Padding(
                padding: const EdgeInsets.all(4.0), 
                child: InfoCard(
                  icon: cards[0].icon,
                  title: cards[0].title,
                  value: cards[0].value,
                  iconColor: cards[0].iconColor,
                ),
              ),
            ),
            if (cards.length > 1)
              Expanded( 
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InfoCard(
                    icon: cards[1].icon,
                    title: cards[1].title,
                    value: cards[1].value,
                    iconColor: cards[1].iconColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2.0),
        if (cards.length > 2) 
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: [
              Expanded( 
                child: Padding(
                  padding: const EdgeInsets.all(4.0), 
                  child: InfoCard(
                    icon: cards[2].icon,
                    title: cards[2].title,
                    value: cards[2].value,
                    iconColor: cards[2].iconColor,
                  ),
                ),
              ),
              if (cards.length > 3) 
                Expanded( 
                  child: Padding(
                    padding: const EdgeInsets.all(4.0), 
                    child: InfoCard(
                      icon: cards[3].icon,
                      title: cards[3].title,
                      value: cards[3].value,
                      iconColor: cards[3].iconColor,
                    ),
                  ),
                ),
            ],
          ),
      ],
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
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.borderContainer, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 16.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue
            )
          ),
        ],
      ),
    );
  }
}

