import 'dart:developer';

import 'package:billing/bloc/newItem_bloc/new_item_bloc.dart';
import 'package:billing/bloc/sidedish_bloc/sidedish_bloc.dart';
import 'package:billing/main.dart';
import 'package:billing/models/newItem_request.dart';
import 'package:billing/models/sidedish_detail.dart';
import 'package:billing/widgets/textformfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewItemCreatePage extends StatefulWidget {
  static String routeName = '/newItem';
  const NewItemCreatePage({Key? key}) : super(key: key);

  @override
  State<NewItemCreatePage> createState() => _NewItemCreatePageState();
}

class _NewItemCreatePageState extends State<NewItemCreatePage> {
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  String unit = '';
  late SidedishBloc sidedishBloc;
  late NewItemBloc newItemBloc;
  int id = 0;
  List<SidedishDetail> sidedishList = [];

  List selectedSidedish = [];

  @override
  void initState() {
    sidedishBloc = BlocProvider.of<SidedishBloc>(context);
    sidedishBloc.add(FetchSidedish());
    newItemBloc = BlocProvider.of<NewItemBloc>(context);
    newItemBloc.stream.listen((state) {
      if (state is NewItemDone) {
        showToast(message: "New item created succesfully");
      } else if (state is NewItemError) {
        showToast(message: "Somnething went wrong", isError: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Item"),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: TextButton.icon(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            log(selectedSidedish.join(","));
            context.read<NewItemBloc>().add(createNewitem(NewitemRequest(
                Itemname: itemController.text,
                Itemprice: "100",
                Sidedishes: selectedSidedish.join(","),
                Itemquantity: quantityController.text,
                Itemstatus: true)));
            itemController.clear();
            quantityController.clear();
            unitController.clear();
            selectedSidedish.clear();
          },
          label: const Text("Create"),
          icon: const Icon(Icons.add)),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //    crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.57,
                    child: TextFieldWidget(
                      controller: unitController,
                      title: "",
                    ),
                  ),
                  /*  Container(
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
                  ), */
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
              BlocBuilder<SidedishBloc, SidedishState>(
                builder: (context, state) {
                  if (state is SidedishDone) {
                    sidedishList = state.sidedishList;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: sidedishList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              selected: id == sidedishList[index].ID,
                              selectedTileColor: Theme.of(context).primaryColor,
                              title: Text(
                                sidedishList[index].item,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                      value: selectedSidedish
                                          .contains(sidedishList[index].ID),
                                      onChanged: (value) {
                                        if (value == true) {
                                          setState(() {
                                            selectedSidedish
                                                .add(sidedishList[index].ID);
                                          });
                                        } else {
                                          setState(() {
                                            selectedSidedish
                                                .remove(sidedishList[index].ID);
                                          });
                                        }
                                      })
                                  /*   if (sidedishList[index].ID != id)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () async {
                                        id = sidedishList[index].ID;
                                        itemController.text =
                                            sidedishList[index].item;
                                        setState(() {});
                                      },
                                    )
                                  else
                                    IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        id = 0;
                                        itemController.clear();
                                        setState(() {});
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      /*   sidedishBloc.add(DeleteBranchEvent(
                                          branches[index].ID)); */
                                    },
                                  ), */
                                ],
                              ),
                            );
                          }),
                    );
                  }
                  return CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
