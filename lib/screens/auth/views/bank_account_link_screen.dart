import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
class BankAccountLinkScreen extends StatefulWidget {
  const BankAccountLinkScreen({super.key});

  @override
  _BankAccountLinkScreenState createState() => _BankAccountLinkScreenState();
}

class _BankAccountLinkScreenState extends State<BankAccountLinkScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController signatureController = TextEditingController();
  String? selectedBank;
  String? selectedMonth;
  String? selectedYear;
  String? hoveredBank;

  final List<String> banks = ["Vietcombank", "Techcombank", "BIDV", "ACB", "VPBank"];
  final List<String> months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> years = List.generate(10, (index) => (DateTime.now().year + index).toString());

  void _linkBankAccount() {
    if (selectedBank == null ||
        cardNumberController.text.length != 19 ||
        accountHolderController.text.isEmpty ||
        selectedMonth == null ||
        selectedYear == null ||
        signatureController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ và đúng thông tin!")),
      );
      return;
    }

    // Dữ liệu cần gửi về màn hình trước
    String bankInfo = "$selectedBank - ${accountHolderController.text}";

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tài khoản ngân hàng đã được liên kết thành công!")),
    );

    Navigator.pop(context, bankInfo); // Gửi dữ liệu về AccountSettingsScreen
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Liên kết tài khoản ngân hàng"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_buildDropdownField("Chọn ngân hàng", banks, (value) => setState(() => selectedBank = value)),
            _buildBankSelector(),
            _buildStyledTextField("Số thẻ (16 số)", cardNumberController, isNumeric: true, formatCardNumber: true, maxLength: 19),
            _buildStyledTextField("Họ và tên (IN HOA, KHÔNG DẤU)", accountHolderController, isUppercase: true),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Hạn sử dụng thẻ:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDropdownWithEffect(
                            "Tháng",
                            months,
                                (value) => setState(() => selectedMonth = value),
                            selectedMonth
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdownWithEffect(
                            "Năm",
                            years,
                                (value) => setState(() => selectedYear = value),
                            selectedYear
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildStyledTextField("Chữ ký (3 số)", signatureController, isNumeric: true, maxLength: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _linkBankAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Xác nhận", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //Han su dung the
  Widget _buildDropdownWithEffect(
      String label, List<String> items, ValueChanged<String?> onChanged, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: selectedValue,
          hint: Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
          isExpanded: true,
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250, // 🔥 Giới hạn chiều cao dropdown
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBankSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: PopupMenuButton<String>(
        onSelected: (value) => setState(() => selectedBank = value),
        itemBuilder: (context) => banks.map((bank) {
          return PopupMenuItem<String>(
            value: bank,
            child: MouseRegion(
              onEnter: (_) => setState(() => hoveredBank = bank), // Khi rê chuột vào
              onExit: (_) => setState(() => hoveredBank = null),  // Khi rời chuột khỏi
              child: InkWell(
                onTap: () {
                  setState(() => selectedBank = bank);
                  Navigator.pop(context);
                },
                splashColor: Colors.blue.shade100, // Hiệu ứng gợn nước
                highlightColor: Colors.blue.shade50, // Màu nền khi nhấn
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: hoveredBank == bank ? Colors.blue.shade50 : Colors.white, // Đổi màu khi hover
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(bank, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          );
        }).toList(),
        position: PopupMenuPosition.under,
        offset: const Offset(100, 0),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedBank ?? "Chọn ngân hàng",
                style: TextStyle(fontSize: 16, color: selectedBank != null ? Colors.black : Colors.grey.shade700),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  /// **Hàm tạo Dropdown chọn ngân hàng, tháng, năm**
  Widget _buildDropdownField(String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue.shade600),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  /// **Hàm tạo TextField có định dạng**
  Widget _buildStyledTextField(
      String label,
      TextEditingController controller, {
        bool isNumeric = false,
        bool formatCardNumber = false,
        bool isUppercase = false,
        int? maxLength,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          if (isNumeric) FilteringTextInputFormatter.digitsOnly,
          if (formatCardNumber) CardNumberInputFormatter(), // Formatter số thẻ
          if (isUppercase) UpperCaseTextFormatter(), // Formatter in hoa
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }
}

/// **Formatter số thẻ (XXXX XXXX XXXX XXXX)**
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), ''); // Loại bỏ ký tự không phải số

    if (digits.length > 16) {
      digits = digits.substring(0, 16);
    }

    List<String> groups = [];
    for (int i = 0; i < digits.length; i += 4) {
      groups.add(digits.substring(i, i + 4 > digits.length ? digits.length : i + 4));
    }

    String formatted = groups.join(" "); // Ghép các nhóm lại thành `XXXX XXXX XXXX XXXX`

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// **Formatter chuyển văn bản thành in hoa**
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
