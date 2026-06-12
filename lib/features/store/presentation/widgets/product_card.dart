library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/config/router.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.bestImagePath;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.pushProductDetail(product),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: ApiConfig.normalizeImageUrl(imageUrl),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              httpHeaders: const {'Host': ApiConfig.virtualHost},
                              placeholder: (_, _) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              errorWidget: (_, _, _) => Center(
                                child: Icon(
                                  Icons.pets,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.pets,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),

                  if (!product.inStock)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.l10n.outOfStock,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (product.hasPromotion)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${product.promotion!.discountValue.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (product.hasPromotion) ...[
                    Text(
                      'R\$ ${product.price}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      'R\$ ${product.displayPrice}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ] else
                    Text(
                      'R\$ ${product.displayPrice}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  if (product.averageRating != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          product.averageRating!.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          ' (${product.reviewsCount})',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
