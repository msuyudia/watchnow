import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/presentation/bloc/get_popular_tv_shows_bloc.dart';
import 'package:watchnow/presentation/widgets/tv_show_card.dart';

class PopularTVShowsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-show';

  @override
  _PopularTVShowsPageState createState() => _PopularTVShowsPageState();
}

class _PopularTVShowsPageState extends State<PopularTVShowsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<GetPopularTVShowsBloc>().add(GetPopularTVShowsEvent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetPopularTVShowsBloc, BlocState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TVShowsHasDataState) {
              if (state.tvShows.isNotEmpty) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final tvShow = state.tvShows[index];
                    return TVShowCard(tvShow);
                  },
                  itemCount: state.tvShows.length,
                );
              } else {
                return Center(
                  key: Key('center_empty'),
                  child: Text('Popular TV Show Is Empty'),
                );
              }
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
