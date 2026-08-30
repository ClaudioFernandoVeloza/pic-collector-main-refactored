import 'package:flutter/material.dart';
import 'package:pic_collector/models/friend.dart';
import 'package:pic_collector/models/group.dart';
import 'package:pic_collector/screens/main-features/inside_message.dart';
import 'package:pic_collector/screens/main-features/profile_screen.dart';

class FriendsScreen extends StatefulWidget {
  final List<Group> allGroups;

  const FriendsScreen({super.key, this.allGroups = const []});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _searchController = TextEditingController();

  // Mock data for friends
  final List<Friend> _friends = [
    Friend(
      name: 'Alex',
      surname: 'Johnson',
      username: 'alexj',
      email: 'alex@example.com',
      color: Colors.orange,
      friendsSince: DateTime(2024, 1, 15),
    ),
    Friend(
      name: 'Maria',
      surname: 'Garcia',
      username: 'mariag',
      email: 'maria@example.com',
      color: Colors.pink,
      friendsSince: DateTime(2023, 11, 20),
    ),
    Friend(
      name: 'John',
      surname: 'Smith',
      username: 'jsmith',
      email: 'john@example.com',
      color: Colors.green,
      friendsSince: DateTime(2024, 3, 5),
    ),
    Friend(
      name: 'Emma',
      surname: 'Wilson',
      username: 'emmaw',
      email: 'emma@example.com',
      color: Colors.blue,
      friendsSince: DateTime(2023, 5, 10),
    ),
    Friend(
      name: 'Chris',
      surname: 'Brown',
      username: 'cbrown',
      email: 'chris@example.com',
      color: Colors.purple,
      friendsSince: DateTime(2024, 6, 2),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Friend> get _filteredFriends {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _friends;
    return _friends
        .where(
          (friend) =>
              friend.displayName.toLowerCase().contains(query) ||
              friend.username.toLowerCase().contains(query) ||
              friend.email.toLowerCase().contains(query),
        )
        .toList();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _editNickname(Friend friend) {
    final nicknameController = TextEditingController(text: friend.nickname);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Nickname for ${friend.name}'),
        content: TextField(
          controller: nicknameController,
          decoration: const InputDecoration(
            hintText: 'Enter nickname',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _friends.indexOf(friend);
                if (index != -1) {
                  _friends[index] = friend.copyWith(
                    nickname: nicknameController.text.trim().isEmpty
                        ? null
                        : nicknameController.text.trim(),
                  );
                }
              });
              Navigator.pop(context);
              _showSnackBar('Nickname updated');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteFriend(Friend friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Friend'),
        content: Text(
          'Are you sure you want to remove ${friend.displayName} from your friends?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _friends.remove(friend);
              });
              Navigator.pop(context);
              _showSnackBar('Friend removed');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addFriend() {
    final searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Enter username or email',
            prefixIcon: Icon(Icons.person_add),
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Mock adding logic
              final input = searchController.text.trim();
              if (input.isNotEmpty) {
                _showSnackBar('Friend request sent to $input');
                Navigator.pop(context);
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _showFriendOptions(Friend friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Nickname'),
              onTap: () {
                Navigator.pop(context);
                _editNickname(friend);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete Friend',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteFriend(friend);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Search Bar + Add Button ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search friends...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addFriend,
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // --- Friends List ---
            Expanded(
              child: _filteredFriends.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'No friends yet.'
                            : 'No friends found.',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredFriends.length,
                      itemBuilder: (context, index) {
                        final friend = _filteredFriends[index];
                        return _FriendTile(
                          friend: friend,
                          onTap: () => _viewProfile(friend),
                          onLongPress: () => _showFriendOptions(friend),
                          onChatTap: () => _startChat(friend),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewProfile(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfileScreen(friend: friend, allGroups: widget.allGroups),
      ),
    );
  }

  void _startChat(Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsideMessageScreen(friend: friend),
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onChatTap;

  const _FriendTile({
    required this.friend,
    required this.onTap,
    required this.onLongPress,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: friend.color,
          child: Text(
            friend.name[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          friend.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${friend.username}',
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            Text(
              friend.email,
              style: const TextStyle(color: Colors.black38, fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
          onPressed: onChatTap,
        ),
      ),
    );
  }
}
