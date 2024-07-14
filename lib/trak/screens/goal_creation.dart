import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_savings_app_29_t/floor/dao/goal_dao.dart';
import 'package:future_savings_app_29_t/trak/data/goal_data.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../floor/dao/appdatabase/app_database.dart';
import '../../floor/event_bus.dart';
import '../../fsa/fsa_color.dart';
import '../../generated/assets.dart';

class GoalCreation extends StatefulWidget {
  final GoalData? goal;

  const GoalCreation({super.key, this.goal});

  @override
  State<GoalCreation> createState() => _GoalCreationState();
}

class _GoalCreationState extends State<GoalCreation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? selectedImagePath;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AppDatabase database;
  late GoalDao goalDao;
  final event = GetIt.I<EventBus>();

  DateTime? selectedDate;
  List<String> coverImages = [
    Assets.imagesPhoto1,
    Assets.imagesPhoto2,
    Assets.imagesPhoto3,
    Assets.imagesPhoto4
  ];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _loadSelectedImage();
    if (widget.goal != null) {
      _populateFields(widget.goal!);
    }
  }

  void _initializeDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    goalDao = database.goalDao;
  }

  void _populateFields(GoalData goal) {
    _nameController.text = goal.name;
    _amountController.text = goal.number.toString();
    _dateController.text = goal.date;
    if (goal.image.startsWith('/data/user/')) {
      _selectedImage = File(goal.image);
      selectedImagePath = null;
    } else {
      selectedImagePath = goal.image;
      _selectedImage = null;
    }
  }

  void _loadSelectedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('selected_image');
    if (savedImagePath != null && savedImagePath.isNotEmpty) {
      setState(() {
        coverImages.insert(0, savedImagePath);
        selectedImagePath = savedImagePath;
        _selectedImage = File(savedImagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = _nameController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _dateController.text.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Goal creation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Goal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Goal Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Target Amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _amountController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Enter number',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Target Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _dateController,
              style: const TextStyle(color: Colors.white),
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                hintText: 'Enter date',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Choose a cover',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: coverImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildMyPhotoOption();
                  }
                  return _buildCoverOption(coverImages[index - 1]);
                },
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: isButtonDisabled
                    ? null
                    : () {
                  _saveGoal();
                  Navigator.pop(context);
                },
                child: Container(
                  height: 56.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    color: isButtonDisabled ? Colors.grey : FsaColor.blue,
                  ),
                  child: Center(
                    child: Text(
                      'Add Goal',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isButtonDisabled ? Colors.white : FsaColor.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMyPhotoOption() {
    bool isSelected = _selectedImage != null && selectedImagePath == null;
    return GestureDetector(
      onTap: (){
        _openGallery();
      },
      child: Container(
        width: 100.w,
        height: 100.h,
        margin: EdgeInsets.only(right: 8.0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: FsaColor.darkGrey,
          border: isSelected ? Border.all(color: Colors.white, width: 2.w) : null,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, color: Colors.grey,),
              Text(
                'My photo',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverOption(String imagePath) {
    bool isSelected = imagePath == selectedImagePath && _selectedImage == null;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImagePath = imagePath;
          _selectedImage = null;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8.0.w),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.w)
              : null,
          borderRadius: BorderRadius.circular(8.0.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0.r),
          child: imagePath.startsWith('/')
              ? Image.file(
            File(imagePath),
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          )
              : Image.asset(
            imagePath,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }


  Future<void> _selectDate() async {
    DateTime? tempDate = selectedDate;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext cont) {
        return CupertinoActionSheet(
          actions: [
            SizedBox(
              height: 250.h,
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  tempDate = newDate;
                },
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  selectedDate = tempDate;
                  _dateController.text =
                      DateFormat('yyyy-MM-dd').format(selectedDate!);
                });
                Navigator.of(cont).pop();
              },
              child: const Text('Select', style: TextStyle(color: Colors.blue)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(cont).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        );
      },
    );
  }

  void _openGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        selectedImagePath = pickedFile.path;
        coverImages.insert(0, pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('selected_image', pickedFile.path);
    }
  }

  void _saveGoal() async {
    final String name = _nameController.text;
    final int amount = int.tryParse(_amountController.text) ?? 0;
    final String date = _dateController.text;

    if (name.isEmpty || amount <= 0 || date.isEmpty) {
      return;
    }

    final String imagePath = _selectedImage?.path ?? selectedImagePath ?? '';

    final updatedGoal = GoalData(
        id: widget.goal?.id,
        name: name,
        number: amount,
        date: date,
        accumulated: widget.goal?.accumulated,
        image: imagePath
    );

    await goalDao.insertOrUpdateGoals(updatedGoal);
    event.fire(UpdateList());
  }
}
