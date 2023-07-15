import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  final String roomId;
  final List<String> invitedUsers;

  RoomPage({required this.roomId, required this.invitedUsers});

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<String> playingMembers = [];

  @override
  void initState() {
    super.initState();
    // Fetch playing members based on the room ID
    fetchPlayingMembers();
  }

  void fetchPlayingMembers() {
    // Implement the logic to fetch the playing members
    // based on the room ID and update the 'playingMembers' list.
    // You can use your preferred method for fetching data, such as Firebase Firestore.
    // For example:
    // playingMembers = await fetchPlayingMembersFromFirestore(widget.roomId);
  }

  void inviteUser(String userId) {
    // Implement the logic to invite a user based on their ID.
    // You can use your preferred method for sending invitations, such as sending an email or using a chat API.
    // For example:
    // sendInvitation(userId);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.roomId}'),
      ),
      body: Column(
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
                onPressed: () {
                  // Implement the logic to invite friends.
                  // Show a dialog or navigate to a new screen to select friends to invite.
                  // On selection, call the 'inviteUser' method with the selected user's ID.
                },
                icon: Icon(Icons.add),
                label: Text('Invite Friends'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Implement the logic to start the game.
              // This button should initiate the game or perform any necessary actions before starting the game.
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }
}
