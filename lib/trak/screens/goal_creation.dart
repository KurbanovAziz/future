import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_savings_app_29_t/floor/dao/goal_dao.dart';
import 'package:future_savings_app_29_t/trak/data/goal_data.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
    if (goal.image != null && goal.image!.startsWith('/data/user/')) {
      _selectedImage = File(goal.image!);
      selectedImagePath = null;
    } else {
      selectedImagePath = goal.image;
      _selectedImage = null;
    }
  }

  void photosPermissionStatus() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      PermissionStatus status;

      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.request();
      } else {
        status = await Permission.photos.request();
      }

      if (status.isGranted) {
        print('Permission granted.');
        _openGallery();
      } else if (status.isDenied) {
        print('Permission denied.');
        _showSettingsDialog();
      } else if (status.isPermanentlyDenied) {
        _showSettingsDialog();
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      if (status.isGranted) {
        _openGallery();
      } else if (status.isDenied) {
        print('Permission denied.');
        _showSettingsDialog();
      } else if (status.isPermanentlyDenied) {
        _showSettingsDialog();
      }
    }
  }

  void _showSettingsDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Access to photos has been denied'),
          content: const Text(
              'Go to settings to allow access to photos to set cover'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'Settings',
                style: TextStyle(color: FsaColor.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Goal creation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Goal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Goal Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Target Amount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter number',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2F2F2F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Target Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
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
                  borderRadius: BorderRadius.circular(90),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose a cover',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  _saveGoal();
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: FsaColor.blue,
                  ),
                  child: const Center(
                    child: Text(
                      'Add Goal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: FsaColor.white,
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
    bool isSelected = _selectedImage != null;
    return GestureDetector(
      onTap: photosPermissionStatus,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: FsaColor.darkGrey,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Center(
          child: _selectedImage == null
              ? const Text(
            'My photo',
            style: TextStyle(color: Colors.grey),
          )
              : Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
      ),
    );
  }


  Widget _buildCoverOption(String imagePath) {
    bool isSelected = imagePath == selectedImagePath;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImagePath = imagePath;
          _selectedImage = null;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            imagePath,
            width: 100,
            height: 100,
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
              height: 250,
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
        selectedImagePath = null;
      });
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
        image: imagePath);

    await goalDao.insertOrUpdateGoals(updatedGoal);
    event.fire(UpdateList());
  }
}
