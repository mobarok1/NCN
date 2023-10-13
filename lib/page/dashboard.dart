import 'package:flutter/material.dart';
import 'package:ncn/main.dart';
import 'package:ncn/model/data_class/summery.dart';
import 'package:ncn/repository/report_repository.dart';
import 'package:ncn/utils/constant.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  bool loading = false;
  SummeryReport? summeryReport = SummeryReport(totalCustomer: 0, totalDevice: 0, expireDevice: 0, balance: 0.0);
  TextEditingController textEditingController = TextEditingController();

  getReport() async{
    setState(() {
      loading = true;
    });
    summeryReport = await SummeryReportRepository.getSummery(userDataModel!.netId);
    summeryReport ??= SummeryReport(totalCustomer: 0, totalDevice: 0, expireDevice: 0, balance: 0.0);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getReport();
  }

  @override
  Widget build(BuildContext context) {
    return loading?const Center(
      child: CircularProgressIndicator(),
    ):GridView(
      padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1,
          mainAxisExtent: 100,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),
      children: [
        Card(
          surfaceTintColor: mainColor,
          shadowColor: mainColor,
          elevation: 1,
          child: Column(
            children: [
              Container(
                  margin:const EdgeInsets.only(
                      top: 10
                  ),
                  child: const Text("Total Customer",

                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  )
              ),
              const Divider(),
              Text(summeryReport!.totalCustomer.toString())
            ],
          ),
        ),
        Card(
          surfaceTintColor: mainColor,
          shadowColor: mainColor,
          elevation: 1,
          child: Column(
            children: [
              Container(
                  margin:const EdgeInsets.only(
                      top: 10
                  ),
                  child: const Text("Total Device",

                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  )
              ),
              const Divider(),
              Text(summeryReport!.totalDevice.toString())
            ],
          ),
        ),
        // Card(
        //   surfaceTintColor: mainColor,
        //   shadowColor: mainColor,
        //   elevation: 1,
        //   child: Column(
        //     children: [
        //       Container(
        //           margin:const EdgeInsets.only(
        //               top: 10
        //           ),
        //           child: const Text("Collection Today",
        //
        //             style: TextStyle(
        //                 fontWeight: FontWeight.w600
        //             ),
        //           )
        //       ),
        //       Divider(),
        //       Text("N/A")
        //     ],
        //   ),
        // ),
        // Card(
        //   surfaceTintColor: mainColor,
        //   shadowColor: mainColor,
        //   elevation: 1,
        //   child: Column(
        //     children: [
        //       Container(
        //           margin:const EdgeInsets.only(
        //               top: 10
        //           ),
        //           child: const Text("Collection (Month)",
        //
        //             style: TextStyle(
        //                 fontWeight: FontWeight.w600
        //             ),
        //           )
        //       ),
        //       Divider(),
        //       Text("N/A")
        //     ],
        //   ),
        // ),
        Card(
          surfaceTintColor: mainColor,
          shadowColor: mainColor,
          elevation: 1,
          child: Column(
            children: [
              Container(
                  margin:const EdgeInsets.only(
                      top: 10
                  ),
                  child: const Text("Balance",

                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  )
              ),
              const Divider(),
              Text(summeryReport!.balance.toStringAsFixed(2))
            ],
          ),
        ),
        Card(
          surfaceTintColor: mainColor,
          shadowColor: mainColor,
          elevation: 1,
          child: Column(
            children: [
              Container(
                  margin:const EdgeInsets.only(
                      top: 10
                  ),
                  child: const Text("Expired Device",

                    style: TextStyle(
                        fontWeight: FontWeight.w600
                    ),
                  )
              ),
              Divider(),
              Text(summeryReport!.expireDevice.toString())
            ],
          ),
        ),
      ],
    );
  }
}
