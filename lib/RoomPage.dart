import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomPage extends StatefulWidget {
  final String roomId;
  final String userEmail;

  RoomPage({required this.roomId, required this.userEmail});


  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<String> playingMembers = [];
  List<String> invitedUsersEmails = [];
  List<String> invitedUsersTickets = [];

  TextEditingController _friendEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlayingMembers();
    fetchInvitedUsers(); // Fetch invited users on init

  }

  // Fetch the invited users from the Firestore document
  Future<void> fetchInvitedUsers() async {
    try {
      DocumentSnapshot roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .get();

      if (roomDoc.exists) {
        Map<String, dynamic>? roomData =
        roomDoc.data() as Map<String, dynamic>?;

        if (roomData != null) {
          // Get the invitedUsers list from the room document
          dynamic invitedUsers = roomData['invitedUsers'];

          if (invitedUsers != null && invitedUsers is List) {
            // Convert the list of invitedUsers to a list of strings
            List<String> users =
            invitedUsers.map((user) => user.toString()).toList();

            // Update the invitedUsersEmails list with the fetched users
            setState(() {
              invitedUsersEmails = users;
            });
          } else {
            print('No invited users found for this room.');
          }
        } else {
          print('Room data not found.');
        }
      } else {
        print('Room document not found.');
      }
    } catch (error) {
      print('Failed to fetch invited users: $error');
    }
  }

  Future<void> saveRoomIdToFirestore(String roomId, String userEmail) async {
    try {
      // Fetch the existing Room IDs from Firestore
      // Add the user's email here
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
        userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Get the existing comma-separated Room IDs as a string
          dynamic currentRoomIds = userData['room id'];
          List<String> roomIds = [];

          if (currentRoomIds != null && currentRoomIds is String) {
            roomIds = currentRoomIds.split(',');
          }
          if (!roomIds.contains(roomId)) {
            // Append the new Room ID to the list
            roomIds.add(roomId);

            // Convert the list of Room IDs to a comma-separated string
            String updatedRoomIds = roomIds.join(',');

            // Update the Firestore document with the new comma-separated Room IDs
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userEmail)
                .update({'room id': updatedRoomIds});
            print('Updated room IDs field: $updatedRoomIds');
          }
        } else {
          print('User data not found.');
        }
      } else {
        print('User document not found.');
      }
    } catch (error) {
      print('Failed to update room IDs: $error');
    }
  }

  Future<void> fetchPlayingMembers() async {
    try {
      DocumentSnapshot roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .get();

      if (roomDoc.exists) {
        Map<String, dynamic>? roomData = roomDoc.data() as Map<String,
            dynamic>?;

        if (roomData != null) {
          // Get the invitedUsers list from the room document
          dynamic invitedUsers = roomData['invitedUsers'];

          if (invitedUsers != null && invitedUsers is List) {
            // Convert the list of invitedUsers to a list of strings
            List<String> users = invitedUsers.map((user) => user.toString())
                .toList();

            // Update the playingMembers list with the fetched users
            setState(() {
              playingMembers = users;
            });
          } else {
            print('No invited users found for this room.');
          }
        } else {
          print('Room data not found.');
        }
      } else {
        print('Room document not found.');
      }
    } catch (error) {
      print('Failed to fetch invited users: $error');
    }
  }

  void inviteUser(String email) async {
    try {
      DocumentSnapshot friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();

      if (friendDoc.exists) {
        await FirebaseFirestore.instance.collection('rooms')
            .doc(widget.roomId)
            .update({
          'invitedUsers': FieldValue.arrayUnion([email]),
        });

        // After inviting a new user, fetch and update the invited users list
        await fetchInvitedUsers();

        _friendEmailController.clear();
      } else {
        print('Friend\'s email does not exist in the users collection.');
      }
    } catch (error) {
      print('Failed to invite user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.roomId}'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: playingMembers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(playingMembers[index]),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      saveRoomIdToFirestore(widget.roomId, widget.userEmail);
                      String friendEmail = _friendEmailController.text.trim();
                      if (friendEmail.isNotEmpty) {
                        inviteUser(friendEmail);
                        _friendEmailController.clear();
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Invite Friends'),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _friendEmailController,
                      decoration: InputDecoration(
                        labelText: 'Enter Friend\'s Email ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Save the Room ID to Firestore when the Start button is pressed.
                  // Implement the logic to start the game.
                  // This button should initiate the game or perform any necessary actions before starting the game.
                },
                child: Text('Start'),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 5,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                // Background color for the "Invited Users" text container
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Invited Users:',
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black), // White text color
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    // Set maximum height for the Column
                    child: SingleChildScrollView( // Use SingleChildScrollView to enable scrolling if needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: invitedUsersEmails
                            .map((email) =>
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                // Background color for the email list container
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                              child: Text(
                                email,
                                style: TextStyle(
                                    color: Colors.white), // White text color
                              ),
                            ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}