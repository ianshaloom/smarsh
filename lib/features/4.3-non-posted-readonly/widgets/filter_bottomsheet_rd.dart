import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../constants/hive_constants.dart';
import '../../../services/hive/models/item_count/filter_model.dart';

class FilterRd extends StatefulWidget {
  final Function onFilter;
  const FilterRd({super.key, required this.onFilter});

  @override
  State<FilterRd> createState() => _FilterRdState();
}

class _FilterRdState extends State<FilterRd> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: HiveBoxes.getFilterBox().listenable(),
        builder: (context, Box<FilterModel> box, _) {
          final FilterModel filter = box.values.first;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            height: 290,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Filter Non-Posted Items',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          // fontWeight: FontWeight.w500,
                          fontSize: 18,
                        )),
                const SizedBox(height: 20),
                _filterTile(filter, 'All', filter.isAll, onChanged),
                _filterTile(
                    filter, 'Missing Items', filter.isMissing, onChanged),
                _filterTile(filter, 'Excess Items', filter.isExcess, onChanged),
                _filterTile(filter, 'Intact Items', filter.isIntact, onChanged),
              ],
            ),
          );
        });
  }

  // return checkboxListTile
  Widget _filterTile(
      FilterModel filter, String title, bool value, Function onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (value) {
        onChanged(filter, value, title);
      },
    );
  }

  void onChanged(FilterModel filter, bool value, String title) async {
    switch (title) {
      case 'All':
        widget.onFilter('all');
        filter.isAll = value;
        filter.isExcess = false;
        filter.isIntact = false;
        filter.isMissing = false;
        await filter.save();
        break;
      case 'Missing Items':
        widget.onFilter('missing');
        filter.isMissing = value;
        filter.isAll = false;
        filter.isExcess = false;
        filter.isIntact = false;
        await filter.save();
        break;
      case 'Excess Items':
        widget.onFilter('excess');
        filter.isExcess = value;
        filter.isAll = false;
        filter.isIntact = false;
        filter.isMissing = false;
        await filter.save();
        break;
      case 'Intact Items':
        widget.onFilter('intact');
        filter.isIntact = value;
        filter.isAll = false;
        filter.isExcess = false;
        filter.isMissing = false;
        await filter.save();
        break;
    }
  }
}
