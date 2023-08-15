import 'package:flutter/material.dart';
import 'package:ncn/utils/constant.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        padding: EdgeInsets.symmetric(
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
                const Text("N/A")
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
                const Text("N/A")
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
                    child: const Text("Collection Today",

                      style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),
                    )
                ),
                Divider(),
                Text("N/A")
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
                    child: const Text("Collection (Month)",

                      style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),
                    )
                ),
                Divider(),
                Text("N/A")
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
                    child: const Text("Balance",

                      style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),
                    )
                ),
                const Divider(),
                const Text("N/A")
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
                Text("N/A")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
