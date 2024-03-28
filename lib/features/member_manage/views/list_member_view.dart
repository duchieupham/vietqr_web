import 'dart:async';

import 'package:VietQR/features/member_manage/member_manage.dart';
import 'package:VietQR/features/member_manage/widgets/member_filter_widget.dart';
import 'package:VietQR/features/member_manage/widgets/table_member_widget.dart';
import 'package:VietQR/layouts/horizontal_dashedline_painter.dart';
import 'package:VietQR/models/member/member_input_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListMemberView extends StatefulWidget {
  const ListMemberView({super.key});

  @override
  State<ListMemberView> createState() => _ListMemberViewState();
}

class _ListMemberViewState extends State<ListMemberView> {
  late MemberBloc bloc;
  final _streamController = StreamController<bool>.broadcast();
  late Stream<bool> filterStream;

  MerchantDTO _merchant = MerchantDTO();
  String _bankId = '';
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    bloc = MemberBloc();
    filterStream = _streamController.stream;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetMerchantsEvent());
    });
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
              updateState();
            }
            MemberInputDTO dto = MemberInputDTO(
              merchantId: _merchant.id,
            );
            bloc.add(GetMembersEvent(dto));
          }
        },
        builder: (context, state) {
          return MemberHeaderWidget(
            title: 'Danh sách nhân viên',
            dto: _merchant,
            onTap: _onChooseMerchant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MemberFilterWidget(
                  stream: filterStream,
                  callBack: _onReceive,
                  terminals: state.terminals,
                  bankId: _bankId,
                  isOwner: _isOwner,
                ),
                const SizedBox(height: 24),
                CustomPaint(
                  painter:
                      HorizontalDashedLinePainter(dashWidth: 5, dashSpace: 3),
                  size: const Size(double.infinity, 1),
                ),
                const SizedBox(height: 12),
                TableMemberWidget(
                  items: state.memberDTO?.items ?? [],
                  offset: 0,
                ),
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

  void _onChooseMerchant() {}

  _onReceive(int? p1, String? p2, bool? p3) {}

  @override
  void dispose() {
    if (_streamController.hasListener) {
      _streamController.close();
    }
    super.dispose();
  }
}
