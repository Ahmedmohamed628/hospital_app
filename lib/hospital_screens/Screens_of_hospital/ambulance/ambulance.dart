import 'package:flutter/material.dart';
import 'package:hospital/model/ambulancemodel.dart';

// Import your theme
import 'package:hospital/theme/theme.dart';

class AmbulanceScreenHospital extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.redColor,
        title: Text('Ambulance', style: TextStyle(color: MyTheme.whiteColor)),
        centerTitle: true,
      ),
      backgroundColor: MyTheme.whiteColor,
      body: AmbulanceBody(),
    );
  }
}

class AmbulanceBody extends StatefulWidget {
  @override
  _AmbulanceBodyState createState() => _AmbulanceBodyState();
}

class _AmbulanceBodyState extends State<AmbulanceBody> {
  List<Ambulance> _ambulanceList = [];
  bool _isAvailable = false;
  final TextEditingController _nameController = TextEditingController();
  bool _isWorking = true;

  void _addAmbulance() {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    final String name = _nameController.text;
    final bool isWorking = _isWorking;

    if (name.isNotEmpty) {
      Ambulance newAmbulance =
          Ambulance(id: id, name: name, isWorking: isWorking);
      setState(() {
        _ambulanceList.add(newAmbulance);
        if (!isWorking) {
          _isAvailable = true;
        }
      });
      _nameController.clear();
    }
  }

  void _toggleAmbulanceStatus(int index) {
    setState(() {
      _ambulanceList[index].isWorking = !_ambulanceList[index].isWorking;
      _isAvailable = _ambulanceList.any((ambulance) => !ambulance.isWorking);
    });
  }

  void _editAmbulance(int index) {
    _nameController.text = _ambulanceList[index].name;
    _isWorking = _ambulanceList[index].isWorking;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Ambulance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ambulance Name'),
              ),
              Switch(
                value: _isWorking,
                onChanged: (value) {
                  setState(() {
                    _isWorking = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _ambulanceList[index].name = _nameController.text;
                  _ambulanceList[index].isWorking = _isWorking;
                  _isAvailable =
                      _ambulanceList.any((ambulance) => !ambulance.isWorking);
                });
                Navigator.of(context).pop();
                _nameController.clear();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAmbulance(int index) {
    setState(() {
      _ambulanceList.removeAt(index);
      _isAvailable = _ambulanceList.any((ambulance) => !ambulance.isWorking);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isAvailable)
          Text('Available', style: TextStyle(color: Colors.green)),
        Expanded(
          child: ListView.builder(
            itemCount: _ambulanceList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_ambulanceList[index].name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _ambulanceList[index].isWorking
                            ? Icons.error
                        :Icons.check_circle,
                        color: _ambulanceList[index].isWorking
                            ? Colors.red
                        :Colors.green,
                            // : Colors.red,
                      ),
                      onPressed: () => _toggleAmbulanceStatus(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editAmbulance(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteAmbulance(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Ambulance Name'),
                ),
              ),
              Switch(
                value: _isWorking,
                onChanged: (value) {
                  setState(() {
                    _isWorking = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _addAmbulance,
                child: Text('Add Ambulance'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
