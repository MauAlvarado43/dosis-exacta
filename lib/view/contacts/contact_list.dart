import 'package:dosis_exacta/viewmodel/contact_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/theme.dart';

class ContactList extends StatefulWidget {

  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();

}

class _ContactListState extends State<ContactList> {

  bool isLoading = true;
  ContactVM viewModel = ContactVM();
  var contacts = [];

  refreshContacts() async {
    var updatedContacts = (await viewModel.getContacts())!.cast<dynamic>();
    setState(() {
      contacts = updatedContacts;
    });
  }

  onClickEdit(int index) async {
     var result = await Navigator.of(context).pushNamed("/contacts/form", arguments: { "contact": contacts[index] });
     if(result == true) refreshContacts();
  }

  onClickDelete(int index) async {
    var result = await viewModel.deleteContact(contacts[index]);
    if(result == true) refreshContacts();
  }

  onClickReturn() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await refreshContacts();
      setState(() {
        isLoading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Scaffold() : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Contactos",
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
              SizedBox(height: 0.04.sh),
              SizedBox(
                height: 0.70.sh,
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0.03.sw, 0, 0.03.sw, 0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0.02.sh, 0.1.sw, 0.02.sh),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50.sp,
                                    height: 50.sp,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        color: AppColors.darkbg(),
                                        child: Icon(Icons.person, color: Colors.white, size: 40.sp),
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.05.sw,
                                  ),
                                  Expanded(
                                    child: Text(
                                      contacts[index].name,
                                      style: AppTextTheme.medium(),
                                      maxLines: 3,
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0.1.sw, 0, 0.1.sw, 0.02.sh),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 0.3.sw,
                                    child: ElevatedButton(
                                      onPressed: () { onClickEdit(index); },
                                      style: Styles.button(context, color: AppColors.accent()),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Editar",
                                          style: AppTextTheme.medium(color: Colors.white)
                                        ),
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.3.sw,
                                    child: ElevatedButton(
                                        onPressed: () { onClickDelete(index); },
                                      style: Styles.button(context, color: AppColors.danger()),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Eliminar",
                                          style: AppTextTheme.medium(color: Colors.white)
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                )

              ),
              SizedBox(height: 0.05.sh),
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