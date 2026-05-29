import 'package:flutter/material.dart';

import '../api.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({
    super.key,
    required this.api,
    required this.slug,
    this.preview,
  });

  final CheckinApi api;
  final String slug;
  final Venue? preview;

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late Future<VenueDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.api.getVenue(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.preview?.name ?? widget.slug)),
      body: FutureBuilder<VenueDetail>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('შეცდომა: ${snap.error}'));
          }
          final v = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(v.vertical.label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall),
              Text(v.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(v.address, style: Theme.of(context).textTheme.bodyMedium),
              if (v.description != null) ...[
                const SizedBox(height: 12),
                Text(v.description!),
              ],

              if (v.resources.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  v.vertical == Vertical.salon ? 'თანამშრომლები' : 'რესურსები',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...v.resources.map(
                  (r) => Card(
                    child: ListTile(
                      title: Text(r.name),
                      subtitle: Text(
                        '${r.kind} · capacity ${r.capacity}'
                        '${r.bio != null ? "\n${r.bio}" : ""}',
                      ),
                      isThreeLine: r.bio != null,
                    ),
                  ),
                ),
              ],

              if (v.services.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('სერვისები',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...v.services.map(
                  (s) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall),
                                Text(
                                  '${s.durationMinutes != null ? "${s.durationMinutes} წთ" : "—"}'
                                  '${s.category != null ? " · ${s.category}" : ""}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(s.formattedPrice,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall),
                              const SizedBox(height: 4),
                              FilledButton(
                                onPressed: null, // wired to booking flow later
                                child: const Text('დაჯავშნა'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('გადახდა',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      'ჯავშნის შემდეგ — BOG / TBC.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: ['bog', 'tbc', 'apple_pay', 'google_pay']
                          .map(
                            (p) => OutlinedButton(
                              onPressed: null,
                              child: Text(p),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
