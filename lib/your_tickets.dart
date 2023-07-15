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
            Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

            if (userData != null) {
              List<dynamic> tickets = userData['tickets'] ?? [];

              tickets = List.from(tickets.reversed); // Reverse the order of tickets

              return ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> ticket = tickets[index];
                  String ticketId = ticket['ticketId'].toString();
                  List<dynamic> tableValues = ticket['tableValues'];

                  return ListTile(
                    title: Text('Ticket ID: $ticketId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Table Values:'),
                        Container(
                          color: Colors.grey[200], // Set the background color of the table
                          child: Align(
                            alignment: Alignment.center,
                            child: Expanded(
                              child: Table(
                                border: TableBorder.all(), // Set the table border
                                defaultColumnWidth: FixedColumnWidth(30.0), // Adjust the cell width as desired
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: _buildTableRows(tableValues),
                              ),
                            ),
                          ),
                        ),
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

  List<TableRow> _buildTableRows(List<dynamic> tableValues) {
    List<TableRow> rows = [];
    for (var row in tableValues) {
      List<Widget> cells = [];
      List<dynamic> rowValues = row['rowValues'];
      for (var cellValue in rowValues) {
        cells.add(_buildTableCell(cellValue));
      }
      rows.add(TableRow(children: cells));
    }
    return rows;
  }

  Widget _buildTableCell(dynamic cellValue) {
    return Container(
      padding: EdgeInsets.all(4.0), // Adjust the padding as desired
      child: cellValue != -1
          ? Text(
        cellValue.toString(),
        style: TextStyle(fontSize: 14.0), // Adjust the font size as desired
      )
          : SizedBox(width: 20.0, height: 20.0), // Adjust the size of empty cell as desired
    );
  }
}
