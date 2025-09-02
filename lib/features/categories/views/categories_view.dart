import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logo_widget.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          onPressed: () => Get.back(),
        ),
        title: const LogoWidget(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our clothing categories',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            
                         Expanded(
               child: GridView.builder(
                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                   crossAxisSpacing: 16,
                   mainAxisSpacing: 16,
                   childAspectRatio: 0.85,
                 ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final categories = [
                    {
                      'name': 'Streetwear',
                      'icon': Icons.style,
                      'color': const Color(0xFF4A90E2),
                      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=400&fit=crop',
                    },
                    {
                      'name': 'Casual Shirts',
                      'icon': Icons.checkroom,
                      'color': const Color(0xFF7ED321),
                      'image': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&h=400&fit=crop',
                    },
                    {
                      'name': 'Jerseys',
                      'icon': Icons.sports_soccer,
                      'color': const Color(0xFFF5A623),
                      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop',
                    },
                  ];
                  
                  final category = categories[index];
                  
                  return GestureDetector(
                    onTap: () {
                      final categoryName = category['name'] as String;
                      Get.toNamed('/category/${categoryName.toLowerCase().replaceAll(' ', '-')}');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                                             child: Column(
                         children: [
                           Expanded(
                             flex: 4,
                             child: Container(
                               width: double.infinity,
                               decoration: BoxDecoration(
                                 borderRadius: const BorderRadius.vertical(
                                   top: Radius.circular(16),
                                 ),
                                 image: DecorationImage(
                                   image: NetworkImage(category['image'] as String),
                                   fit: BoxFit.cover,
                                 ),
                               ),
                             ),
                           ),
                           Expanded(
                             flex: 3,
                             child: Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Container(
                                     padding: const EdgeInsets.all(6),
                                     decoration: BoxDecoration(
                                       color: (category['color'] as Color).withOpacity(0.1),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Icon(
                                       category['icon'] as IconData,
                                       color: category['color'] as Color,
                                       size: 20,
                                     ),
                                   ),
                                   const SizedBox(height: 6),
                                   Flexible(
                                     child: Text(
                                       category['name'] as String,
                                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                         fontWeight: FontWeight.bold,
                                         fontSize: 13,
                                       ),
                                       textAlign: TextAlign.center,
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
