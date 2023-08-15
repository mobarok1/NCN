import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ncn/model/api/customer_api.dart';
import 'package:ncn/model/data_class/user_model.dart';
import '../main.dart';
import '../model/data_class/credential.dart';
import '../model/data_class/response_model.dart';
import '../utils/app_constant.dart';
import '../utils/constant.dart';
import '../utils/shared_pref_manager.dart';
import '../utils/text_style.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  bool passwordVisibility = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkEmail();
  }

  checkEmail() async{
    await initStorage();
    String userName = await SharedPrefManager.instance.getAccountUserName();
    String password = await SharedPrefManager.instance.getAccountPassword();

    if(userName.isNotEmpty && password.isNotEmpty){
      userNameController.text = userName;
      passwordController.text = password;
      login();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading?const Center(child: CircularProgressIndicator()):
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.purpleAccent,
                Colors.deepPurpleAccent
              ]

          )
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 15
            ),
            child: TweenAnimationBuilder(
                tween: Tween(begin: 0.8,end: 1),
                curve: Curves.bounceOut,
                duration: const Duration(milliseconds: 1000),
                builder: (ctx,num value,child){
                  return Transform.scale(
                    scale: value.toDouble(),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shadowColor: mainColor,
                      color: const Color(0xFFFDFDFD),
                      elevation: 1,
                      margin: EdgeInsets.only(
                        left: (1-value.toDouble())*100
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 35, 20, 30),
                        child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                'Nazimkhan Cable Network'.toUpperCase(),
                                style: title1.copyWith(
                                    color: mainColor,
                                    fontSize: 18
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Text(
                                'Login',
                                style: title1.copyWith(
                                    color: Colors.black,
                                    fontSize: 20
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                  controller: userNameController,
                                  autofocus: false,
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  validator: (str){
                                    if(str!.isEmpty){
                                      return "required";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'User Name',
                                    hintText: 'User Name',
                                    hintStyle: hintStyle1,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  ),
                                  style: bodyStyle1
                              ),
                              const Divider(
                                height: 20,
                                thickness: 0.2,
                                color: Color(0xFF111111),
                              ),
                              TextFormField(
                                controller: passwordController,
                                obscureText: !passwordVisibility,
                                textInputAction: TextInputAction.done,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (str){
                                  if(str!.isEmpty){
                                    return "required";
                                  }{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Password',
                                  hintStyle: hintStyle1,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                  suffixIcon: InkWell(
                                    onTap: () => setState(() => passwordVisibility = !passwordVisibility,),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                style:
                                bodyStyle1,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                    if(formKey.currentState!.validate()){
                                      login();
                                    }
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(7)
                                        )
                                    ),
                                    backgroundColor: MaterialStatePropertyAll(
                                      mainColor
                                    ),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 30
                                        )
                                    )
                                ),
                                child: const Text('LOGIN',style: TextStyle(
                                  color: Colors.white
                                ),),

                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ),
      )
    );
  }

  void login() async{
    var formData = {
      "userName":userNameController.text,
      "password":passwordController.text
    };
    setState(() {
      loading = true;
    });
    ResponseModel response = await CustomerAPI.login(formData);

    if(response.statusCode==200){

      SharedPrefManager.instance.setAccountUserName(userNameController.text);
      SharedPrefManager.instance.setAccountPassword(passwordController.text);

      credentialModel = CredentialModel.fromJSON(jsonDecode(response.body));
      ResponseModel responseModel = await CustomerAPI.userData();
      if(!mounted) return;
      setState(() {loading = false;});
      print(responseModel.statusCode);
      if(responseModel.statusCode==200){
        userDataModel = UserModel.fromJSON(jsonDecode(responseModel.body));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx)=>const HomePage()), (route) => false);
      }else{
        String message = "Failed to load user info";
        if(response.body != null){
          var body = response.body;
          if(body!=""){
            message = body;
          }
        }
        showDialog(context: context,
            builder: (ctx){
              return  AlertDialog(
                title: const Text("Message"),
                content:  Text(message),
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


    }else{
      if(!mounted) return;
      setState(() {loading = false;});



      showDialog(context: context,
          builder: (ctx){
            String message = "failed to login";
            if(response.body != null){
              var body = response.body;
              if(body!=""){
                message = body.toString();
              }
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
