import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'RoomPage.dart';
import 'authorization_screen.dart';
import 'your_tickets.dart';

class TicketPage extends StatefulWidget {
  final String userEmail;

  const TicketPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  String? ticketId;
  String userName ='';
  List<List<int>> tableValues = [];
  List<List<bool>> cellTapStates = [];
  List<String> invitedUsersEmails = [];
  List<String> joiners = [];
  bool isJoined = false;
  String? roomId;
  TextEditingController _roomIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateTableValues();
    initializeCellTapStates();
    ticketId = generateUniqueTicketId();
    fetchUserDataAndTicket().then((String? name){
      setState(() {
        userName=name ?? '';
      });
    });
  }

  Future<String?> fetchUserDataAndTicket() async {
    try {
      String userEmail = widget.userEmail;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
        userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          var name = userData['name'];
          userName = name;
          dynamic currentTicketIds = userData['ticket id'];
          dynamic currentTicketData = userData['tickets'];

          List<Map<String, dynamic>> tickets = [];
          if (currentTicketData != null) {
            tickets.addAll(List<Map<String, dynamic>>.from(currentTicketData));
          }

          // Convert tableValues to a list of maps
          List<Map<String, dynamic>> tableValuesData = [];
          for (var row in tableValues) {
            List<dynamic> rowData = row.map((cellValue) => cellValue).toList();
            tableValuesData.add({'rowValues': rowData});
          }

          // Create a new ticket entry with the ticket ID and table values
          Map<String, dynamic> newTicket = {
            'ticketId': ticketId,
            'tableValues': tableValuesData,
          };

          tickets.add(newTicket);

          if (tickets.length > 15) {
            tickets.removeAt(0);
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .update({'tickets': tickets});

          List<String> ticketIds = [];
          if (currentTicketIds != null) {
            ticketIds = currentTicketIds.split(',');

            if (ticketIds.length >= 15) {
              ticketIds.removeAt(0);
            }
          }

          ticketIds.add(ticketId!);

          String updatedTicketIds = ticketIds.join(',');

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .update({'ticket id': updatedTicketIds});

          print('Updated ticket IDs field: $updatedTicketIds');
          return userName;
        } else {
          print('User data not found.');
        }
      } else {
        print('User document not found.');
      }
    } catch (error) {
      print('Failed to fetch user data and store ticket IDs: $error');
    }
    return null;
  }

  Future<List<String>?> fetchInvitedUsersEmails(String roomId) async {
    try {
      DocumentSnapshot roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .get();

      if (roomDoc.exists) {
        Map<String, dynamic>? roomData = roomDoc.data() as Map<String, dynamic>?;

        if (roomData != null) {
          // Get the invitedUsers list from the room document
          dynamic invitedUsers = roomData['invitedUsers'];

          if (invitedUsers != null && invitedUsers is List) {
            // Convert the list of invitedUsers to a list of strings
            List<String> users = invitedUsers.map((user) => user.toString()).toList();

            // Return the list of invited users' emails
            return users;
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
    return null;
  }

  void generateTableValues() {
    List<int> usedValues = [];
    List<int> columnCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (int i = 0; i < 3; i++) {
      List<int> rowValues = [];
      for (int j = 0; j < 9; j++) {
        int minValue = (j * 10) + 1;
        int maxValue = (j * 10) + 10;

        if (i == 0) {
          int randomValue = generateUniqueValue(minValue, maxValue, usedValues);
          rowValues.add(randomValue);
          columnCounts[j]++;
        } else {
          int cellValue = generateUniqueValue(minValue, maxValue, usedValues);
          if (cellValue != -1) {
            rowValues.add(cellValue);
            columnCounts[j]++;
          }
        }
      }
      tableValues.add(rowValues);
    }

    int totalValues = columnCounts.reduce((a, b) => a + b);
    if (totalValues > 15) {
      int valuesToRemove = totalValues - 15;
      for (int k = 0; k < valuesToRemove; k++) {
        int rowIndex = Random().nextInt(3);
        int columnIndex;
        do {
          columnIndex = Random().nextInt(9);
        } while (tableValues[rowIndex][columnIndex] == -1);

        tableValues[rowIndex][columnIndex] = -1;
        columnCounts[columnIndex]--;
      }
    }

    for (int i = 0; i < 9; i++) {
      if (columnCounts[i] == 0) {
        int rowIndex = Random().nextInt(3);
        tableValues[rowIndex][i] =
            generateUniqueValue((i * 10) + 1, (i * 10) + 10, usedValues);
      }
    }
  }

  String generateUniqueTicketId() {
    String randomString = '';
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    // Generate a random string of 8 characters
    for (int i = 0; i < 8; i++) {
      randomString += chars[Random().nextInt(chars.length)];
    }
    return randomString;
  }

  int generateUniqueValue(int minValue, int maxValue, List<int> usedValues) {
    int value;
    do {
      value = Random().nextInt(maxValue - minValue + 1) + minValue;
    } while (usedValues.contains(value));

    usedValues.add(value);
    return value;
  }

  void initializeCellTapStates() {
    for (int i = 0; i < 3; i++) {
      List<bool> rowStates = [];
      for (int j = 0; j < 9; j++) {
        rowStates.add(false);
      }
      cellTapStates.add(rowStates);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${userName.isNotEmpty ? userName : 'User'}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                height: 40,
                width: 150,
                child: ElevatedButton(
                  onPressed: isJoined ? null : () async {
                    String roomId = '${userName}-${ticketId?.substring(0, ticketId!.length - 4)}';
                    await FirebaseFirestore.instance.collection('rooms').doc(
                        roomId).set({
                      'roomId': roomId,
                      'adminUserId': widget.userEmail,
                      'adminticketId': ticketId,
                      // Add any other relevant data for the room, such as room settings
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            RoomPage(
                                roomId: roomId, userEmail: widget.userEmail),
                        ));
                    // Handle the Tickets button action
                  },
                  child: Text('Create Room'),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 150, // Adjust the width as needed
                      child: TextField(
                        controller: _roomIdController,
                        // Add your text field properties here
                        decoration: InputDecoration(
                          labelText: 'Enter Room ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String roomId = _roomIdController.text.trim();
                        if (roomId.isNotEmpty) {
                          List<String>? emails = await fetchInvitedUsersEmails(roomId);
                          if (emails != null) {
                              setState(() {
                                isJoined = true;
                                joiners = emails;
                              });
                          } else {
                            print('Failed to fetch invited users\' emails.');
                          }
                        } else {
                          print('no room id');
                        }
                        // Implement the Join button logic here
                      },
                      child: Text('Join'),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0),
                  isJoined
                      ? Container(
                    width: 150,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'Joiners:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  )
                      : SizedBox.shrink(), // Show nothing if not joined
                  if (isJoined)
                    Expanded(
                      child: ListView.builder(
                        itemCount: joiners.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(joiners[index]),
                          );
                        },
                      ),
                    ),
                ],
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Ticket ID: $ticketId',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE4E1),
                      ),
                      child: Table(
                        border: TableBorder.all(color: Colors.black),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: _buildTableRows(),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YourTickets(userEmail: widget.userEmail)),
                    );// Handle the Tickets button action
                  },
                  child: Text('Old Tickets'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    List<TableRow> rows = [];
    for (int i = 0; i < 3; i++) {
      List<Widget> cells = [];
      for (int j = 0; j < 9; j++) {
        int cellValue = tableValues[i][j];
        bool isDoubleTap = cellTapStates[i][j];
        cells.add(_buildTableCell(cellValue, isDoubleTap, i, j));
      }
      rows.add(TableRow(children: cells));
    }
    return rows;
  }

  // Fetch the invited users' emails from the room ID and update the state
  Future<void> fetchInvitedUsersAndSetState(String roomId) async {
    List<String>? emails = await fetchInvitedUsersEmails(roomId);
    if (emails != null) {
      setState(() {
        invitedUsersEmails = emails; // Update the class-level variable with the fetched emails
      });
    } else {
      print('Failed to fetch invited users\' emails.');
    }
  }


  Widget _buildTableCell(
      int cellValue, bool isDoubleTap, int rowIndex, int columnIndex) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          cellTapStates[rowIndex][columnIndex] =
          !cellTapStates[rowIndex][columnIndex];
        });
      },
      child: Container(
        color: cellTapStates[rowIndex][columnIndex]
            ? Colors.green
            : Colors.transparent,
        child: Center(
          child: cellValue != -1
              ? Text(
            '$cellValue',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}


void _logout(BuildContext context) {
  // Add the logout logic here
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AuthorizationScreen()),
  );
}


