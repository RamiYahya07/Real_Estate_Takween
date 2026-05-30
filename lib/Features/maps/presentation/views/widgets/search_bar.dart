import 'dart:async';
import 'package:flutter/material.dart';
import 'package:takween/Features/maps/data/repos/map_repo.dart';

class LocationSearchBar extends StatefulWidget {
  final MapRepo repo;
  final Function(String id, String des) onPlaceSelected;

  const LocationSearchBar({
    super.key,
    required this.repo,
    required this.onPlaceSelected,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final _controller = TextEditingController();
  List<Map<String, String>> _suggestions = [];
  Timer? _debounce;
  bool _loading = false;

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (value.isEmpty) {
        setState(() => _suggestions = []);
        return;
      }

      setState(() => _loading = true);

      final results = await widget.repo.searchPlaces(value);

      setState(() {
        _suggestions = results;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(),
        if (_suggestions.isNotEmpty) _buildSuggestionsList(),
      ],
    );
  }

  // 🔥 FIXED SEARCH FIELD
  Widget _buildSearchField() {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search location...',
          prefixIcon: const Icon(Icons.search),

          suffixIcon: _loading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : (_controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _suggestions = []);
                        },
                      )
                    : null),

          filled: true,
          fillColor: Colors.white,

          // ✅ THIS IS THE KEY FIX
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🔥 IMPROVED SUGGESTIONS UI
  Widget _buildSuggestionsList() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final s = _suggestions[index];

          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.green),
            title: Text(
              s['description']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () {
              _controller.text = s['description']!;
              setState(() => _suggestions = []);

              widget.onPlaceSelected(s['placeId']!, s['description']!);
            },
          );
        },
      ),
    );
  }
}
