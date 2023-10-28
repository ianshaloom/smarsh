import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function onFilter;
  const FilterBottomSheet({super.key, required this.onFilter});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool _toggleAllItems = false;
  bool _toggleMissingItems = false;
  bool _toogleExcessItems = false;
  bool _toogleIntactItems = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Filter Non-Posted Items',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _toggleAllItems,
                    onChanged: (value) {
                      widget.onFilter('all');
                      setState(() {
                        _toggleAllItems = value!;
                        _toggleMissingItems = false;
                        _toogleExcessItems = false;
                        _toogleIntactItems = false;
                      });
                    },
                  ),
                  const Text('All Items'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _toggleMissingItems,
                    onChanged: (value) {
                      widget.onFilter('missing');
                      setState(() {
                        _toggleMissingItems = value!;
                        _toggleAllItems = false;
                        _toogleExcessItems = false;
                        _toogleIntactItems = false;
                      });
                    },
                  ),
                  const Text('Missing Items'),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _toogleExcessItems,
                    onChanged: (value) {
                      widget.onFilter('excess');
                      setState(() {
                        _toogleExcessItems = value!;
                        _toggleAllItems = false;
                        _toggleMissingItems = false;
                        _toogleIntactItems = false;
                      });
                    },
                  ),
                  const Text('Excess Items'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _toogleIntactItems,
                    onChanged: (value) {
                      widget.onFilter('intact');
                      setState(() {
                        _toogleIntactItems = value!;
                        _toggleAllItems = false;
                        _toggleMissingItems = false;
                        _toogleExcessItems = false;
                      });
                    },
                  ),
                  const Text('Intact Items'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
