import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_collector/models/sub_group.dart';
import 'package:pic_collector/utils/formatters.dart';

/// Shows the inside of a subgroup: info, photo upload, and gallery.
class SubGroupScreen extends StatefulWidget {
  final SubGroup subGroup;
  final ValueChanged<SubGroup> onSubGroupChanged;

  const SubGroupScreen({
    super.key,
    required this.subGroup,
    required this.onSubGroupChanged,
  });

  @override
  State<SubGroupScreen> createState() => _SubGroupScreenState();
}

class _SubGroupScreenState extends State<SubGroupScreen> {
  late SubGroup _subGroup;

  @override
  void initState() {
    super.initState();
    _subGroup = widget.subGroup;
  }

  void _syncSubGroup(SubGroup updated) {
    setState(() => _subGroup = updated);
    widget.onSubGroupChanged(updated);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Picks images from the phone's gallery and adds them to the subgroup.
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 85,
    );

    if (pickedFiles.isEmpty) return;

    final newPaths = pickedFiles.map((file) => file.path).toList();

    _syncSubGroup(
      SubGroup(
        title: _subGroup.title,
        description: _subGroup.description,
        members: _subGroup.members,
        pictures: [..._subGroup.pictures, ...newPaths],
      ),
    );

    _showSnackBar('${newPaths.length} photo(s) added');
  }

  /// Removes a specific image from the subgroup.
  void _deleteImage(String path) {
    _syncSubGroup(
      SubGroup(
        title: _subGroup.title,
        description: _subGroup.description,
        members: _subGroup.members,
        pictures: _subGroup.pictures.where((p) => p != path).toList(),
      ),
    );
  }

  /// Opens a full-screen gallery viewer for the subgroup's pictures.
  void _openImageViewer(int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) => _ImageViewerDialog(
        pictures: _subGroup.pictures,
        initialIndex: initialIndex,
        onDelete: _deleteImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _subGroup.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Subgroup info card ---
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _subGroup.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _subGroup.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Members: ${formatMemberNames(_subGroup.members.map((m) => m.name).toList())}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // --- Upload button ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('Upload photos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // --- Pictures grid ---
            if (_subGroup.pictures.isEmpty)
              Text(
                'No photos yet. Tap "Upload photos" to add from your gallery.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _subGroup.pictures.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openImageViewer(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_subGroup.pictures[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen gallery viewer with swipe navigation and image deletion.
class _ImageViewerDialog extends StatefulWidget {
  final List<String> pictures;
  final int initialIndex;
  final void Function(String path) onDelete;

  const _ImageViewerDialog({
    required this.pictures,
    required this.initialIndex,
    required this.onDelete,
  });

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  late List<String> _pictures;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pictures = List.of(widget.pictures);
    _currentIndex = widget.initialIndex;
  }

  void _confirmDelete() {
    final path = _pictures[_currentIndex];
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {
                _pictures.removeAt(_currentIndex);
                if (_currentIndex >= _pictures.length) {
                  _currentIndex = _pictures.length - 1;
                }
              });
              widget.onDelete(path);
              if (_pictures.isEmpty) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          // --- PageView for swiping left/right ---
          PageView.builder(
            controller: PageController(initialPage: _currentIndex),
            itemCount: _pictures.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.file(
                    File(_pictures[index]),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          // --- Close button ---
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // --- Delete button ---
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Delete photo',
              onPressed: _confirmDelete,
            ),
          ),
          // --- Counter (e.g. 2 / 5) — updates on swipe ---
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${_pictures.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

