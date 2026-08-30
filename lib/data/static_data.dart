import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../models/group.dart';

class StaticData {

  static const List<Friend> friends = [
    Friend(
      name: 'Alex Johnson',
      email: 'alex@example.com',
      color: Colors.orange,
    ),
    Friend(
      name: 'Maria Garcia',
      email: 'maria@example.com',
      color: Colors.pink,
    ),
    Friend(
      name: 'John Smith',
      email: 'john@example.com',
      color: Colors.green,
    ),
    Friend(
      name: 'Emma Wilson',
      email: 'emma@example.com',
      color: Colors.blue,
    ),
    Friend(
      name: 'Chris Brown',
      email: 'chris@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown1',
      email: 'chris1@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown2',
      email: 'chris2@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown3',
      email: 'chris3@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown4',
      email: 'chris4@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown5',
      email: 'chris5@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown6',
      email: 'chris6@example.com',
      color: Colors.purple,
    ),
    Friend(
      name: 'Chris Brown7',
      email: 'chris7@example.com',
      color: Colors.purple,
    ),
  ];

  static List<Group> groups = [
    Group(
      name: 'Summer Party 2025',
      description: 'All photos from the summer party at the beach!',
      category: 'Party',
      members: [
        Friend(
          name: 'Alex Johnson',
          email: 'alex@example.com',
          color: Colors.orange,
        ),
        Friend(
          name: 'Maria Garcia',
          email: 'maria@example.com',
          color: Colors.pink,
        ),
      ],
      createdAt: DateTime(2025, 6, 15),
      icon: Icons.beach_access,
      color: Colors.orange,
    ),
    Group(
      name: 'Birthday Bash',
      description: "Alex's birthday photos shared by all guests.",
      category: 'Party',
      members: [
        Friend(
          name: 'Emma Wilson',
          email: 'emma@example.com',
          color: Colors.blue,
        ),
      ],
      createdAt: DateTime(2025, 7, 20),
      icon: Icons.cake,
      color: Colors.pink,
    ),
    Group(
      name: 'Company Retreat',
      description: 'Team building weekend in the mountains.',
      category: 'Work',
      members: [
        Friend(
          name: 'John Smith',
          email: 'john@example.com',
          color: Colors.green,
        ),
        Friend(
          name: 'Chris Brown',
          email: 'chris@example.com',
          color: Colors.purple,
        ),
      ],
      createdAt: DateTime(2025, 8, 5),
      icon: Icons.hiking,
      color: Colors.green,
    ),
    Group(
      name: 'Road Trip Europe',
      description: 'Two week road trip across Europe.',
      category: 'Trip',
      members: [
        Friend(
          name: 'Maria Garcia',
          email: 'maria@example.com',
          color: Colors.pink,
        ),
        Friend(
          name: 'Alex Johnson',
          email: 'alex@example.com',
          color: Colors.orange,
        ),
        Friend(
          name: 'Emma Wilson',
          email: 'emma@example.com',
          color: Colors.blue,
        ),
      ],
      createdAt: DateTime(2025, 9, 10),
      icon: Icons.directions_car,
      color: Colors.blue,
    ),
  ];

  static const List<String> categories = [
    'Party',
    'Trip',
    'Family',
    'Work',
    'Sports',
    'Other',
  ];

}