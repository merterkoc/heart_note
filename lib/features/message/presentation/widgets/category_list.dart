import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/message_category.dart';

class CategoryList extends StatelessWidget {
  final List<MessageCategory> categories;

  const CategoryList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Icon(
              category.icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              category.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(category.description),
            ),
            onTap: () {
              context.push('/note/${category.title}', extra: category);
            },
          ),
        );
      },
    );
  }
}
