import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/member_manage/member_manage.dart';
import 'package:VietQR/features/member_manage/repositories/member_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc() : super(const MemberState()) {
    on<GetMembersEvent>(_getMembers);
    on<GetMerchantsEvent>(_getMerchant);
  }

  final repository = MemberRepository();
  final int _limit = 20;

  void _getMembers(MemberEvent event, Emitter emit) async {
    try {
      if (event is GetMembersEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: MemberType.NONE));
        final result = await repository.getMembers(event.dto);




        emit(state.copyWith(
            request: MemberType.GET_MEMBERS,
            memberDTO: result,
            status: BlocStatus.NONE));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          request: MemberType.ERROR,
          status: BlocStatus.NONE,
          msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'));
    }
  }

  void _getMerchant(MemberEvent event, Emitter emit) async {
    try {
      if (event is GetMerchantsEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: MemberType.NONE));

        final result = await repository.getMerchants();

        emit(
          state.copyWith(
            request: MemberType.GET_MERCHANTS,
            status: BlocStatus.NONE,
            merchants: result,
            isEmpty: result.isEmpty,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(
        state.copyWith(
            status: BlocStatus.ERROR,
            msg: 'Không thể tải danh sách. Vui lòng kiểm tra lại kết nối'),
      );
    }
  }
}
