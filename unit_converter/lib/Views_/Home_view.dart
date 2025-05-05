import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit_converter/Model_/unitCategory.dart';
import 'package:unit_converter/ViewModel/UnitProvider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _valueController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<Unitprovider>(context);
    return  Scaffold(
      appBar: AppBar(title: Text("Unit Converter", style: TextStyle(color: Colors.black),),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Unitcategory>(
              value: viewModel.selectedCategory,
              items: viewModel.categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      ))
                  .toList(),
              onChanged: (cat) {
                viewModel.ChangeCategory(cat!);
              },
            ),
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Value"),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: viewModel.fromUnit,
                    items: viewModel.selectedCategory.units.keys
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (val) {
                      viewModel.fromUnit = val!;
                      // ignore: invalid_use_of_protected_member
                      viewModel.notifyListeners();
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<String>(
                    value: viewModel.ToUnit,
                    items: viewModel.selectedCategory.units.keys
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (val) {
                      viewModel.ToUnit = val!;
                      viewModel.notifyListeners();
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                double value = double.tryParse(_valueController.text) ?? 0;
                viewModel.Convert(value);
              },
              child: Text("Convert", style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 20),
            Text("Result: ${viewModel.result.toStringAsFixed(2)}", style: TextStyle(color: Colors.black),),
          ],
        ),
      ),
    );
  }
}