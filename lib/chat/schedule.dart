import 'package:chess_app/helper/meeting_handler.dart';
import 'package:chess_app/helper/schedule_meeting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chess_app/chat/chat_service.dart';

class Schedule extends StatefulWidget {
  final String currentId;
  final String receiverId;
  const Schedule({super.key, required this.currentId ,required this.receiverId});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  DateTime? _selectedDateTime;
  bool isLoading = false;

  final ChatService _chatService = ChatService();
  final List<ScheduleMeeting> scheduledMeetings = [];


  // date and time picker for scheduling meetings
  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context, 
      initialDate: DateTime.now().add(const Duration(minutes: 5)),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2050),
      builder: (context, child){
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
            primary: Colors.green, // header and selected date color
            onPrimary: Colors.white, // text color on selected date
            surface: Color(0xFF2C2C2C), // background
            onSurface: Colors.white, // text color
          ) 
          ),
          child: child!);
      }
      );
      if (date == null) {
        return;
      }
      final TimeOfDay? time = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 5))),
        builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Color(0xFF1F1F1F),
            hourMinuteTextColor: Colors.white,
            dayPeriodTextColor: Colors.white70,
            dialHandColor: Colors.green,
            dialTextColor: Colors.white,
            entryModeIconColor: Colors.green,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Colors.green,
            onPrimary: Colors.white,
            surface: Color(0xFF2C2C2C),
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      );
        }
      );
      if (time == null) {
        return;
        
      }
      setState(() {
        _selectedDateTime = DateTime(
          date.year, 
          date.month, 
          date.day, 
          time.hour, 
          time.minute
        );
      });
  }

      Future<void> _scheduleMeeting() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final roomName = _roomNameController.text.trim();
      final meeting = ScheduleMeeting(
        roomName: roomName,
        meetingUrl: 'https://meet.jit.si/$roomName',
        scheduledTime: _selectedDateTime!,
      );

      final link = await generateScheduledMeetingLink(meeting);
      
      await storeMeeting(
        widget.currentId,
        widget.receiverId,
        _selectedDateTime!,
      );

      await _chatService.sendMessageToChat(
        widget.currentId,
        widget.receiverId,
        'Scheduled Meeting: $link'
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meeting scheduled: $link')),
      );

      // Clear the form after successful submission
      _roomNameController.clear();
      setState(() => _selectedDateTime = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule meeting: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Stream<QuerySnapshot> getMeetingsStream(String currentId, String receiverId) {
  return FirebaseFirestore.instance
      .collection('Meetings')
      .where('senderId', isEqualTo: currentId)
      .where('receiverId', isEqualTo: receiverId)
      .orderBy('scheduledTime', descending: false)
      .snapshots();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    controller: _roomNameController,
                    decoration: const InputDecoration(
                      labelText: 'Meeting Room Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(77, 255, 252, 252)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      )
                    ),
                    validator: (value) => value == null 
                    || value.isEmpty? 'Please enter a room name' : null,
                  ),
                  const SizedBox(height: 16.0),
                 Column(
                   children: [
                     TextButton(
                      onPressed: _pickDateTime, 
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 232, 236, 238),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Select Date and Time',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16)
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Icon(
                            Icons.calendar_today,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            size: 20,
                          ),
                        ),
                        ],
                      ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                      _selectedDateTime == null
                      ? 'No date and time selected'
                      : 'Scheduled for: ${dateFormat.format(_selectedDateTime!)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 40),
                 ElevatedButton(onPressed: _scheduleMeeting,
                 style: ElevatedButton.styleFrom(
                  elevation: 5,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: isLoading ?
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ) 
                  : const Text(
                    'Schedule Meeting',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ),
                ],
              )
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                'Your Meetings',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getMeetingsStream(currentUser!.uid, widget.receiverId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No meetings yet.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final meetings = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: meetings.length,
                      itemBuilder: (context, index) {
                        final data = meetings[index].data() as Map<String, dynamic>;

                        final roomUrl = data['meetingUrl'] ?? '';
                        final roomName = Uri.parse(roomUrl).pathSegments.last;
                        final DateTime? scheduledTime = (data['scheduledTime'] as Timestamp?)?.toDate();

                        return Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        roomName,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 52, 51, 51),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          joinScheduledMeeting(roomName);
                                        },
                                        icon: const Icon(Icons.link, color: Colors.white),
                                        label: const Text('Join', style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (scheduledTime != null)
                                  Text(
                                    'Scheduled for: ${dateFormat.format(scheduledTime)}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(179, 46, 44, 44),
                                      fontSize: 14,
                                    ),
                                  )
                                else
                                  const Text(
                                    'Instant Meeting',
                                    style: TextStyle(
                                      color: Color.fromARGB(179, 46, 44, 44),
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        ),
    );
    
  }
}

