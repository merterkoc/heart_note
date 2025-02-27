import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/message_category.dart';

class CategoryList extends StatelessWidget {
  final List<MessageCategory> categories;
  final String? title;

  const CategoryList({
    super.key,
    required this.categories,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Text(
            title!,
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () =>
                    context.push('/note/${category.title}', extra: category),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              category.icon,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.title,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle
                                  .copyWith(),
                            ),
                            const Spacer(),
                            const Icon(
                              CupertinoIcons.chevron_right,
                            ),
                          ],
                        ),
                        if (category.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(category.description,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .tabLabelTextStyle),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
