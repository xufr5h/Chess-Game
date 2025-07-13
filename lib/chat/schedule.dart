import 'package:chess_app/helper/schedule_meeting.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();
  DateTime? _selectedDateTime;

  List<ScheduleMeeting> schedule_meetings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}