import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:VietQR/models/branch_text_controller_dto.dart';
import 'package:VietQR/models/business_member_dto.dart';
import 'package:flutter/material.dart';

class AddBusinessProvider with ChangeNotifier {
  bool _isInitial = false;
  final List<BusinessMemberDTO> _memberList = [];
  final List<BranchTextController> _branchTextControllers = [];

  bool get isInitial => _isInitial;
  List<BusinessMemberDTO> get memberList => _memberList;
  List<BranchTextController> get branchTextControllers =>
      _branchTextControllers;
  Uint8List? _bytesData;
  Uint8List? get bytesData => _bytesData;
  List<int>? _selectedFile;
  List<int>? get selectedFile => _selectedFile;
  void setInitial(bool value) {
    _isInitial = value;
    notifyListeners();
  }

  void addMemberList(BusinessMemberDTO dto) {
    _memberList.add(dto);
    notifyListeners();
  }

  void addTextController(BranchTextController controller) {
    _branchTextControllers.add(controller);
    notifyListeners();
  }

  void removeMemberList(int index) {
    _memberList.removeAt(index);
    notifyListeners();
  }

  void removeTextController(int index) {
    _branchTextControllers.removeAt(index);
    notifyListeners();
  }

  void reset() {
    _isInitial = false;
    _memberList.clear();
    _branchTextControllers.clear();
  }

  bool isExistedMember(String userId) {
    bool result = false;
    if (_memberList.where((element) => element.userId == userId).isNotEmpty) {
      result = true;
    }
    return result;
  }

  openImagePicker({required Function(List<int>) upload}) async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.png,.jpg';
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();
      reader.onLoadEnd.listen((event1) {
        _bytesData = const Base64Decoder()
            .convert(reader.result.toString().split(",").last);
        _selectedFile = _bytesData;
        upload(_selectedFile!);
        notifyListeners();
      });
      reader.readAsDataUrl(file);
    });
  }
}
