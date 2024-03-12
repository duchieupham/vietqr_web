import 'package:VietQR/models/transaction_store_dto.dart';
import 'package:equatable/equatable.dart';

class EnterpriseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetStoreEvent extends EnterpriseEvent {
  final bool loadMore;
  final int offset;
  final String keySearch;
  final String merchantId;

  GetStoreEvent({
    this.loadMore = false,
    this.offset = 0,
    this.keySearch = '',
    this.merchantId = '',
  });

  @override
  List<Object?> get props => [loadMore, offset, keySearch, merchantId];
}

class GetMemberStoreEvent extends EnterpriseEvent {
  final bool loadMore;
  final int offset;
  final String keySearch;
  final String terminalId;
  final int type;

  GetMemberStoreEvent({
    this.loadMore = false,
    this.offset = 0,
    this.keySearch = '',
    this.terminalId = '',
    this.type = 0,
  });

  @override
  List<Object?> get props => [
        loadMore,
        offset,
        keySearch,
        terminalId,
        type,
      ];
}

class GetTransStoreEvent extends EnterpriseEvent {
  final bool loadMore;
  final int offset;
  final String keySearch;
  final String terminalId;
  final int type;
  final String fromDate;
  final String toDate;

  GetTransStoreEvent({
    this.loadMore = false,
    this.offset = 0,
    this.keySearch = '',
    this.terminalId = '',
    this.type = 0,
    this.fromDate = '',
    this.toDate = '',
  });

  @override
  List<Object?> get props => [
        loadMore,
        offset,
        keySearch,
        terminalId,
        type,
        fromDate,
        toDate,
      ];
}

class GetStoreDetailEvent extends EnterpriseEvent {
  final String terminalId;

  GetStoreDetailEvent(this.terminalId);

  @override
  List<Object?> get props => [terminalId];
}

class UpdateNoteEvent extends EnterpriseEvent {
  final TransactionStoreDTO dto;
  final int offset;

  UpdateNoteEvent({
    required this.dto,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [dto, offset];
}
