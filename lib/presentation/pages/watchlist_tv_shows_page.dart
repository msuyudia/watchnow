import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_tv_shows_bloc.dart';
import 'package:watchnow/presentation/widgets/tv_show_card.dart';

class WatchlistTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv-show';

  @override
  _WatchlistTVShowsPageState createState() => _WatchlistTVShowsPageState();
}

class _WatchlistTVShowsPageState extends State<WatchlistTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<GetWatchlistTVShowsBloc>()
        .add(GetWatchlistTVShowsEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetWatchlistTVShowsBloc, BlocState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TVShowsHasDataState) {
              if (state.tvShows.isEmpty)
                return Center(
                  key: Key('center_empty'),
                  child: Text(
                    'You don\'t have watchlist tv show',
                    style: subtitle,
                  ),
                );
              else
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final tvShow = state.tvShows[index];
                    return TVShowCard(tvShow);
                  },
                  itemCount: state.tvShows.length,
                );
            } else if (state is ErrorState) {
              return Center(
                key: Key('center_error'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
