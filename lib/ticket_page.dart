import 'package:flutter/material.dart';
import 'dart:math';
import 'authorization_screen.dart';

class TicketPage extends StatefulWidget {
  final String userEmail;

  TicketPage({this.userEmail = ''});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  List<List<int>> tableValues = [];
  List<List<bool>> cellTapStates = [];

  @override
  void initState() {
    super.initState();
    generateTableValues();
    initializeCellTapStates();
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
    if (totalValues > 17) {
      int valuesToRemove = totalValues - 17;
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
        title: Text('Ticket'),
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
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Text(
                'Hi ${widget.userEmail.split('@')[0]}',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 40.0),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFE4E1), // Custom light rose color
                  borderRadius: BorderRadius.circular(8.0),
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
