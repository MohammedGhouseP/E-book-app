import 'package:flutter/material.dart';
import '../models/shelf_model.dart';
import '../utils/app_theme.dart';

class ShelfCard extends StatelessWidget {
  final Shelf shelf;
  final VoidCallback onTap;

  const ShelfCard({super.key, required this.shelf, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [AppColors.woodDark, AppColors.shelfShadow]
                : const [AppColors.wood, AppColors.woodDark],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.deepGold, width: 1.2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cream.withOpacity(0.18),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withOpacity(0.6)),
              ),
              child: Icon(shelf.icon, color: AppColors.cream, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              shelf.name,
              style: const TextStyle(
                color: AppColors.cream,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${shelf.bookCount} ${shelf.bookCount == 1 ? 'book' : 'books'}',
              style: TextStyle(
                color: AppColors.parchment.withOpacity(0.85),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
