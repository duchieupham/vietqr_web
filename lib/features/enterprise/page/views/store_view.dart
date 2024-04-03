import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/enterprise/enterprise.dart';
import 'package:VietQR/features/enterprise/page/widgets/table_store_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../commons/constants/configurations/app_image.dart';
import '../../../../commons/utils/image_utils.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  late EnterpriseBloc bloc;
  final searchController = TextEditingController();
  String merchantId = '';
  String keySearch = '';

  @override
  void initState() {
    super.initState();
    bloc = EnterpriseBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetStoreEvent(
          merchantId: merchantId, keySearch: searchController.text));
    });
  }

  void loadMore(int offset) {
    bloc.add(GetStoreEvent(
      keySearch: keySearch,
      merchantId: merchantId,
      loadMore: true,
      offset: offset,
    ));
  }

  void _onSearch() {
    bloc.add(GetStoreEvent(
        keySearch: keySearch,
        merchantId: merchantId,
        loadMore: false,
        offset: 0));
  }

  void _onClear() {
    searchController.clear();
    keySearch = '';
    setState(() {});
    bloc.add(GetStoreEvent(
        keySearch: keySearch,
        merchantId: merchantId,
        loadMore: false,
        offset: 0));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EnterpriseBloc>(
      create: (context) => bloc,
      child: BlocConsumer<EnterpriseBloc, EnterpriseState>(
        listener: (context, state) {
          if (state.request == EnterpriseType.GET_STORE) {}
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: AppColor.WHITE,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Row(
                      children: [
                        const Text(
                          'Doanh nghiệp',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                        const SizedBox(width: 8),
                        const Text('/'),
                        const SizedBox(width: 8),
                        const Text(
                          'Cửa hàng',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                        const Spacer(),
                        Text(
                          state.storeModel.merchantName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: const [
                            Icon(Icons.keyboard_arrow_up_outlined, size: 14),
                            Icon(Icons.keyboard_arrow_down_outlined, size: 14),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 2),
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      children: [
                        _buildHeader(context, state),
                        const SizedBox(height: 24),
                        _buildBody(context, state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EnterpriseState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableStoreWidget(
          terminals: state.storeMaps['${state.offset}'] ?? [],
          offset: state.offset,
        ),
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

  Widget _buildHeader(BuildContext context, EnterpriseState state) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Danh sách cửa hàng',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${state.storeModel.totalTerminals} cửa hàng'),
          ],
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 40, right: 12),
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
              hintText: 'Tìm kiếm cửa hàng theo tên',
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
        // GestureDetector(
        //onTap: _onSearch,
        // child: Container(
        //   width: 40,
        //   height: 40,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(40),
        //     color: AppColor.BLUE_TEXT,
        //   ),
        //   child: const Icon(Icons.search, color: AppColor.WHITE),
        // ),
        // ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: InkWell(
            onTap: _onSearch,
            child: Container(
              width: 120,
              height: 40,
              // margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.BLUE_TEXT,
              ),
              child: Row(
                children: [
                  Image(
                    image: ImageUtils.instance
                        .getImageNetWork(AppImages.icSearchTrans),
                    width: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Tìm kiếm',
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // const Spacer(),
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
      ],
    );
  }
}
