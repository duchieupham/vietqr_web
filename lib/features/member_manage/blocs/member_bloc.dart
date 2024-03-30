import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/member_manage/member_manage.dart';
import 'package:VietQR/features/member_manage/repositories/member_repository.dart';
import 'package:VietQR/models/member/member_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc() : super(const MemberState()) {
    on<GetMerchantsEvent>(_getMerchant);
    on<GetMembersEvent>(_getMembers);
    on<FetchMembersEvent>(_fetchMembers);
    on<UpdateOffsetEvent>(_updateOffset);
  }

  final repository = MemberRepository();
  final int _limit = 20;

  void _getMembers(MemberEvent event, Emitter emit) async {
    try {
      if (event is GetMembersEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: MemberType.NONE));

        bool loadMore = true;
        int page = event.dto.page;
        Map<String, List<Member>> maps = {};

        final result = await repository.getMembers(event.dto);

        if (page >= result.totalPage) {
          loadMore = false;
        }

        maps['$page'] = result.items;

        emit(state.copyWith(
            request: MemberType.GET_MEMBERS,
            memberDTO: result,
            maps: maps,
            isLoadMore: loadMore,
            offset: page,
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

  void _fetchMembers(MemberEvent event, Emitter emit) async {
    try {
      if (event is FetchMembersEvent) {
        emit(state.copyWith(
            status: BlocStatus.LOADING, request: MemberType.NONE));

        bool loadMore = state.isLoadMore;
        int page = event.dto.page;
        Map<String, List<Member>> maps = {};
        maps.addAll(state.maps);

        List<Member> items = maps['$page'] ?? [];

        if (items.isNotEmpty) {
          if (items.length < _limit) loadMore = false;
          emit(state.copyWith(
              request: MemberType.GET_MEMBERS,
              status: BlocStatus.NONE,
              isLoadMore: loadMore));
          return;
        }
        final result = await repository.getMembers(event.dto);

        if (page >= result.totalPage ||
            result.items.length < _limit ||
            result.items.isEmpty) {
          loadMore = false;
        }

        maps['$page'] = result.items;

        emit(state.copyWith(
            request: MemberType.GET_MEMBERS,
            memberDTO: result,
            maps: maps,
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

  void _updateOffset(MemberEvent event, Emitter emit) async {
    try {
      if (event is UpdateOffsetEvent) {
        emit(state.copyWith(status: BlocStatus.NONE, request: MemberType.NONE));

        emit(
          state.copyWith(
            request: MemberType.UPDATE_OFFSET,
            status: BlocStatus.NONE,
            offset: event.offset,
          ),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(state.copyWith(
          status: BlocStatus.ERROR,
          msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau.'));
    }
  }
}
