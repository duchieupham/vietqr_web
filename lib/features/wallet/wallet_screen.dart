import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/share_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/wallet/blocs/wallet_qr_bloc.dart';
import 'package:VietQR/features/wallet/events/wallet_event.dart';
import 'package:VietQR/features/wallet/frame/wallet_frame.dart';
import 'package:VietQR/models/contact_detail_dto.dart';
import 'package:VietQR/models/contact_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'provider/wallet_provider.dart';
import 'states/wallet_state.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletBloc bloc;
  List<List<ContactDTO>> contactList = [];
  ContactDetailDTO contactDetailDTO = ContactDetailDTO();

  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO();

  @override
  void initState() {
    bloc = WalletBloc()
      ..add(ContactEventGetList(isLoading: true, type: 8, offset: 0));
    super.initState();
  }

  QRGeneratedDTO getQrDTO(ContactDetailDTO dto) {
    return QRGeneratedDTO(
      bankCode: dto.bankShortName,
      bankName: dto.bankName,
      bankAccount: dto.bankAccount,
      userBankName: dto.nickname,
      amount: '',
      content: '',
      qrCode: dto.value,
      imgId: dto.imgId,
      email: dto.email,
      type: dto.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => bloc,
      child: ChangeNotifierProvider<WalletProvider>(
        create: (context) => WalletProvider(),
        child: WalletFrame(
          widget1: _buildWidget1(),
          widget2: _buildWidget2(),
          menu: const MenuLeft(
            currentType: MenuHomeType.WALLET_QR,
          ),
        ),
      ),
    );
  }

  Widget _buildWidget1() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _buildCategories(),
        Row(
          children: [
            ButtonIconWidget(
              width: 120,
              height: 36,
              pathIcon: 'assets/images/ic-contact-bank-white.png',
              textSize: 12,
              title: 'Tạo QR Vcard',
              function: () {},
              textColor: AppColor.BLUE_TEXT,
              iconPathColor: AppColor.BLUE_TEXT,
              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
            ),
            const SizedBox(
              width: 8,
            ),
            ButtonIconWidget(
              width: 120,
              height: 36,
              pathIcon: 'assets/images/ic-hook-blue.png',
              textSize: 12,
              title: 'Tạo QR Link',
              function: () {},
              textColor: AppColor.BLUE_TEXT,
              bgColor: AppColor.BLUE_TEXT.withOpacity(0.3),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: BlocConsumer<WalletBloc, ContactState>(
                listener: (context, state) {
          if (state is GetListContactSuccessfulState) {
            contactList = state.list;
            if (state.list.isNotEmpty) {
              context
                  .read<WalletProvider>()
                  .changeContactDto(contactList.first.first);
              bloc.add(ContactEventGetDetail(id: contactList.first.first.id));
            }
          }
        }, builder: (context, state) {
          if (state is WalletLoadingListState) {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Row(
            children: [
              Expanded(flex: 3, child: _buildListContact()),
              const Spacer()
            ],
          );
        }))
      ],
    );
  }

  Widget _buildWidget2() {
    return BlocConsumer<WalletBloc, ContactState>(listener: (context, state) {
      if (state is GetDetailContactSuccessState) {
        contactDetailDTO = state.dto;
        qrGeneratedDTO = getQrDTO(contactDetailDTO);
      }
    }, builder: (context, state) {
      if (state is GetDetailContactLoadingState) {
        return const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return _buildViewCard();
    });
  }

  Widget _buildListContact() {
    if (contactList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text('Không có dữ liệu')),
      );
    } else {
      return Consumer<WalletProvider>(builder: (context, provider, child) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: contactList.length,
          // controller: scrollController,
          separatorBuilder: (context, index) {
            return const SizedBox.shrink();
          },
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: List.generate(
                contactList[index].length,
                (i) {
                  ContactDTO e = contactList[index][i];
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 12, bottom: 12),
                          alignment: Alignment.center,
                          child: Text(
                            e.nickname.isNotEmpty
                                ? e.nickname[0].toUpperCase()
                                : e.nickname.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (i == 0)
                                  ? AppColor.BLACK
                                  : AppColor.TRANSPARENT,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildItemSave(
                              dto: e,
                              isSelect: e.id == provider.contactSelected.id,
                              onTap: () {
                                provider.changeContactDto(e);
                                bloc.add(ContactEventGetDetail(id: e.id));
                              }),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          },
        );
      });
    }
  }

  Widget _buildCategories() {
    return Consumer<WalletProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const Text(
                  'Danh mục QR',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        children: provider.listCategories.map((e) {
                          int index = provider.listCategories.indexOf(e);
                          return _buildItemCategory(e.title, onTap: () {
                            provider.onChangeCategory(e);
                            bloc.add(ContactEventGetList(
                                isLoading: true, type: e.type, offset: 0));
                          },
                              pathIcon: e.url,
                              isSelected: e.type == provider.categoryModel.type,
                              index: index);
                        }).toList())),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColor.BLACK_LIGHT)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  context
                                      .read<WalletProvider>()
                                      .updateKeywordSearch(value);
                                  if (value.isEmpty) {
                                    bloc.add(ContactEventGetList(
                                        isLoading: true,
                                        type: context
                                            .read<WalletProvider>()
                                            .categoryModel
                                            .type,
                                        offset: 0));
                                  }
                                },
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Tìm kiếm thẻ QR',
                                  contentPadding: EdgeInsets.only(
                                      left: 16, right: 16, bottom: 12),
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
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    ButtonWidget(
                        height: 36,
                        width: 80,
                        text: 'Tìm kiếm',
                        textColor: AppColor.WHITE,
                        bgColor: AppColor.BLUE_TEXT,
                        borderRadius: 5,
                        function: () {
                          bloc.add(SearchContactEvent(
                              nickName:
                                  context.read<WalletProvider>().keyWordSearch,
                              type: context
                                  .read<WalletProvider>()
                                  .categoryModel
                                  .type,
                              offset: 0));
                        })
                  ],
                ),
              ),
              const Spacer()
            ],
          )
        ],
      );
    });
  }

  Widget _buildItemCategory(String title,
      {required VoidCallback onTap,
      required String pathIcon,
      bool isSelected = false,
      int index = 0}) {
    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.BLUE_TEXT : AppColor.WHITE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Image.asset(
                pathIcon,
                color: isSelected ? AppColor.WHITE : AppColor.BLUE_TEXT,
                height: index == 0 ? 14 : 26,
              ),
              if (index == 0)
                const SizedBox(
                  width: 8,
                ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? AppColor.WHITE : AppColor.BLUE_TEXT),
              )
            ],
          ),
        ));
  }

  Widget _buildItemSave(
      {required ContactDTO dto,
      bool isSelect = false,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.WHITE,
            border: Border.all(
                color: isSelect ? AppColor.BLUE_TEXT : AppColor.TRANSPARENT)),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColor.GREY_LIGHT.withOpacity(0.3)),
                image: getImage(dto.type, dto.imgId),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto.nickname,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                  ),
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: dto.description,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color:
                                dto.type == 4 ? AppColor.BLACK : dto.bankColor,
                            height: 1.4,
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2.5, left: 8),
                            child: Image.asset(
                              dto.relation == 1
                                  ? 'assets/images/gl-white.png'
                                  : 'assets/images/personal-relation.png',
                              color: AppColor.BLACK.withOpacity(0.7),
                              width: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelect) ...[
              const Icon(
                Icons.arrow_forward_outlined,
                size: 20,
                color: AppColor.BLUE_TEXT,
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildViewCard() {
    if (contactDetailDTO.type == 2) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 400,
              child: VietQRWidget(
                qrGeneratedDTO: qrGeneratedDTO,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 400,
              child: Text(
                'Mô tả QR',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                child: Text(
                  contactDetailDTO.additionalData,
                  maxLines: 4,
                ),
              ),
            ),
            _buildButtonShare(false)
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              width: 400,
              decoration: BoxDecoration(
                  gradient: contactDetailDTO.getBgGradient(),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.only(top: 16),
              margin: const EdgeInsets.only(top: 30, left: 40, right: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: getImage(
                                contactDetailDTO.type, contactDetailDTO.imgId),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contactDetailDTO.nickname,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.BLACK),
                            ),
                            Text(
                              contactDetailDTO.type == 1
                                  ? 'VietQR ID'
                                  : contactDetailDTO.type == 4
                                      ? 'VCard'
                                      : 'Thẻ khác',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColor.BLACK,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(thickness: 1, color: AppColor.WHITE),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 80, right: 80, top: 20),
                    decoration: const BoxDecoration(color: AppColor.WHITE),
                    child: Stack(
                      children: [
                        QrImage(
                          data: contactDetailDTO.value,
                          version: QrVersions.auto,
                          size: 240,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColor.WHITE,
                                borderRadius: BorderRadius.circular(40),
                                image: getImage(contactDetailDTO.type,
                                    contactDetailDTO.imgId),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      contactDetailDTO.nickname,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.WHITE),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(thickness: 1, color: AppColor.WHITE),
                  _buildItem('Số điện thoại', contactDetailDTO.phoneNo),
                  const Divider(thickness: 1, color: AppColor.WHITE),
                  _buildItem(
                      'Email',
                      contactDetailDTO.email.isNotEmpty
                          ? contactDetailDTO.email
                          : '-'),
                  const Divider(thickness: 1, color: AppColor.WHITE),
                  _buildItem(
                      'Ghi chú',
                      contactDetailDTO.additionalData.isNotEmpty
                          ? contactDetailDTO.additionalData
                          : '-'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            _buildButtonShare(true),
            const SizedBox(
              height: 12,
            ),
            ButtonWidget(
                width: 400,
                height: 40,
                text: 'Cập nhật thẻ QR',
                textColor: AppColor.BLUE_TEXT,
                bgColor: AppColor.WHITE.withOpacity(0.4),
                borderRadius: 5,
                function: () {})
          ],
        ),
      );
    }
  }

  Widget _buildButtonShare(bool isVietQRCard) {
    return SizedBox(
      width: 400,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ButtonIconWidget(
              height: 40,
              pathIcon: 'assets/images/ic-print-blue.png',
              title: '',
              bgColor: AppColor.WHITE.withOpacity(0.4),
              textColor: AppColor.ORANGE,
              function: () async {
                String paramData = Session.instance.formatDataParamUrl(
                  qrGeneratedDTO,
                  action: 'PRINT',
                );
                html.window.open(
                    Uri.base.toString().replaceFirst(
                        '/qr-wallet', '/qr_generate/print$paramData'),
                    'new tab');
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Expanded(
            child: ButtonIconWidget(
              height: 40,
              pathIcon: 'assets/images/ic-edit-avatar-setting.png',
              title: '',
              function: () {
                String paramData = Session.instance.formatDataParamUrl(
                  qrGeneratedDTO,
                  action: 'SAVE',
                );
                html.window.open(
                    Uri.base
                        .toString()
                        .replaceFirst('/qr-wallet', '/qr_generate$paramData'),
                    'new tab');
              },
              bgColor: AppColor.WHITE.withOpacity(0.4),
              textColor: AppColor.RED_CALENDAR,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          Expanded(
            child: ButtonIconWidget(
              height: 40,
              pathIcon: 'assets/images/ic-copy-blue.png',
              title: '',
              function: () async {
                if (isVietQRCard) {
                  await FlutterClipboard.copy(Uri.base.toString().replaceFirst(
                          '/qr-wallet',
                          '/qr-wallet/detail?id=${contactDetailDTO.id}'))
                      .then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).hintColor,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                } else {
                  await FlutterClipboard.copy(
                          ShareUtils.instance.getTextSharing(qrGeneratedDTO))
                      .then(
                    (value) => Fluttertoast.showToast(
                      msg: 'Đã sao chép',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).cardColor,
                      textColor: Theme.of(context).hintColor,
                      fontSize: 15,
                      webBgColor: 'rgba(255, 255, 255)',
                      webPosition: 'center',
                    ),
                  );
                }
              },
              bgColor: AppColor.WHITE.withOpacity(0.4),
              textColor: AppColor.BLUE_TEXT,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String content,
      {GestureTapCallback? onTap, TextStyle? style}) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: height < 750 ? 2 : 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(
                color: AppColor.WHITE,
                fontSize: height < 750 ? 12 : 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                content,
                style: style ??
                    TextStyle(
                      color: AppColor.WHITE,
                      fontSize: height < 750 ? 12 : 14,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage getImage(int type, String imageId) {
    if (imageId.isNotEmpty) {
      return DecorationImage(
          image: ImageUtils.instance.getImageNetWork(imageId),
          fit: type == 2 ? BoxFit.contain : BoxFit.cover);
    } else {
      if (type != 1) {
        return const DecorationImage(
            image: AssetImage('assets/images/ic-tb-qr.png'),
            fit: BoxFit.contain);
      } else {
        return const DecorationImage(
            image: AssetImage('assets/images/ic-viet-qr-small.png'),
            fit: BoxFit.contain);
      }
    }
  }
}
