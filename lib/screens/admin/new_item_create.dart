import 'package:billing/widgets/textformfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class NewItemCreatePage extends StatefulWidget {
  static String routeName = '/newItem';
  const NewItemCreatePage({Key? key}) : super(key: key);

  @override
  State<NewItemCreatePage> createState() => _NewItemCreatePageState();
}

class _NewItemCreatePageState extends State<NewItemCreatePage> {
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String unit = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Item"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  controller: itemController,
                  title: "Name",
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4 - 10,
                      child: TextFieldWidget(
                        controller: quantityController,
                        title: "Quantity",
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6 - 10,
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: DropdownSearch<String>(
                        popupProps: const PopupProps.menu(
                          showSelectedItems: true,
                        ),
                        items: const ["Piece", "Weight(in grams)"],
                        onChanged: (value) {
                          setState(() {
                            unit = value ?? "";
                          });
                        },
                        selectedItem: unit,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Side Dishes",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_box_rounded,
                            size: 30,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
