import 'package:Sovarvo/modules/realtime_firebase/users.dart';
import 'package:flutter/material.dart';

class NotifyUserScreen extends StatefulWidget {
  @override
  _NotifyUserScreenState createState() => _NotifyUserScreenState();
}

class _NotifyUserScreenState extends State<NotifyUserScreen> {
  late Future<List<Map<String, dynamic>>> notifyListFuture;

  @override
  void initState() {
    super.initState();
    notifyListFuture = getNotifyUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify Me When Available'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: notifyListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications found.'));
          } else {
            List<Map<String, dynamic>> notifyList = snapshot.data!;

            return ListView.builder(
              itemCount: notifyList.length,
              itemBuilder: (context, index) {
                var notify = notifyList[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(notify['Game']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name: ${notify['FullName']}'),
                        Text('E-Mail: ${notify['E-Mail']}'),
                        Text('Phone: ${notify['Phone']}'),
                        Text('Requested Date: ${notify['requestedDate']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}