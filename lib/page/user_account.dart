import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ncn/model/api/customer_api.dart';
import 'package:ncn/model/data_class/user_model.dart';
import '../main.dart';
import '../model/data_class/response_model.dart';
import '../utils/constant.dart';
import '../utils/shared_pref_manager.dart';
import '../utils/text_style.dart';
import 'login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool loading = false;

  void loadUserProfile() async{
    setState(() {
      loading = true;
    });
    ResponseModel responseModel = await CustomerAPI.userData();
    setState(() {
      loading = false;
    });

    if(responseModel.statusCode==200){
      userDataModel = UserModel.fromJSON(jsonDecode(responseModel.body));
      setState(() {

      });
    }else{
      if(!mounted) return;
      showDialog(context: context,
          builder: (ctx){
            return  AlertDialog(
              title: const Text("Message"),
              content: const Text("Failed to load user information. contact with support"),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Close")
                ),

              ],
            );
          }
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (userDataModel==null) const Center(
            child: Text("Failed to load information"),
          ) else SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),

                const Divider(),
                getRowItem(
                    label: "Name",
                    value: userDataModel!.name
                ),
                const Divider(),
                getRowItem(
                  label: "User Name",
                  value: userDataModel!.userName,

                ),
                const Divider(),
                getRowItem(
                    label: "Password",
                    value: "******",
                    editIcon: IconButton(
                        onPressed: (){
                          changePassword();
                        },
                        icon: const Icon(Icons.edit_note,
                          color: mainColor,
                        )
                    )
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (ctx){
                            return  AlertDialog(
                              title: const Text("Are you sure you want to logout"),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Back")
                                ),
                                TextButton(
                                    onPressed: (){
                                      userDataModel = null;
                                      SharedPrefManager.instance.logout();
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx)=>const LoginPage()), (route) => false);
                                    },
                                    child: const Text("Logout")
                                )
                              ],
                            );
                          }
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.red[900]
                      )
                    ),
                    label: const Text("Logout",style: TextStyle(color: Colors.white),),
                    icon: const Icon(Icons.logout,color: Colors.white,),
                )
              ],
            ),
          ),
          loading?Positioned(
              child: Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator())
              )
          ):Container()
        ],
      ),
    );
  }
  Widget getRowItem({required String label,required String value,IconButton? editIcon}){
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10
      ),
      child: Row(
        children: [
           SizedBox(
             width: 125,
             child: Text(label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
          ),
           ),
          const Text(" : ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),),
          const SizedBox(
            width: 5,
          ),
          Expanded(child: Text(value,
            style: const TextStyle(
              fontSize: 16,
            ),
          )),
          editIcon??Container()
        ],
      ),
    );
  }
  // changeDisplayName(){
  //   TextEditingController controller = TextEditingController();
  //   GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //   showDialog(context: context,
  //       builder: (ctx){
  //         return  AlertDialog(
  //           title: const Text("Enter Display Name"),
  //           content: Form(
  //             key: formKey,
  //             child: TextFormField(
  //               controller: controller,
  //               validator: (str){
  //                 if(str!.isEmpty){
  //                   return "required";
  //                 }else{
  //                   return null;
  //                 }
  //               },
  //               decoration: const InputDecoration(
  //                   hintText: "Display Name",
  //                   label: Text("Display Name")
  //               ),
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: (){
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text("Cancel")
  //             ),
  //             TextButton(
  //                 onPressed: (){
  //                   if(formKey.currentState!.validate()){
  //                     Navigator.pop(context);
  //                     editDisplayName(controller.text);
  //                   }
  //                 },
  //                 child: const Text("Update")
  //             )
  //           ],
  //         );
  //       }
  //   );
  // }
  changePassword(){
    TextEditingController oldPasswordController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(context: context,
        builder: (ctx){
          return  AlertDialog(
            title: const Text("Change Password"),
            scrollable: true,
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (str){
                      if(str!.isEmpty){
                        return "required";
                      }else if(str.length < 6){
                        return "Password must be 6 digit or more";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      hintText: 'Old Password',
                      hintStyle: hintStyle1,
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    ),
                    style: bodyStyle1,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 0.1,
                    color: Color(0xFF111111),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (str){
                      if(str!.isEmpty){
                        return "required";
                      }else if(str.length < 6){
                        return "Password must be 6 digit or more";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'New Password',
                      hintStyle: hintStyle1,
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    ),
                    style: bodyStyle1,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 0.1,
                    color: Color(0xFF111111),
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    validator: (str){
                      if(str!.isEmpty){
                        return "required";
                      }else if(str != passwordController.text){
                        return "Password didn't match";
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm Password',
                      hintStyle: hintStyle1,
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    ),
                    style: bodyStyle1,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")
              ),
              TextButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      Navigator.pop(context);
                      editPassword(passwordController.text,oldPasswordController.text);
                    }
                  },
                  child: const Text("Update")
              )
            ],
          );
        }
    );
  }
  editPassword(String newPassword,String oldPassword) async{
    var formData = {
      "newPassword":newPassword,
      "oldPassword":oldPassword,
    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await CustomerAPI.updatePassword(formData);
    setState(() {loading = false;});

    if(response.statusCode==202){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Updated",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));

    }else{
      if(!mounted) return;
      showDialog(context: context,
          builder: (ctx){
            String message = "Failed to update password";
            if(response.statusCode == 204){
              message = "Old Password doesn't matched";
            } else if(response.statusCode == 400){
              message = "Something Wrong . Please Contact with support";
            }
            return  AlertDialog(
              title: const Text("Message"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Close")
                ),

              ],
            );
          }
      );
    }

  }
}
