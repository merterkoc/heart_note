import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/core/entities/special_day.dart';
import 'package:heart_note/features/special_days/bloc/special_day_bloc.dart';
import 'package:heart_note/features/special_days/bloc/special_day_event.dart';
import 'package:heart_note/features/special_days/bloc/special_day_state.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class SpecialDaysPage extends StatefulWidget {
  const SpecialDaysPage({Key? key}) : super(key: key);

  @override
  State<SpecialDaysPage> createState() => _SpecialDaysPageState();
}

class _SpecialDaysPageState extends State<SpecialDaysPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SpecialDayBloc>(context).add(LoadSpecialDays());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Özel Günler'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add),
              onPressed: () {
                _showAddSpecialDayDialog(context);
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.calendar_today),
              onPressed: () {
                BlocProvider.of<SpecialDayBloc>(context)
                    .add(ImportSpecialDays());
                _showImportSpecialDaysDialog(context);
              },
            ),
          ],
        ),
      ),
      child: BlocBuilder<SpecialDayBloc, SpecialDayState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (state.specialDays.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/special_days_not_found.json',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz özel gün eklenmemiş.\nSevdiklerinizle ilgili özel günleri ekleyin!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.specialDays.length,
                    itemBuilder: (context, index) {
                      final specialDay = state.specialDays[index];
                      return CupertinoListTile(
                        title: Text(specialDay.title),
                        subtitle: Text(
                            '${specialDay.date.day}/${specialDay.date.month}/${specialDay.date.year}'),
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.delete),
                          onPressed: () {
                            BlocProvider.of<SpecialDayBloc>(context)
                                .add(DeleteSpecialDay(index));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddSpecialDayDialog(BuildContext context) {
    String title = '';
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Modalın tam açılmasını önler
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: const Text('İptal'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoButton(
                            child: const Text('Ekle'),
                            onPressed: () {
                              if (title.isNotEmpty) {
                                final specialDay = SpecialDay(
                                    title: title, date: selectedDate);
                                BlocProvider.of<SpecialDayBloc>(context)
                                    .add(AddSpecialDay(specialDay));
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: CupertinoTextField(
                          placeholder: 'Başlık',
                          onChanged: (value) {
                            title = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: selectedDate,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              selectedDate = newDate;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showImportSpecialDaysDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<SpecialDayBloc, SpecialDayState>(
          builder: (context, state) {
            final importedSpecialDays = state.importedSpecialDays;
            final isCheckedList = state.isCheckedList;

            return CupertinoAlertDialog(
              title: const Text('Takvimden Özel Günleri İçe Aktar'),
              content: Column(
                children: [
                  const Text(
                      'Takvimden içe aktarılan özel günler aşağıda listelenmiştir. İçe aktarmak istediklerinizi seçebilirsiniz.'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: importedSpecialDays.length,
                      itemBuilder: (context, index) {
                        final specialDay = importedSpecialDays[index];
                        final isChecked = isCheckedList[index];

                        return Row(
                          children: [
                            CupertinoCheckbox(
                              checkColor: CupertinoColors.white,
                              tristate: true,
                              value: isChecked,
                              activeColor: CupertinoColors.destructiveRed,
                              onChanged: (bool? value) {
                                context.read<SpecialDayBloc>().add(
                                    UpdateIsChecked(
                                        index: index, value: value ?? false));
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    specialDay.title,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  Text(
                                    DateFormat("EEE, MMM d")
                                        .format(specialDay.date),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('İptal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('İçe Aktar'),
                  onPressed: () {
                    List<SpecialDay> selectedSpecialDays = [];
                    for (int i = 0; i < importedSpecialDays.length; i++) {
                      if (isCheckedList[i] == true) {
                        selectedSpecialDays.add(importedSpecialDays[i]);
                      }
                    }

                    BlocProvider.of<SpecialDayBloc>(context)
                        .add(SaveImportedSpecialDays(selectedSpecialDays));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
