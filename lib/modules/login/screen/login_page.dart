import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voc_client_app/commons/widgets/InputFormFieldCustom.dart';
import 'package:voc_client_app/modules/login/view_model/login_vm.dart';
import '../../../commons/model/ComboData.dart';
import '../../../commons/themes/app_color.dart';
import '../../../commons/widgets/CustomDropdownSearch.dart';
import '../../../commons/widgets/LoadingSpinner.dart';
import '../../../commons/widgets/primaryButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    LoginVM loginViewModel = Provider.of<LoginVM>(context, listen: false);
    loginViewModel.resetState();
    loginViewModel.loadDataInitPage(context);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var paddingTop = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,
          body: Consumer<LoginVM>(
            builder: (context, vm, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                          //     image: DecorationImage(
                          //   image: AssetImage("assets/images/bannervoc.png"),
                          //   fit: BoxFit.cover,
                          // )
                          gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.red,
                        ],
                      )),
                      height: screenSize.height,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: kToolbarHeight + paddingTop,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 70,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/logovoc.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                color: Colors.white.withOpacity(0.7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "ĐĂNG NHẬP",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InputFormFieldCustom(
                                        controller: vm.usernameTC,
                                        showSuffixIcon: ShowSuffixIcon.SHOW,
                                        lableText: "Tên đăng nhập",
                                        hintText: "Nhập tên đăng nhập",
                                        suffixIcon: const Icon(Icons.verified_user),
                                        onTapSuffixIcon: () async {},
                                        onTextChange: (value) {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InputFormFieldCustom(
                                        controller: vm.passwordTC,
                                        showSuffixIcon: ShowSuffixIcon.SHOW,
                                        lableText: "Mật khẩu",
                                        hintText: "Nhập mật khẩu",
                                        maxLines: 1,
                                        obscureText: true,
                                        suffixIcon: const Icon(Icons.password),
                                        onTapSuffixIcon: () async {},
                                        onTextChange: (value) {},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomDropdownSearch(
                                        labelPopup: "Chọn hạng thi",
                                        labelText: "Hạng thi",
                                        hintText: "Chọn hạng thi",
                                        keyRecent: null,
                                        showSearchBox: false,
                                        ratioHeight: 0.4,
                                        datas: vm.racingLevels.map((m) => ComboData.fromLevel(m)).toList().cast<ComboData>(),
                                        itemSelected: vm.racingLevelSelected == null ? null : vm.racingLevelSelected!.toComboData(),
                                        onChanged: (data) {
                                          print(data.name);
                                          vm.onSelectRacingLevel(data.toLevel(data));
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 1),
                                      child: CustomDropdownSearch(
                                        labelPopup: "Chọn bài thi",
                                        labelText: "Bài thi",
                                        hintText: "Chọn bài thi",
                                        keyRecent: null,
                                        showSearchBox: false,
                                        ratioHeight: 0.4,
                                        datas: vm.racingTypes.map((m) => ComboData.fromType(m)).toList().cast<ComboData>(),
                                        itemSelected: vm.racingTypeSelected == null ? null : vm.racingTypeSelected!.toComboData(),
                                        onChanged: (data) {
                                          print(data.name);
                                          vm.onSelectRacingType(data.toType(data));
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                            fillColor: MaterialStateProperty.all(Colors.white),
                                            checkColor: Colors.green,
                                            value: vm.isSavePwd,
                                            onChanged: (value) {
                                              setState(() {
                                                vm.isSavePwd = value ?? false;
                                                print("value check ${vm.isSavePwd}");
                                              });
                                            }),
                                        Text("Lưu mật khẩu", style: TextStyle(color: Colors.black))
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 14),
                                        child: PrimaryButton(
                                            text: 'Đăng nhập',
                                            onPressed: () {
                                              vm.login(context);
                                            })),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              )),
                          Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text('VOC v1', style: TextStyle(color: AppColor.white)),
                          )
                        ],
                      ),
                    ),
                  ),
                  (vm.processing)
                      ? Container(
                          alignment: AlignmentDirectional.center,
                          color: AppColor.black.withOpacity(0.3),
                          child: Center(
                            child: LoadingSpinner(),
                          ),
                        )
                      : SizedBox(),
                ],
              );
            },
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
