import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heart_note/core/utils/ad_helper.dart';
import 'package:heart_note/features/message/presentation/bloc/history_bloc.dart';
import 'package:heart_note/features/message/presentation/bloc/history_event.dart';
import 'package:heart_note/features/message/presentation/bloc/history_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './history_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final AdHelper _adHelper = AdHelper.create();
  BannerAd? _bannerAd;

  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  Future<void> _deleteHistoryItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('message_history') ?? [];
    historyJson.removeAt(index);
    await prefs.setStringList('message_history', historyJson);

    context.read<HistoryBloc>().add(LoadHistory());
  }

  void _loadBannerAd() {
    final adUnitId = _adHelper.getAdUnitId(AdType.banner);
    if (adUnitId == null) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd opened.'),
        onAdClosed: (Ad ad) => print('$BannerAd closed.'),
      ),
    );

    _bannerAd!.load();
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          child: const Text('Mesajı Sil'),
        ),
        message: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.textStyle,
          child: const Text('Bu mesajı silmek istediğinizden emin misiniz?'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _deleteHistoryItem(index);
            },
            child: const Text('Sil'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Geçmiş'),
      ),
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return Column(
            children: [
              if (_isBannerAdReady)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              Expanded(
                child: SafeArea(
                  child: state is HistoryLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : state is HistoryLoaded
                          ? state.history.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.clock,
                                        size: 64,
                                        color: CupertinoColors.systemGrey,
                                      ),
                                      const SizedBox(height: 16),
                                      DefaultTextStyle(
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .navTitleTextStyle,
                                        child: const Text(
                                            'Henüz kaydedilmiş mesaj yok'),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: state.history.length,
                                  // Reklamları hesaba kat
                                  itemBuilder: (context, index) {
                                    final itemIndex = index;
                                    final item = state.history[itemIndex];

                                    return Dismissible(
                                      key: Key(item.createdAt.toString()),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: CupertinoColors.destructiveRed,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: const Icon(
                                          CupertinoIcons.delete,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                      confirmDismiss: (direction) async {
                                        _showDeleteConfirmation(
                                            context, itemIndex);
                                        return false;
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  HistoryDetailPage(
                                                message: item,
                                                index: itemIndex,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: CupertinoColors
                                                    .systemGrey4),
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                if (item.imageUrl != null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .horizontal(
                                                            left:
                                                                Radius.circular(
                                                                    12)),
                                                    child: SizedBox(
                                                      width: 120,
                                                      child: Image.memory(
                                                        base64Decode(
                                                            item.imageUrl!),
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Center(
                                                            child: Icon(
                                                              CupertinoIcons
                                                                  .photo_fill_on_rectangle_fill,
                                                              size: 48,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            DefaultTextStyle(
                                                              style: CupertinoTheme
                                                                      .of(context)
                                                                  .textTheme
                                                                  .navTitleTextStyle,
                                                              child: Text(item
                                                                  .category),
                                                            ),
                                                            const Spacer(),
                                                            DefaultTextStyle(
                                                              style: CupertinoTheme
                                                                      .of(context)
                                                                  .textTheme
                                                                  .tabLabelTextStyle,
                                                              child: Text(
                                                                  _formatDate(item
                                                                      .createdAt)),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        DefaultTextStyle(
                                                          style:
                                                              CupertinoTheme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .textStyle,
                                                          child: Text(
                                                            item.message,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Wrap(
                                                          spacing: 8,
                                                          children: item
                                                              .keywords
                                                              .map((keyword) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          4),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: CupertinoColors
                                                                    .systemGrey6,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child:
                                                                  DefaultTextStyle(
                                                                style: CupertinoTheme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .tabLabelTextStyle,
                                                                child: Text(
                                                                    keyword),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                          : const SizedBox(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
