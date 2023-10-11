import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/ecom/bank/blocs/ecom_bank_type_bloc.dart';
import 'package:VietQR/ecom/bank/events/ecom_bank_type_event.dart';
import 'package:VietQR/ecom/bank/provider/ecom_bank_type_provider.dart';
import 'package:VietQR/ecom/bank/states/ecom_bank_type_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/services/providers/search_clear_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ECOMSelectBankTypeWidget extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SearchClearProvider _searchClearProvider = SearchClearProvider(false);
  final List<BankTypeDTO> bankTypesResult = [];
  final List<BankTypeDTO> bankTypes = [];

  final bool authenticated;
  ECOMSelectBankTypeWidget({super.key, this.authenticated = true});
  static late ECOMBankTypeBloc bankTypeBloc;
  void initialServices(BuildContext context) {
    bankTypeBloc = BlocProvider.of(context);
    bankTypesResult.clear();
    bankTypes.clear();
    bankTypeBloc.add(const ECOMBankTypeEventGetList());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Text(
                'Chọn ngân hàng',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        UnconstrainedBox(
          child: BoxLayout(
            width: 500 - 40,
            height: 50,
            borderRadius: 50,
            bgColor: Theme.of(context).canvasColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFieldWidget(
                      width: width,
                      hintText: 'Tìm theo tên',
                      controller: searchController,
                      keyboardAction: TextInputAction.done,
                      autoFocus: false,
                      onChange: (value) {
                        if (searchController.text.isNotEmpty) {
                          _searchClearProvider.updateClearSearch(true);
                          bankTypeBloc.add(
                            ECOMBankTypeEventSearch(
                              textSearch: searchController.text,
                              list: bankTypes,
                            ),
                          );
                        } else {
                          _searchClearProvider.updateClearSearch(false);
                        }
                      },
                      inputType: TextInputType.text,
                      isObscureText: false,
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _searchClearProvider,
                  builder: (_, provider, child) {
                    return Visibility(
                      visible: provider == true,
                      child: InkWell(
                        onTap: () {
                          searchController.clear();
                          _searchClearProvider.updateClearSearch(false);
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    );
                  },
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
              ],
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Expanded(
          child: BlocBuilder<ECOMBankTypeBloc, ECOMBankTypeState>(
            builder: (context, state) {
              if (state is ECOMBankTypeLoadingState) {
                return SizedBox(
                  width: width,
                  height: 200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.GREEN,
                    ),
                  ),
                );
              }
              if (state is ECOMBankTypeGetListSuccessfulState) {
                if (state.list.isNotEmpty && bankTypes.isEmpty) {
                  bankTypes.addAll(state.list);
                  bankTypesResult.addAll(bankTypes);
                }
              }
              if (state is ECOMBankTypeSearchState) {
                bankTypesResult.clear();
                bankTypesResult.addAll(state.list);
              }
              return Visibility(
                visible: bankTypesResult.isNotEmpty,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: bankTypesResult.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    return _buildBankTypeItem(
                        context, bankTypesResult[index], width);
                  },
                  separatorBuilder: (context, index) {
                    return DividerWidget(width: width);
                  },
                ),
              );
            },
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
      ],
    );
  }

  Widget _buildBankTypeItem(
      BuildContext context, BankTypeDTO dto, double width) {
    return InkWell(
      onTap: () {
        _searchClearProvider.updateClearSearch(false);
        searchController.clear();
        Provider.of<ECOMBankTypeProvider>(context, listen: false)
            .updateBankType(dto);
        Navigator.pop(context);
      },
      child: BoxLayout(
        width: width,
        borderRadius: 0,
        bgColor: AppColor.TRANSPARENT,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                image: DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(
                    dto.imageId,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                (dto.bankShortName.trim().isEmpty)
                    ? '${dto.bankCode} - ${dto.bankName}'
                    : '${dto.bankShortName} - ${dto.bankName}',
                style: const TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
