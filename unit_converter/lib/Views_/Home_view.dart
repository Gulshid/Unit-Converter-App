import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.lightGreenAccent,
      body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent,Colors.lightGreenAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
        child: CustomScrollView(
          slivers: [
          SliverAppBar(
          backgroundColor: Colors.transparent, 
          title: Text(
            'Unit Converter',
            style: GoogleFonts.pacifico(fontSize: 20.sp, color: Colors.black),
          ),
          floating: true,
          pinned: true,
          expandedHeight: 200.h,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            
        return ClipRRect(
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r), 
            bottomRight: Radius.circular(25.r), 
          ),
          
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue,Colors.green],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: FlexibleSpaceBar(
              background: Column(
                children: [
                  SizedBox(height: 100.h),
                  Text(
                    'Unit Converter App',
                    style: GoogleFonts.poppins(
                      color: Colors.deepPurpleAccent,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
            },
          ),
        ),
        
            SliverToBoxAdapter(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Select Category', style: GoogleFonts.aBeeZee(color: Colors.blueGrey, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2), 
                              borderRadius: BorderRadius.circular(10), 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: DropdownButton<Unitcategory>(
                              value: viewModel.selectedCategory,
                              isExpanded: true,
                              underline: SizedBox(),
                              dropdownColor: Colors.cyan,
                              focusColor: Colors.deepOrange,
                              focusNode: FocusNode(),
                              borderRadius: BorderRadius.circular(25.r),
                              items: viewModel.categories
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Text(cat.name, style: GoogleFonts.aBeeZee(color: Colors.black),),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (cat) {
                                viewModel.ChangeCategory(cat!);
                              },
                                                        ),
                            ),
                        ),
                      ),
                    ],
                  ),
                      
                  SizedBox(height: 30.h,),
                      
                  Text('Enter the value for Unit Conversion', style: GoogleFonts.aBeeZee(color: Colors.teal, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h,),
                  TextField(
                    style: TextStyle(color: Colors.black),
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter value",
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                      
                  SizedBox(height: 20.h,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2), 
                            borderRadius: BorderRadius.circular(10), 
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: DropdownButton<String>(
                              value: viewModel.fromUnit,
                              isExpanded: true,
                              underline: SizedBox(),
                              dropdownColor: Colors.green,
                              focusColor: Colors.deepOrange,
                              focusNode: FocusNode(),
                              borderRadius: BorderRadius.circular(25.r),
                              items: viewModel.selectedCategory.units.keys
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Text(unit, style: GoogleFonts.aBeeZee(color: Colors.black)),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                viewModel.fromUnit = val!;
                                // ignore: invalid_use_of_protected_member
                                viewModel.notifyListeners();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2), 
                            borderRadius: BorderRadius.circular(10), 
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: DropdownButton<String>(
                              value: viewModel.ToUnit,
                              isExpanded: true,
                              underline: SizedBox(),
                              dropdownColor: Colors.teal,
                              focusColor: Colors.deepOrange,
                              focusNode: FocusNode(),
                              borderRadius: BorderRadius.circular(25.r),
                              items: viewModel.selectedCategory.units.keys
                                  .map((unit) => DropdownMenuItem(
                                        value: unit,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Text(unit, style: GoogleFonts.aBeeZee(color: Colors.black)),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                viewModel.ToUnit = val!;
                                viewModel.notifyListeners();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                      
                  SizedBox(height: 20.h,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: () {
                      double value = double.tryParse(_valueController.text) ?? 0;
                      viewModel.Convert(value);
                    },
                    child: Text("Convert", style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 20),
                  Text("Result: ${viewModel.result.toStringAsFixed(2)}", style: TextStyle(color: Colors.black),),
                  SizedBox(height: 30.h,),
                  Text('Unit Converter App', style: GoogleFonts.aBeeZee(color: const Color.fromARGB(255, 40, 204, 152), fontSize: 30.sp),),
        
                  SizedBox(height: 30.h,),
                  Text('Unit Converter App', style: GoogleFonts.aBeeZee(color: const Color.fromARGB(255, 135, 26, 52), fontSize: 30.sp),),
        
                  SizedBox(height: 30.h,),
                  Text('Unit Converter App', style: GoogleFonts.aBeeZee(color: const Color.fromARGB(255, 174, 112, 31), fontSize: 30.sp),),
        
                SizedBox(height: 30.h,),
                  Text('Unit Converter App', style: GoogleFonts.aBeeZee(color: const Color.fromARGB(255, 93, 4, 148), fontSize: 30.sp),),
        
                SizedBox(height: 30.h,),
                  Text('Unit Converter App', style: GoogleFonts.aBeeZee(color: const Color.fromARGB(255, 164, 68, 19), fontSize: 30.sp),),
        
                  
        
                ],
              ),
                      ),
            ),
          ],
           
        ),
      ),
    );
  }
}