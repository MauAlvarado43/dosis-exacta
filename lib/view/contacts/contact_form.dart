import 'package:dosis_exacta/viewmodel/contact_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class ContactForm extends StatefulWidget {

  const ContactForm({Key? key}) : super(key: key);

  @override
  State<ContactForm> createState() => _ContactFormState();

}

class _ContactFormState extends State<ContactForm> {

  ContactVM viewModel = ContactVM();
  var contact;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  onClickSave() async {

    bool result = false;

    if(contact == null) {
      result = await viewModel.createContact(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text
      );
    }
    else {
      result = await viewModel.updateContact(
        contact,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text
      );
    }

    if(result) {
      Navigator.of(context).pop(true);
    }

  }

  onClickReturn() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if(args != null && args["contact"] != null) {
      setState(() {
        contact = args["contact"];
        _nameController.text = contact.name;
        _emailController.text = contact.email;
        _phoneController.text = contact.phone;
      });
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Detalles",
                  style: AppTextTheme.medium(color: Colors.white)
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 0.06.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 0.04.sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                            child: Text(
                                "Nombre",
                                style: AppTextTheme.medium()
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 0.01.sh),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                        child: TextField(
                          controller: _nameController,
                          decoration: Styles.input(context, controller: _nameController),
                        ),
                      ),
                      SizedBox(height: 0.05.sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                            child: Text(
                              "Correo",
                              style: AppTextTheme.medium()
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 0.01.sh),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                        child: TextField(
                          controller: _emailController,
                          decoration: Styles.input(context, controller: _nameController),
                        ),
                      ),
                      SizedBox(height: 0.05.sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                            child: Text(
                                "Teléfono",
                                style: AppTextTheme.medium()
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 0.01.sh),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.05.sw, 0, 0.05.sw, 0),
                        child: TextField(
                          controller: _phoneController,
                          decoration: Styles.input(context, controller: _nameController),
                        ),
                      ),
                      SizedBox(height: 0.05.sh),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                        child: ElevatedButton(
                          onPressed: onClickSave,
                          style: Styles.button(context, color: AppColors.secondary()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0.01.sh, 0, 0.01.sh),
                                child: Text(
                                  "Guardar",
                                  style: AppTextTheme.medium(color: Colors.white)
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: 0.04.sh),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 0.07.sh),
              Padding(
                padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0),
                child: ElevatedButton(
                    onPressed: onClickReturn,
                    style: Styles.button(context, color: AppColors.primary()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 40.sp),
                        SizedBox(width: 20.sp),
                        Text(
                          "Regresar",
                          style: AppTextTheme.medium(color: Colors.white)
                        ),
                        SizedBox(width: 25.sp),
                      ],
                    )
                ),
              ),
            ],
          ),
        )
    );

  }

}