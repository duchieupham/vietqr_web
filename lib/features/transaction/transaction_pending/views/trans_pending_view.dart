import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/features/transaction/blocs/transaction_bloc.dart';
import 'package:VietQR/features/transaction/events/transaction_event.dart';
import 'package:VietQR/features/transaction/states/transaction_state.dart';
import 'package:VietQR/features/transaction/transaction_pending/widgets/table_pending_widget.dart';
import 'package:VietQR/models/setting_account_sto.dart';
import 'package:VietQR/models/transaction_input_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransPendingView extends StatefulWidget {
  final TransactionInputDTO inputDTO;
  final Stream<dynamic> stream;
  final MerchantRole role;
  final bool isOwner;

  const TransPendingView({
    super.key,
    required this.inputDTO,
    required this.stream,
    required this.role,
    this.isOwner = false,
  });

  @override
  State<TransPendingView> createState() => _TransPendingViewState();
}

class _TransPendingViewState extends State<TransPendingView> {
  late TransactionBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = TransactionBloc();
    widget.stream.listen((event) {
      if (event is TransactionInputDTO) {
        bloc.add(GetTransUnclassifiedEvent(dto: widget.inputDTO));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetTransUnclassifiedEvent(dto: widget.inputDTO));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (context) => bloc,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: _listener,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Danh sách giao dịch chờ xác nhận',
                style: TextStyle(
                    color: AppColor.BLACK,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
              const SizedBox(height: 12),
              TablePendingWidget(
                items: state.maps['${state.offset}'] ?? [],
                offset: state.offset,
                isOwner: state.bankDTO?.isOwner ?? false,
                isLoading: state.status == BlocStatus.LOADING,
                callBack: (dto) {
                  bloc.add(TransApproveEvent(dto: dto, offset: state.offset));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _listener(BuildContext context, TransactionState state) {
    if (state.request == TransType.APPROVE_TRANS) {
      Fluttertoast.showToast(
        msg: 'Duyệt thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      );
    }

    if (state.request == TransType.CLOSE_TRANS) {
      Fluttertoast.showToast(
        msg: 'Huỷ thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      );
    }
  }
}
