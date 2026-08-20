import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unit_converter/Model_/conversionRecord.dart';
import 'package:unit_converter/Model_/unitCategory.dart';
import 'package:unit_converter/ViewModel/UnitProvider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _valueController = TextEditingController();
  final FocusNode _valueFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _valueFocusNode.addListener(() {
      if (!_valueFocusNode.hasFocus) {
        context.read<Unitprovider>().logToHistory();
      }
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }

  void _onValueChanged(Unitprovider viewModel, String text) {
    final value = double.tryParse(text) ?? 0;
    viewModel.Convert(value);
  }

  void _loadRecord(Unitprovider viewModel, ConversionRecord record) {
    viewModel.applyHistoryRecord(record);
    _valueController.text = _formatNumber(record.inputValue);
  }

  void _loadFavorite(Unitprovider viewModel, FavoriteConversion fav) {
    viewModel.applyFavorite(fav);
  }

  String _formatNumber(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<Unitprovider>(context);
    final theme = Theme.of(context);
    final isDark = viewModel.isDarkMode;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF4F6F8);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              floating: true,
              pinned: true,
              title: Text(
                'Unit Converter',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () => viewModel.toggleTheme(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Category', subTextColor),
                    SizedBox(height: 8.h),
                    _categorySelector(viewModel, cardColor, textColor),
                    SizedBox(height: 20.h),

                    _sectionLabel('Value', subTextColor),
                    SizedBox(height: 8.h),
                    _valueInput(viewModel, cardColor, textColor),
                    SizedBox(height: 20.h),

                    _unitRow(viewModel, cardColor, textColor),
                    SizedBox(height: 20.h),

                    _resultCard(viewModel, cardColor, textColor, subTextColor),
                    SizedBox(height: 24.h),

                    if (viewModel.favorites.isNotEmpty) ...[
                      _sectionLabel('Favorites', subTextColor),
                      SizedBox(height: 8.h),
                      _favoritesList(viewModel, cardColor, textColor),
                      SizedBox(height: 24.h),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionLabel('History', subTextColor),
                        if (viewModel.history.isNotEmpty)
                          TextButton(
                            onPressed: () => viewModel.clearHistory(),
                            child: const Text('Clear'),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _historyList(viewModel, cardColor, textColor, subTextColor),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _card({required Widget child, required Color color}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _categorySelector(Unitprovider viewModel, Color cardColor, Color textColor) {
    return _card(
      color: cardColor,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Unitcategory>(
          value: viewModel.selectedCategory,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14.r),
          items: viewModel.categories
              .map(
                (cat) => DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      IconTheme(
                        data: IconThemeData(color: textColor),
                        child: cat.icon,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        cat.name,
                        style: GoogleFonts.aBeeZee(color: textColor),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (cat) {
            viewModel.ChangeCategory(cat!);
          },
        ),
      ),
    );
  }

  Widget _valueInput(Unitprovider viewModel, Color cardColor, Color textColor) {
    return _card(
      color: cardColor,
      child: TextField(
        controller: _valueController,
        focusNode: _valueFocusNode,
        style: TextStyle(color: textColor, fontSize: 16.sp),
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter a value',
        ),
        onChanged: (text) => _onValueChanged(viewModel, text),
        onSubmitted: (_) => viewModel.logToHistory(),
      ),
    );
  }

  Widget _unitRow(Unitprovider viewModel, Color cardColor, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _unitDropdown(
            value: viewModel.fromUnit,
            items: viewModel.selectedCategory.units.keys,
            cardColor: cardColor,
            textColor: textColor,
            onChanged: (val) => viewModel.setFromUnit(val!),
          ),
        ),
        SizedBox(width: 10.w),
        Material(
          color: Colors.transparent,
          child: IconButton(
            tooltip: 'Swap units',
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => viewModel.swapUnits(),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _unitDropdown(
            value: viewModel.toUnit,
            items: viewModel.selectedCategory.units.keys,
            cardColor: cardColor,
            textColor: textColor,
            onChanged: (val) => viewModel.setToUnit(val!),
          ),
        ),
      ],
    );
  }

  Widget _unitDropdown({
    required String value,
    required Iterable<String> items,
    required Color cardColor,
    required Color textColor,
    required ValueChanged<String?> onChanged,
  }) {
    return _card(
      color: cardColor,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14.r),
          items: items
              .map(
                (unit) => DropdownMenuItem(
                  value: unit,
                  child: Text(unit, style: GoogleFonts.aBeeZee(color: textColor)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _resultCard(Unitprovider viewModel, Color cardColor, Color textColor, Color subTextColor) {
    final resultText = viewModel.hasValue ? _formatNumber(viewModel.result) : '—';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Result',
                  style: GoogleFonts.aBeeZee(color: Colors.white70, fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$resultText ${viewModel.toUnit}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: viewModel.isCurrentFavorite ? 'Remove favorite' : 'Add favorite',
            icon: Icon(
              viewModel.isCurrentFavorite ? Icons.star : Icons.star_border,
              color: Colors.white,
            ),
            onPressed: () => viewModel.toggleFavorite(),
          ),
        ],
      ),
    );
  }

  Widget _favoritesList(Unitprovider viewModel, Color cardColor, Color textColor) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.favorites.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final fav = viewModel.favorites[index];
          return InputChip(
            backgroundColor: cardColor,
            label: Text(fav.label, style: TextStyle(color: textColor)),
            onPressed: () => _loadFavorite(viewModel, fav),
            onDeleted: () => viewModel.removeFavorite(fav),
            deleteIconColor: textColor,
          );
        },
      ),
    );
  }

  Widget _historyList(Unitprovider viewModel, Color cardColor, Color textColor, Color subTextColor) {
    if (viewModel.history.isEmpty) {
      return _card(
        color: cardColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Text(
            'Your recent conversions will show up here.',
            style: GoogleFonts.aBeeZee(color: subTextColor, fontSize: 13.sp),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.history.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final record = viewModel.history[index];
        return _card(
          color: cardColor,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(record.summary, style: TextStyle(color: textColor)),
            subtitle: Text(
              record.category,
              style: TextStyle(color: subTextColor, fontSize: 12.sp),
            ),
            trailing: Icon(Icons.restore, color: subTextColor),
            onTap: () => _loadRecord(viewModel, record),
          ),
        );
      },
    );
  }
}
