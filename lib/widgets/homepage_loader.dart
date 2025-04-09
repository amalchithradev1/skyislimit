import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProfileTabView extends StatelessWidget {
  const ShimmerProfileTabView({super.key});

  Widget shimmerItem({double height = 16, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100,),
            CircleAvatar(radius: 40, backgroundColor: Colors.white),
            const SizedBox(height: 16),
            shimmerItem(width: 280),
            const SizedBox(height: 12),
            shimmerItem(width: 350),
            const SizedBox(height: 12),
            shimmerItem(width: 180),
            const SizedBox(height: 12),
            shimmerItem(width: 180),
            const SizedBox(height: 12),
            shimmerItem(width: 320),
            const SizedBox(height: 12),
            shimmerItem(width: 160),
          ],
        ),
      ),
    );
  }
}
