import 'dart:async';

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/features/member_manage/member_manage.dart';
import 'package:VietQR/features/member_manage/widgets/member_filter_widget.dart';
import 'package:VietQR/features/member_manage/widgets/table_member_widget.dart';
import 'package:VietQR/layouts/dialog/choose_merchant_widget.dart';
import 'package:VietQR/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:VietQR/models/member/member_input_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/services/providers/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ListMemberView extends StatefulWidget {
  const ListMemberView({super.key});

  @override
  State<ListMemberView> createState() => _ListMemberViewState();
}

class _ListMemberViewState extends State<ListMemberView> {
  late MemberBloc bloc;
  late SettingProvider provider;
  final _streamController = StreamController<bool>.broadcast();
  late Stream<bool> filterStream;

  MerchantDTO _merchant = MerchantDTO();
  MerchantRole role = MerchantRole();
  String _value = '';
  int _type = 0;

  @override
  void initState() {
    super.initState();
    bloc = MemberBloc();
    provider = Provider.of<SettingProvider>(context, listen: false);
    filterStream = _streamController.stream;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetMerchantsEvent());
    });
  }

  void onRole(MerchantDTO dto) {
    SettingAccountDTO settingDTO = provider.settingAccountDTO;
    List<MerchantRole> merchantRoles = [...settingDTO.merchantRoles];
    MerchantRole merchantDTO = merchantRoles.firstWhere(
        (element) => element.merchantId == dto.id,
        orElse: () => MerchantRole());
    if (merchantDTO.merchantId.isEmpty) return;
    role = merchantDTO;
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state.request == MemberType.GET_MERCHANTS) {
            if (state.merchants.isNotEmpty) {
              _merchant = state.merchants.first;
              onRole(state.merchants.first);
            }
            MemberInputDTO dto = MemberInputDTO(merchantId: _merchant.id);
            bloc.add(GetMembersEvent(dto));
          }

          if (state.request == MemberType.UPDATE_OFFSET) {
            MemberInputDTO dto = MemberInputDTO(
                merchantId: _merchant.id,
                value: _value,
                type: _type,
                page: state.offset);
            bloc.add(FetchMembersEvent(dto));
          }
        },
        builder: (context, state) {
          return MemberHeaderWidget(
            title: 'Danh sách nhân viên',
            dto: _merchant,
            onTap: () => _onChooseMerchant(state.merchants),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MemberFilterWidget(
                  stream: filterStream,
                  callBack: _onReceive,
                  onSearch: _onSearch,
                  isOwner: false,
                ),
                const SizedBox(height: 24),
                CustomPaint(
                  painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
                  size: const Size(double.infinity, 1),
                ),
                const SizedBox(height: 12),
                TableMemberWidget(
                  items: state.maps['${state.offset}'] ?? [],
                  offset: state.offset - 1,
                  isLoading: state.status == BlocStatus.LOADING,
                  role: role,
                ),
                _buildPageWidget(state),
              ],
            ),
          );
        },
      ),
    );
  }

  void updateState() {
    setState(() {});
  }

  void _onChooseMerchant(List<MerchantDTO> list) async {
    final data = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ChooseMerchantWidget(items: list);
      },
    );

    if (data != null && data is MerchantDTO) {
      _merchant = data;
      MemberInputDTO dto = MemberInputDTO(merchantId: _merchant.id);
      bloc.add(GetMembersEvent(dto));
      onRole(data);
    }
  }

  void _onSearch() {
    MemberInputDTO dto =
        MemberInputDTO(merchantId: _merchant.id, value: _value, type: _type);
    bloc.add(GetMembersEvent(dto));
  }

  _onReceive(int? type, String? value, bool clearData) {
    _type = type ?? _type;
    _value = value ?? _value;
    updateState();

    if (clearData) {
      _onSearch();
    }
  }

  Widget _buildPageWidget(MemberState state) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: 60,
      child: Row(
        children: [
          Text('Trang ${state.offset}'),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              int offset = state.offset;
              if (offset <= 1) return;
              offset = offset - 1;
              bloc.add(UpdateOffsetEvent(offset));
            },
            child: Container(
              width: 25,
              height: 25,
              padding: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: state.offset <= 1 ? Colors.grey : Colors.black),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 14,
                color: state.offset <= 1 ? Colors.grey : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (!state.isLoadMore) return;
              int offset = state.offset;
              offset = offset + 1;
              bloc.add(UpdateOffsetEvent(offset));
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
    );
  }

  @override
  void dispose() {
    if (_streamController.hasListener) {
      _streamController.close();
    }
    super.dispose();
  }
}
