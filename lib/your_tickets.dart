import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YourTickets extends StatefulWidget {
  final String userEmail;

  YourTickets({required this.userEmail});

  @override
  _YourTicketsState createState() => _YourTicketsState();
}

class _YourTicketsState extends State<YourTickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Tickets'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot userSnapshot = snapshot.data as DocumentSnapshot;
            Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
            if (userData != null) {
              List<dynamic> ticketIds = userData['ticket id'] ?? [];
              List<dynamic> tickets = userData['ticket'] ?? [];
              List<dynamic> dateTimes = userData['date n time'] ?? [];

              // Handle the case where ticket information is stored as a string
              if (tickets is String) {
                ticketIds = [ticketIds];
                tickets = [tickets];
                dateTimes = [dateTimes];
              }

              return ListView.builder(
                itemCount: ticketIds.length,
                itemBuilder: (context, index) {
                  String ticketId = ticketIds[index].toString();
                  String ticket = tickets[index].toString();
                  String dateTime = dateTimes[index].toString();

                  return ListTile(
                    title: Text('Ticket ID: $ticketId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ticket: $ticket'),
                        Text('Date & Time: $dateTime'),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No tickets found.'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
