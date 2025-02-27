import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/features/message/presentation/bloc/message_event.dart';
import 'package:heart_note/features/message/presentation/bloc/message_state.dart';
import 'package:heart_note/features/special_days/bloc/special_day_bloc.dart';
import 'package:heart_note/features/special_days/bloc/special_day_state.dart';
import '../bloc/message_bloc.dart';
import '../../../../core/bloc/theme_bloc.dart';
import '../widgets/category_list.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/message_category.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Heart Note'),
        trailing: GestureDetector(
          onTap: () => context.push('/settings'),
          child: const Icon(CupertinoIcons.settings),
        ),
      ),
      child: SafeArea(
        child: BlocListener<SpecialDayBloc, SpecialDayState>(
          listenWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          listener: (context, state) {
              context.read<MessageBloc>().add(LoadCategories());
          },
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoading) {
                return const Center(child: CupertinoActivityIndicator());
              }
              if (state is MessageLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state.customEvents != null && state.customEvents!.isNotEmpty)
                        CategoryList(
                          title: 'Sana Özel',
                          categories: state.customEvents!,
                        ),
                      CategoryList(
                        title: state.customEvents != null && state.customEvents!.isNotEmpty? 'Diğerleri' : null,
                        categories: state.categories,
                      ),
                    ],
                  ),
                );
              }
              if (state is MessageError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_circle,
                        size: 48,
                        color: CupertinoColors.destructiveRed,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
