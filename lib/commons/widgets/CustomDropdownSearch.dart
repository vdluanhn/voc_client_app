import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../model/ComboData.dart';
import '../themes/app_color.dart';
import '../themes/app_style.dart';

class CustomDropdownSearch extends StatelessWidget {
  final List<ComboData> datas;
  final ComboData? itemSelected;
  final String? hintText;
  final String? labelText;
  final String labelPopup;
  final String? keyRecent;
  final Function(ComboData)? onChanged;
  final bool? showSearchBox;
  final double? ratioHeight;
  final Mode? mode;
  final bool? enable;
  final OutlineInputBorder? enabledBorder;
  const CustomDropdownSearch({
    Key? key,
    required this.datas,
    this.itemSelected,
    this.hintText = " Chọn",
    this.labelText = "Chọn",
    this.labelPopup = "Chọn",
    this.keyRecent = "lskdfslkdfjlsajfklsd",
    this.onChanged,
    this.showSearchBox = true,
    this.ratioHeight,
    this.enable = true,
    this.mode = Mode.BOTTOM_SHEET,
    this.enabledBorder = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<ComboData>(
      compareFn: (item, selectedItem) => item?.name == selectedItem?.name,
      showSearchBox: showSearchBox ?? true,
      showSelectedItems: true,
      isFilteredOnline: false,
      showClearButton: false,
      mode: mode ?? Mode.BOTTOM_SHEET,
      items: datas,
      enabled: enable ?? true,
      selectedItem: itemSelected,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      maxHeight: MediaQuery.of(context).size.height * (ratioHeight ?? 0.5),
      //style dropdown
      dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SIZES.kRadiusDefault),
            borderSide: BorderSide(color: AppColor.primaryColor),
          ),
          enabledBorder: enabledBorder != null ? enabledBorder : OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(SIZES.kRadiusDefault))),
      //icon clear value if showClearButton: true
      clearButtonBuilder: (_) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.clear,
          size: 24,
          color: Colors.green,
        ),
      ),
      //item dropdown
      dropdownButtonBuilder: (_) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.arrow_drop_down,
          size: 24,
          color: Colors.black,
        ),
      ), //style Popup show
      popupTitle: Container(
        padding: const EdgeInsets.only(top: SIZES.kPadingDefault, left: SIZES.kPadingDefault, right: SIZES.kPadingDefault),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                labelPopup,
                style: TextStyle(
                  fontSize: SIZES.kTextHeaderSize,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Divider(),
          ],
        ),
      ),
      //style bo tron 2 canh tren popup
      popupShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SIZES.kRadiusDefault),
          topRight: Radius.circular(SIZES.kRadiusDefault),
        ),
      ),
      //Style ô search trong popup combo
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SIZES.kRadiusDefault),
            borderSide: BorderSide(color: AppColor.primaryColor),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
          labelText: "Tìm kiếm",
          hintText: "Nhập từ khóa tìm kiếm",
          // suffixIcon: IconButton(
          //   icon: Icon(Icons.clear),
          //   onPressed: () {
          //     print("click clear text");
          //   },
          // ),
        ),
      ),
      //valid neu null
      validator: (u) => u == null ? "Vui lòng chọn giá trị" : null,
      itemAsString: (ComboData? u) => u!.name,
      onChanged: (ComboData? data) => onChanged!(data!),
      popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
      //show flag scrollbar
      scrollbarProps: ScrollbarProps(
        isAlwaysShown: true,
        thickness: 5,
      ),
      //Show gợi ý lên popup chọn item
      showFavoriteItems: true,
      favoriteItemsAlignment: MainAxisAlignment.start,
      favoriteItems: (items) {
        return items.where((e) => e.name.toLowerCase().contains(keyRecent != null ? keyRecent!.toLowerCase() : "skjdfhksajfhksjfjksdf")).toList();
      },
      favoriteItemBuilder: (context, item, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10), color: Colors.grey[100]),
          child: Row(
            children: [
              Text(
                "${item.name}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.indigo),
              ),
              Padding(padding: EdgeInsets.only(left: 8)),
              isSelected ? Icon(Icons.check, color: Colors.green) : Container(),
            ],
          ),
        );
      },
    );
  }
}
