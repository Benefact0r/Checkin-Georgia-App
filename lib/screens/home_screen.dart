import 'package:flutter/material.dart';

import '../api.dart';
import '../theme.dart';
import '../theme_controller.dart';
import 'venue_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api});

  final CheckinApi api;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Venue>> _venuesFuture;
  Vertical? _selected;

  @override
  void initState() {
    super.initState();
    _venuesFuture = widget.api.listVenues();
  }

  void _select(Vertical? v) {
    setState(() {
      _selected = v;
      _venuesFuture = widget.api.listVenues(vertical: v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkin Georgia'),
        actions: [
          IconButton(
            tooltip: 'თემა',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () =>
                themeController.toggle(Theme.of(context).brightness),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _Chip(label: 'ყველა', selected: _selected == null, onTap: () => _select(null)),
                ...Vertical.values.map(
                  (v) => _Chip(
                    label: v.label,
                    selected: _selected == v,
                    onTap: () => _select(v),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Venue>>(
              future: _venuesFuture,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'შეცდომა:\n${snap.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final items = snap.data ?? const [];
                if (items.isEmpty) {
                  return const Center(child: Text('ვერ ვიპოვე ვენიუ'));
                }
                return RefreshIndicator(
                  onRefresh: () async => _select(_selected),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final v = items[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: v.coverUrl != null
                                ? Image.network(
                                    v.coverUrl!,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const _Thumb(),
                                  )
                                : const _Thumb(),
                          ),
                          title: Text(v.name),
                          subtitle: Text(
                            '${v.vertical.label}'
                            '${v.district != null ? " · ${v.district}" : ""}'
                            '\n${v.address}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VenueDetailScreen(
                                api: widget.api,
                                slug: v.slug,
                                preview: v,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(gradient: AppColors.sunset),
      child: const Icon(Icons.place_outlined, color: Colors.white, size: 22),
    );
  }
}
