import 'package:flutter/material.dart';
import 'package:pic_collector/models/chat_summary.dart';
import 'package:pic_collector/models/friend.dart';
import 'package:pic_collector/models/group.dart';
import 'package:pic_collector/screens/main-features/inside_message.dart';

class ChatScreen extends StatefulWidget {
  final List<Friend> friends;
  final List<Group> allGroups;

  const ChatScreen({
    super.key,
    this.friends = const [],
    this.allGroups = const [],
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _searchController = TextEditingController();
  late List<ChatSummary> _chats;

  @override
  void initState() {
    super.initState();
    final friends = widget.friends.isEmpty
        ? const [
            Friend(
              name: 'Alex',
              surname: 'Johnson',
              username: 'alexj',
              email: 'alex@example.com',
              color: Colors.orange,
            ),
            Friend(
              name: 'Maria',
              surname: 'Garcia',
              username: 'mariag',
              email: 'maria@example.com',
              color: Colors.pink,
            ),
            Friend(
              name: 'John',
              surname: 'Smith',
              username: 'jsmith',
              email: 'john@example.com',
              color: Colors.green,
            ),
            Friend(
              name: 'Emma',
              surname: 'Wilson',
              username: 'emmaw',
              email: 'emma@example.com',
              color: Colors.blue,
            ),
          ]
        : widget.friends;

    _chats = friends.take(4).map((friend) {
      return ChatSummary(
        friend: friend,
        lastMessage: 'Hey! Did you see the photos from the party?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
        unreadCount: friend.name.toLowerCase().startsWith('a') ? 2 : 0,
        isPinned: friend.name.toLowerCase().startsWith('m'),
      );
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatSummary> get _filteredChats {
    final query = _searchController.text.trim().toLowerCase();
    var filtered = _chats;
    if (query.isNotEmpty) {
      filtered = _chats
          .where(
            (chat) =>
                chat.friend.displayName.toLowerCase().contains(query) ||
                chat.friend.username.toLowerCase().contains(query),
          )
          .toList();
    }
    // Sort: Pinned first, then by time
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
    return filtered;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _togglePin(ChatSummary chat) {
    setState(() {
      final index = _chats.indexOf(chat);
      if (index != -1) {
        _chats[index] = chat.copyWith(isPinned: !chat.isPinned);
      }
    });
    _showSnackBar(chat.isPinned ? 'Chat unpinned' : 'Chat pinned');
  }

  void _deleteChat(ChatSummary chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text(
          'Are you sure you want to delete the conversation with ${chat.friend.displayName}?',
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
              setState(() => _chats.remove(chat));
              Navigator.pop(context);
              _showSnackBar('Chat deleted');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChatOptions(ChatSummary chat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              title: Text(chat.isPinned ? 'Unpin Chat' : 'Pin Chat'),
              onTap: () {
                Navigator.pop(context);
                _togglePin(chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Delete Chat',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteChat(chat);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Group> _getMutualGroups(Friend friend) {
    return widget.allGroups
        .where((group) => group.members.contains(friend))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search chats...',
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
          // --- Chat List ---
          Expanded(
            child: _filteredChats.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'No conversations yet.'
                          : 'No chats found.',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredChats.length,
                    itemBuilder: (context, index) {
                      final chat = _filteredChats[index];
                      final mutuals = _getMutualGroups(chat.friend);

                      return _ChatSummaryTile(
                        chat: chat,
                        mutualGroups: mutuals,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InsideMessageScreen(friend: chat.friend),
                            ),
                          );
                        },
                        onLongPress: () => _showChatOptions(chat),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChatSummaryTile extends StatelessWidget {
  final ChatSummary chat;
  final List<Group> mutualGroups;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ChatSummaryTile({
    required this.chat,
    required this.mutualGroups,
    required this.onTap,
    required this.onLongPress,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: chat.friend.color,
              child: Text(
                chat.friend.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (chat.isPinned)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.push_pin,
                    size: 14,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chat.friend.displayName,
                style: TextStyle(
                  fontWeight: chat.unreadCount > 0
                      ? FontWeight.bold
                      : FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              _formatTime(chat.lastMessageTime),
              style: TextStyle(
                fontSize: 12,
                color: chat.unreadCount > 0 ? Colors.blue : Colors.black38,
                fontWeight: chat.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: chat.unreadCount > 0
                          ? Colors.black87
                          : Colors.black54,
                      fontWeight: chat.unreadCount > 0
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (chat.unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (mutualGroups.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'Mutual: ${mutualGroups.map((g) => g.name).join(", ")}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
