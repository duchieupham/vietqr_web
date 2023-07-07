import 'package:VietQR/features/bank/views/input_auth_information_view.dart';
import 'package:VietQR/features/bank/views/policy_bank_view.dart';
import 'package:VietQR/services/providers/add_bank_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBankCardView extends StatefulWidget {
  final int initialPage;
  final String bankAccount;
  final String userBankName;
  const AddBankCardView(
      {super.key,
      this.bankAccount = '',
      this.initialPage = 0,
      this.userBankName = ''});

  @override
  State<AddBankCardView> createState() => _AddBankCardViewState();
}

class _AddBankCardViewState extends State<AddBankCardView> {
  late PageController _pageController;

  final bankAccountController = TextEditingController();
  final nationalController = TextEditingController();
  final phoneAuthController = TextEditingController();
  final nameController = TextEditingController();

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initData(context);
  }

  void initData(BuildContext context) {
    if (widget.bankAccount.isNotEmpty) {
      bankAccountController.value =
          bankAccountController.value.copyWith(text: widget.bankAccount);
    }
    if (widget.userBankName.isNotEmpty) {
      nameController.value =
          nameController.value.copyWith(text: widget.userBankName);
    }
    _pageController = PageController(initialPage: widget.initialPage);

    _pages.addAll(
      [
        InputAuthInformationView(
          bankAccountController: bankAccountController,
          nameController: nameController,
          phoneAuthenController: phoneAuthController,
          nationalController: nationalController,
          callBack: (index) {
            _animatedToPage(index);
          },
        ),
        PolicyBankView(
          key: const PageStorageKey('POLICY_BANK'),
          bankAccountController: bankAccountController,
          nameController: nameController,
          nationalController: nationalController,
          phoneAuthenController: phoneAuthController,
          callBack: (index) {
            _animatedToPage(index);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Liên kết tài khoản ngân hàng',
                style: TextStyle(fontSize: 18),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).cardColor),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              key: const PageStorageKey('PAGE_CREATE_QR_VIEW'),
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                Provider.of<AddBankProvider>(context, listen: false)
                    .updateIndex(index);
              },
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

  //navigate to page
  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    bankAccountController.clear();
    nationalController.clear();
    phoneAuthController.clear();
    nameController.clear();
    _pages.clear();
    _pageController.dispose();
    super.dispose();
  }
}
