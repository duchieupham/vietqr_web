import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/enterprise/enterprise.dart';
import 'package:VietQR/features/enterprise/page/widgets/dialog_filter_member.dart';
import 'package:VietQR/features/enterprise/page/widgets/table_member_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberStoreView extends StatefulWidget {
  final String terminalId;

  const MemberStoreView({super.key, this.terminalId = ''});

  @override
  State<MemberStoreView> createState() => _MemberStoreViewState();
}

class _MemberStoreViewState extends State<MemberStoreView> {
  double get width => MediaQuery.of(context).size.width;

  bool get isKWeb => (PlatformUtils.instance.resizeWhen(width, 1360));

  late EnterpriseBloc bloc;
  final searchController = TextEditingController();
  String keySearch = '';
  int type = 0;

  // keySearch = '' là get all, 0 theo sđt , 1 theo họ tên

  @override
  void initState() {
    super.initState();
    bloc = EnterpriseBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(
        GetMemberStoreEvent(
            type: type, keySearch: keySearch, terminalId: widget.terminalId),
      );
    });
  }

  void loadMore(int offset) {
    bloc.add(GetMemberStoreEvent(
      type: type,
      keySearch: keySearch,
      terminalId: widget.terminalId,
      loadMore: true,
      offset: offset,
    ));
  }

  void _onSearch() {
    bloc.add(GetMemberStoreEvent(
        type: type,
        keySearch: keySearch,
        terminalId: widget.terminalId,
        loadMore: false,
        offset: 0));
  }

  void _onClear() {
    searchController.clear();
    keySearch = '';
    type = 9;
    setState(() {});
    bloc.add(GetMemberStoreEvent(
        type: type,
        keySearch: keySearch,
        terminalId: widget.terminalId,
        loadMore: false,
        offset: 0));
  }

  void _onFilter() async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogFilterView(type: type);
      },
    );

    if (type != data) {
      searchController.text = '';
    }

    setState(() {
      type = data;
    });

    _onSearch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EnterpriseBloc>(
      create: (context) => bloc,
      child: BlocConsumer<EnterpriseBloc, EnterpriseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isKWeb) ...[
                _buildHeaderWeb(context, state),
                const SizedBox(height: 40),
                _buildBodyWeb(state),
              ] else ...[
                _buildHeaderMobile(context, state),
                const SizedBox(height: 40),
                _buildBodyMobile(state),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderWeb(BuildContext context, EnterpriseState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Danh sách nhân viên',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${state.members.length} nhân viên'),
          ],
        ),
        const SizedBox(width: 24),
        Container(
          width: 200,
          height: 34,
          decoration: BoxDecoration(
            color: AppColor.GREY_BG,
            border: Border.all(color: AppColor.GREY_LIGHT),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            style: const TextStyle(fontSize: 12),
            controller: searchController,
            onChanged: (value) {
              setState(() {
                keySearch = value;
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(bottom: 16, left: 12, right: 12),
              hintText: type == 1
                  ? 'Tìm kiếm nhân viên theo tên'
                  : type == 0
                      ? 'Tìm kiếm nhân viên theo SDT'
                      : 'Tìm kiếm tất cả nhân viên',
              hintStyle:
                  const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: _onClear,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.close, size: 18),
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _onFilter,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColor.BLUE_TEXT.withOpacity(0.25),
            ),
            child: Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.icFilterTrans),
              width: 28,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _onSearch,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColor.BLUE_TEXT,
            ),
            child: Image(
              image:
                  ImageUtils.instance.getImageNetWork(AppImages.icSearchTrans),
              width: 28,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        ButtonWidget(
          text: 'Xuất Excel',
          width: 120,
          border: Border.all(color: AppColor.GREEN),
          textColor: AppColor.GREEN,
          bgColor: AppColor.TRANSPARENT,
          function: () {
            Navigator.pop(context);
          },
          borderRadius: 5,
          height: 40,
        ),
        const SizedBox(width: 16),
        ButtonWidget(
          text: 'Thêm cửa hàng',
          width: 120,
          textColor: AppColor.WHITE,
          bgColor: AppColor.BLUE_TEXT,
          function: () {
            Navigator.pop(context);
          },
          borderRadius: 5,
          height: 40,
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  Widget _buildHeaderMobile(BuildContext context, EnterpriseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Danh sách nhân viên',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${state.members.length} nhân viên'),
              ],
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: _onFilter,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppColor.BLUE_TEXT.withOpacity(0.25),
                ),
                child: const Icon(Icons.filter_list, color: AppColor.WHITE),
              ),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 12, right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border.all(color: AppColor.GREY_LIGHT),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                style: const TextStyle(fontSize: 12),
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    keySearch = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 18),
                  border: InputBorder.none,
                  hintText: type == 1
                      ? 'Tìm kiếm nhân viên theo tên'
                      : type == 0
                          ? 'Tìm kiếm nhân viên theo SDT'
                          : 'Tìm kiếm tất cả nhân viên',
                  hintStyle:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                  suffixIcon: keySearch.isNotEmpty
                      ? GestureDetector(
                          onTap: _onClear,
                          child: const Icon(Icons.close, size: 18),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(),
                ),
              ),
            ),
            GestureDetector(
              onTap: _onSearch,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppColor.BLUE_TEXT,
                ),
                child: const Icon(Icons.search, color: AppColor.WHITE),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ButtonWidget(
              text: 'Xuất Excel',
              width: 120,
              border: Border.all(color: AppColor.GREEN),
              textColor: AppColor.GREEN,
              bgColor: AppColor.TRANSPARENT,
              function: () {
                Navigator.pop(context);
              },
              borderRadius: 5,
              height: 40,
            ),
            const SizedBox(width: 16),
            ButtonWidget(
              text: 'Thêm cửa hàng',
              width: 120,
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              function: () {
                Navigator.pop(context);
              },
              borderRadius: 5,
              height: 40,
            ),
            const SizedBox(width: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyWeb(EnterpriseState state) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: TableMemberWidget(
                  members: state.membersMap['${state.offset}'] ?? [],
                  offset: state.offset)),
          Container(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Text('Trang ${state.offset + 1}'),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    int offset = state.offset;
                    if (offset <= 0) return;
                    offset = offset - 1;
                    loadMore(offset);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color:
                              state.offset <= 0 ? Colors.grey : Colors.black),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: state.offset <= 0 ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (!state.isLoadMore) return;
                    int offset = state.offset;
                    offset = offset + 1;
                    loadMore(offset);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: !state.isLoadMore ? Colors.grey : Colors.black,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: !state.isLoadMore ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMobile(EnterpriseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableMemberWidget(
            members: state.membersMap['${state.offset}'] ?? [],
            offset: state.offset),
        Container(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              Text('Trang ${state.offset + 1}'),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  int offset = state.offset;
                  if (offset <= 0) return;
                  offset = offset - 1;
                  loadMore(offset);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: state.offset <= 0 ? Colors.grey : Colors.black),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                    color: state.offset <= 0 ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (!state.isLoadMore) return;
                  int offset = state.offset;
                  offset = offset + 1;
                  loadMore(offset);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: !state.isLoadMore ? Colors.grey : Colors.black,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: !state.isLoadMore ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
