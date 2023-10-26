import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/footer_web.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/add_bank/states/list_bank_state.dart';
import 'package:VietQR/features/dashboard/views/menu_top.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'blocs/bank_type_bloc.dart';
import 'events/list_bank_event.dart';

class AddBankStep1 extends StatefulWidget {
  const AddBankStep1({super.key});

  @override
  State<AddBankStep1> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankStep1> {
  late ListBankBloc bankTypeBloc;
  List<BankTypeDTO> bankTypesResult = [];
  List<BankTypeDTO> bankTypes = [];

  @override
  void initState() {
    bankTypeBloc = ListBankBloc()..add(const BankTypeEventGetList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListBankBloc>(
      create: (context) => bankTypeBloc,
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.WHITE,
                AppColor.BLUE_LIGHT,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              const HeaderWidget(),
              const MenuTop(
                currentType: MenuHomeType.OTHER,
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildTitle(),
                    _buildStep(),
                    _buildFiledSearch(),
                    Expanded(
                      child: BlocConsumer<ListBankBloc, ListBankState>(
                        listener: (context, state) {
                          if (state is BankTypeGetListSuccessfulState) {
                            if (state.list.isNotEmpty) {
                              bankTypesResult = state.list;
                              bankTypes = state.list;
                            }
                          }
                          if (state is BankTypeSearchState) {
                            bankTypesResult = state.list;
                          }
                        },
                        builder: (context, state) {
                          if (state is BankTypeLoadingState) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (bankTypesResult.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(child: Text('Không có dữ liệu')),
                            );
                          }

                          return Consumer<BankTypeProvider>(
                              builder: (context, provider, child) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Expanded(
                                    flex: 12,
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 60,
                                        runSpacing: 40,
                                        children: bankTypesResult.map((e) {
                                          return _buildItemBank(e, () {
                                            provider.updateBankType(e);
                                            context.go(
                                                '/add-bank/step2?bankId=${e.id}');
                                          },
                                              isSelected:
                                                  provider.bankType.id == e.id);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    const FooterWeb(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemBank(BankTypeDTO dto, VoidCallback onTap,
      {bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.WHITE,
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(
                        dto.imageId,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  dto.bankShortName,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.check,
                  size: 10,
                  color: AppColor.WHITE,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.1)),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              html.window.history.back();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, right: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.BLUE_TEXT,
                    size: 12,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Trở về',
                    style: TextStyle(fontSize: 11, color: AppColor.BLUE_TEXT),
                  ),
                ],
              ),
            ),
          ),
          const Text(
            'Thêm tài khoản ngân hàng',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
          width: 550,
          child: Row(
            children: [
              Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '1',
                  style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Chọn ngân hàng',
                  style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                ),
              ),
              Expanded(
                  child: Container(
                height: 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.GREY_TEXT),
              )),
              Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: AppColor.GREY_TEXT,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '2',
                  style: TextStyle(color: AppColor.WHITE, fontSize: 12),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Nhập thông tin',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildFiledSearch() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 28,
        ),
        const Text(
          'Chọn ngân hàng bạn muốn thêm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          height: 36,
          width: 320,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColor.BLACK_LIGHT.withOpacity(0.5))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      bankTypeBloc.add(
                        BankTypeEventSearch(
                          textSearch: value,
                          list: bankTypes,
                        ),
                      );
                    } else {
                      bankTypeBloc.add(const BankTypeEventGetList());
                    }
                  },
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm ngân hàng',
                    contentPadding:
                        EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const Icon(
                Icons.search,
                size: 18,
                color: AppColor.BLACK,
              ),
              const SizedBox(
                width: 8,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
