import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import '../models/book_model.dart';
import '../utils/app_theme.dart';

enum ReaderLayout { sideBySide, tabbed }

enum LanguageMode { both, englishOnly, urduOnly }

class DualLanguageReader extends StatefulWidget {
  final Chapter chapter;
  final ReaderLayout layout;
  final LanguageMode languageMode;
  final double fontSize;

  const DualLanguageReader({
    super.key,
    required this.chapter,
    required this.layout,
    required this.languageMode,
    required this.fontSize,
  });

  @override
  State<DualLanguageReader> createState() => _DualLanguageReaderState();
}

class _DualLanguageReaderState extends State<DualLanguageReader>
    with SingleTickerProviderStateMixin {
  late LinkedScrollControllerGroup _group;
  late ScrollController _englishCtrl;
  late ScrollController _urduCtrl;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _group = LinkedScrollControllerGroup();
    _englishCtrl = _group.addAndGet();
    _urduCtrl = _group.addAndGet();
    if (widget.layout == ReaderLayout.tabbed) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void didUpdateWidget(covariant DualLanguageReader old) {
    super.didUpdateWidget(old);
    if (widget.layout != old.layout) {
      _tabController?.dispose();
      _tabController = widget.layout == ReaderLayout.tabbed
          ? TabController(length: 2, vsync: this)
          : null;
    }
  }

  @override
  void dispose() {
    _englishCtrl.dispose();
    _urduCtrl.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layout == ReaderLayout.tabbed) {
      return _buildTabbed(context);
    }
    return _buildSideBySide(context);
  }

  Widget _buildSideBySide(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final showEn = widget.languageMode != LanguageMode.urduOnly;
    final showUr = widget.languageMode != LanguageMode.englishOnly;

    if (showEn && !showUr) {
      return _englishColumn(brightness);
    }
    if (showUr && !showEn) {
      return _urduColumn(brightness);
    }

    return Row(
      children: [
        Expanded(child: _englishColumn(brightness)),
        const VerticalDivider(width: 1),
        Expanded(child: _urduColumn(brightness)),
      ],
    );
  }

  Widget _buildTabbed(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Column(
      children: [
        Material(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.gold,
            labelColor: AppColors.cream,
            unselectedLabelColor: AppColors.parchment,
            tabs: const [
              Tab(text: 'English'),
              Tab(text: 'اردو'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _englishColumn(brightness, linked: false),
              _urduColumn(brightness, linked: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _englishColumn(Brightness brightness, {bool linked = true}) {
    return SingleChildScrollView(
      controller: linked ? _englishCtrl : null,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.chapter.title,
            style: TextStyle(
              fontFamily: 'Lora',
              fontSize: widget.fontSize + 4,
              fontWeight: FontWeight.w700,
              color: brightness == Brightness.light
                  ? AppColors.darkMahogany
                  : AppColors.gold,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            widget.chapter.englishText,
            style: AppTheme.englishReadingStyle(widget.fontSize, brightness),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _urduColumn(Brightness brightness, {bool linked = true}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        controller: linked ? _urduCtrl : null,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chapter.title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'NotoNastaliqUrdu',
                fontSize: widget.fontSize + 6,
                fontWeight: FontWeight.w700,
                color: brightness == Brightness.light
                    ? AppColors.darkMahogany
                    : AppColors.gold,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.chapter.urduText,
              textAlign: TextAlign.right,
              style: AppTheme.urduReadingStyle(widget.fontSize, brightness),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
