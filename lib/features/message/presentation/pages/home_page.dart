import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/message_bloc.dart';
import '../../../../core/bloc/theme_bloc.dart';
import '../widgets/category_list.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Heart Note'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleTheme());
                  },
                  child: Icon(
                    state.themeMode == ThemeMode.light
                        ? CupertinoIcons.moon
                        : CupertinoIcons.sun_max,
                  ),
                );
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.push('/history'),
              child: const Icon(CupertinoIcons.clock),
            ),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is MessageLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is MessageLoaded) {
              return CategoryList(categories: state.categories);
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
    );
  }
}
