import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_project/screens/schedule_screen.dart';
import 'package:rive/rive.dart';

import '../blocs/settings_bloc/settings_bloc.dart';
import '../generated/l10n.dart';
import '../services/parse.dart';
import '../widgets/bottom_navigation_bar.dart';

class CanteenScreen extends StatefulWidget {
  final Canteen canteen;
  final DateTime dateTime;

  const CanteenScreen({Key? key, required this.canteen, required this.dateTime})
      : super(key: key);

  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

bool isStudentDiscount = false;
List<Item> selectedItems = [];
Map<Item, Color?> itemColors = {};
Map<Item, Color?> itemIconColors = {};

class _CanteenScreenState extends State<CanteenScreen> {
  void clearCart() {
    setState(() {
      selectedItems.clear();
      itemColors.clear();
      itemIconColors.clear();
    });
  }

  void setItemColor(Item item, Color? color) {
    setState(() {
      itemColors[item] = color;
    });
  }

  void setItemIconColor(Item item, Color? color) {
    setState(() {
      itemIconColors[item] = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle the back button press here
        pushToMainScreen(context);
        return false; // Return false to disable the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Canteen Menu ${widget.canteen.date}',
            style: const TextStyle(fontSize: 21),
          ),
          // titleTextStyle: const TextStyle(fontSize: 21),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              pushToMainScreen(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () {
                showShoppingCartDialog(context);
              },
            ),
          ],
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.primaryDelta! > 20) {
              // If the user swipes from left to right, navigate back
              pushToMainScreen(context);
            }
          },
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.dateTime.weekday != 6 && widget.dateTime.weekday != 7) {
      return ListView.builder(
        itemCount: widget.canteen.cat.length,
        itemBuilder: (context, index) {
          return CategoryTileContent(
            category: widget.canteen.cat[index],
            selectedItems: selectedItems,
            toggleItemInCart: toggleItemInCart,
          );
        },
      );
    } else {
      return _buildEmptyListWidget(context);
    }
  }

  Widget _buildEmptyListWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.7,
            child: const RiveAnimation.asset(
              'assets/anims/empty.riv',
            ),
          ),
        ),
        Text(
          S.of(context).emptyCanteen,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  void pushToMainScreen(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ScheduleScreen({'group': bloc.settings.group as String}),
      ),
    );
  }

  void showShoppingCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShoppingCartDialog(
          isStudentDiscount: isStudentDiscount,
          selectedItems: selectedItems,
          onStudentDiscountChanged: (value) {
            setState(() {
              isStudentDiscount = value;
            });
          },
        );
      },
    );
  }

  double calculateTotal() {
    double total = 0;
    for (Item item in selectedItems) {
      try {
        double price = double.parse(item.iprice.replaceAll(',', '.'));
        total += price;
      } catch (e) {
        print("Error parsing price for item ${item.iname}: $e");
      }
    }
    return isStudentDiscount ? total * 0.9 : total;
  }

  void toggleItemInCart(Item item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }
}

class ShoppingCartDialog extends StatefulWidget {
  final bool isStudentDiscount;
  final List<Item> selectedItems;
  final ValueChanged<bool> onStudentDiscountChanged;

  const ShoppingCartDialog({
    required this.isStudentDiscount,
    required this.selectedItems,
    required this.onStudentDiscountChanged,
  });

  @override
  _ShoppingCartDialogState createState() => _ShoppingCartDialogState();
}

class _ShoppingCartDialogState extends State<ShoppingCartDialog> {
  late TextEditingController _switchController;

  @override
  void initState() {
    super.initState();
    _switchController =
        TextEditingController(text: widget.isStudentDiscount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cart'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (Item item in widget.selectedItems)
              ListTile(
                title: Text(item.iname),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: ${item.iprice}'),
                    Row(
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (item.quantity > 1) {
                              setState(() {
                                item.quantity--;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Total: ${calculateTotal()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Student Discount (10%)'),
                Switch(
                  value: _switchController.text == 'true',
                  onChanged: (value) {
                    _switchController.text = value.toString();
                    setDialogState();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            clearCart();
          },
          child: const Text('Clear'),
        ),
      ],
    );
  }

  void clearCart() {
    setState(() {
      widget.selectedItems.clear();
    });
  }

  double calculateTotal() {
    double total = 0;
    for (Item item in widget.selectedItems) {
      try {
        double price = double.parse(item.iprice.replaceAll(',', '.'));
        total += price * item.quantity;
      } catch (e) {
        return 0;
      }
    }
    total = _switchController.text == 'true' ? total * 0.9 : total;

    return double.parse(total.toStringAsFixed(2));
  }

  void setDialogState() {
    setState(() {});
  }
}

class CategoryTileContent extends StatelessWidget {
  final Cat category;
  final List<Item> selectedItems;
  final void Function(Item) toggleItemInCart;

  const CategoryTileContent({
    required this.category,
    required this.selectedItems,
    required this.toggleItemInCart,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        category.cname,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: category.item.map((item) {
        return Column(
          children: [
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(item.iname),
                subtitle: Text('Порция: ${item.iport}\nЦена: ${item.iprice}'),
                trailing: IconButton(
                  icon: Icon(
                    selectedItems.contains(item)
                        ? Icons.remove_circle_outline
                        : Icons.add_circle_outline,
                    color: selectedItems.contains(item) ? Colors.red : null,
                  ),
                  onPressed: () {
                    toggleItemInCart(item);
                  },
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
