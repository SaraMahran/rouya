import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/rouya_themes.dart';
import '../models/quote_model.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeProvider>().theme;
    final state = context.watch<AppStateProvider>();

    final filtered = _filter == 'Favorites'
        ? state.quotes.where((q) => q.favorite).toList()
        : state.quotes;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Library',
                  style: TextStyle(color: t.textDim, fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quotes',
                      style: TextStyle(
                        color: t.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${state.quotes.length} total · '
                          '${state.quotes.where((q) => q.favorite).length} ★',
                      style: TextStyle(color: t.textDim, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter tabs
                Row(
                  children: ['All', 'Favorites'].map((tab) {
                    final active = _filter == tab;
                    return GestureDetector(
                      onTap: () => setState(() => _filter = tab),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active ? t.accent : t.surface,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: active ? t.accent : t.border,
                          ),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: active ? t.onAccent : t.textDim,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quotes list
          Expanded(
            child: filtered.isEmpty
                ? Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(color: t.textDim),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final q = filtered[i];
                return _QuoteCard(
                  t: t,
                  quote: q,
                  onFav: () => state.toggleFav(q.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final RouyaTheme t;
  final QuoteModel quote;
  final VoidCallback onFav;

  const _QuoteCard({required this.t, required this.quote, required this.onFav});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radius),
        border: Border.all(
          color: quote.favorite ? t.accent.withValues(alpha: 0.4) : t.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tag
          if (quote.category.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: t.accent2Tint,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                quote.category.toUpperCase(),
                style: TextStyle(
                  color: t.accent2,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),

          // Quote text
          Text(
            '"${quote.text}"',
            style: TextStyle(
              color: t.text,
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.6,
              fontFamily: 'Cormorant Garamond',
            ),
          ),
          const SizedBox(height: 14),

          // Author + favorite
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '— ${quote.author}',
                      style: TextStyle(
                        color: t.accent2,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (quote.book != null)
                      Text(
                        quote.book!,
                        style: TextStyle(color: t.textDim, fontSize: 11),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onFav,
                child: Icon(
                  quote.favorite ? Icons.favorite : Icons.favorite_border,
                  color: quote.favorite ? t.accent : t.textFaint,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}