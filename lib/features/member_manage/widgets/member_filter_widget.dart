import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/layouts/m_drop_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/transaction/data_filter.dart';

class MemberFilterWidget extends StatefulWidget {
  final Function(int?, String?, bool) callBack;
  final Function() onSearch;
  final Stream<bool> stream;
  final bool isOwner;

  const MemberFilterWidget({
    super.key,
    required this.callBack,
    required this.stream,
    required this.isOwner,
    required this.onSearch,
  });

  @override
  State<MemberFilterWidget> createState() => _MemberFilterWidgetState();
}

class _MemberFilterWidgetState extends State<MemberFilterWidget> {
  final searchController = TextEditingController();
  String _value = '';

  final List<DataFilter> listFilterBy = [
    const DataFilter(id: 0, name: 'Họ tên'),
    const DataFilter(id: 1, name: 'Số điện thoại'),
  ];

  DataFilter _filterBy = const DataFilter(id: 0, name: 'Họ tên');

  String get hinText {
    if (_filterBy.id == 0) return 'Tìm kiếm nhân viên theo họ tên';
    return 'Tìm kiếm nhân viên theo số diện thoại';
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((event) {
      _onClearFilter(clearData: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tìm kiếm nhân viên',
          style: TextStyle(
              color: AppColor.BLACK, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ...[
                _buildFilterByWidget(),
                _buildSearchWidget(),
              ],
              _searchWidget(),
              if (!widget.isOwner)
                Row(
                  children: [
                    ButtonWidget(
                      text: 'Xuất Excel',
                      width: 100,
                      border: Border.all(color: AppColor.GREEN),
                      textColor: AppColor.GREEN,
                      bgColor: AppColor.TRANSPARENT,
                      function: _onExportExcel,
                      borderRadius: 5,
                      height: 34,
                    ),
                    const SizedBox(width: 12),
                    ButtonWidget(
                      text: 'Thêm mới nhân viên',
                      width: 130,
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                      function: _onExportExcel,
                      borderRadius: 5,
                      height: 34,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _onCallBack({int? type, String? search, bool clearData = false}) {
    widget.callBack(type, search, clearData);
  }

  Widget _buildFilterByWidget() {
    return SizedBox(
      width: 120,
      child: MDropWidget<DataFilter>(
        title: 'Tìm kiếm theo',
        list: listFilterBy,
        filter: _filterBy,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
        callBack: (value) {
          if (value == null) return;
          _filterBy = value;
          updateState();
          _onCallBack(type: _filterBy.id);
        },
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      width: 230,
      height: 34,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.GREY_BORDER, width: 0.5),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
      ),
      child: TextField(
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          _onCallBack(search: value, clearData: true);
        },
        style: const TextStyle(fontSize: 12),
        controller: searchController,
        onChanged: onChangedSearch,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.only(bottom: 16, left: 12, right: 12),
          hintText: hinText,
          hintStyle: const TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 4),
            child: Icon(Icons.search, size: 18, color: AppColor.GREY_TEXT),
          ),
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: (searchController.text.isNotEmpty)
              ? InkWell(
                  onTap: _onClear,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.close, size: 18),
                  ),
                )
              : const SizedBox(),
          suffixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }

  Widget _searchWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: InkWell(
        onTap: widget.onSearch,
        child: Container(
          width: 100,
          height: 34,
          // margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColor.BLUE_TEXT,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: ImageUtils.instance
                    .getImageNetWork(AppImages.icSearchTrans),
                width: 25,
              ),
              const Text(
                'Tìm kiếm',
                // textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 5)),
            ],
          ),
        ),
      ),
    );
  }

  void _onClearFilter({bool clearData = false}) {
    searchController.clear();
    _filterBy = listFilterBy.first;
    _onCallBack(type: _filterBy.id, clearData: clearData);
    updateState();
  }

  void _onClear() {
    searchController.clear();
    _value = '';
    _onCallBack(search: _value, clearData: true);
    updateState();
  }

  void updateState() {
    setState(() {});
  }

  void _onExportExcel() async {
    // await showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return DialogExcelWidget(
    //       terminals: widget.terminals,
    //       bankId: widget.bankId,
    //     );
    //   },
    // );
  }

  void onChangedTerminal(String value) {
    searchController.text = value;
    if (widget.isOwner) {
      _value = value;
      _onCallBack(search: value);
    }
    updateState();
  }

  void onChangedSearch(String value) {
    _value = value;
    _onCallBack(search: value);
    updateState();
  }
}
