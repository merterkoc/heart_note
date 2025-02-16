import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/message_bloc.dart';
import '../../../../core/bloc/theme_bloc.dart';
import '../widgets/category_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Note'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleTheme());
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            );
          }
          if (state is MessageLoaded) {
            return CategoryList(categories: state.categories);
          }
          if (state is MessageError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new note creation
        },
        tooltip: 'New Note',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
