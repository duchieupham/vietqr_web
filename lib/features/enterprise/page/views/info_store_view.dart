import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/features/enterprise/enterprise.dart';
import 'package:VietQR/features/enterprise/page/widgets/form_info_store_widget.dart';
import 'package:VietQR/features/enterprise/page/widgets/qr_store_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoStoreView extends StatefulWidget {
  final String terminalId;

  const InfoStoreView({super.key, required this.terminalId});

  @override
  State<InfoStoreView> createState() => _InfoStoreViewState();
}

class _InfoStoreViewState extends State<InfoStoreView> {
  late EnterpriseBloc bloc;

  double get width => MediaQuery.of(context).size.width;

  bool get isKWeb => (PlatformUtils.instance.resizeWhen(width, 1360));

  @override
  void initState() {
    super.initState();
    bloc = EnterpriseBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetStoreDetailEvent(widget.terminalId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<EnterpriseBloc, EnterpriseState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (isKWeb) return _buildWeb(state);
          return _buildMobile(state);
        },
      ),
    );
  }

  Widget _buildMobile(EnterpriseState state) {
    return Column(
      children: [
        FormInfoStoreWidget(dto: state.storeDetailModel),
        const SizedBox(height: 24),
        QrStoreWidget(dto: state.storeDetailModel),
      ],
    );
  }

  Widget _buildWeb(EnterpriseState state) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(child: FormInfoStoreWidget(dto: state.storeDetailModel)),
          QrStoreWidget(dto: state.storeDetailModel),
        ],
      ),
    );
  }
}
