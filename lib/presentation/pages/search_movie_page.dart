import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/presentation/bloc/search_movie_bloc.dart';
import 'package:watchnow/presentation/widgets/movie_card.dart';

class SearchMoviePage extends StatelessWidget {
  static const ROUTE_NAME = '/search-movie';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchMovieBloc>().add(SearchMovieEvent(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: heading6,
            ),
            BlocBuilder<SearchMovieBloc, BlocState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return Center(
                    key: Key('center_loading'),
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MoviesHasDataState) {
                  final result = state.movies;
                  if (result.isEmpty)
                    return Center(
                      key: Key('center_empty'),
                      child: Text(
                        'Movie Not Found',
                        style: subtitle,
                      ),
                    );
                  else
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = state.movies[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                } else if (state is ErrorState) {
                  return Center(
                    key: Key('center_error'),
                    child: Text(
                      state.message,
                      style: subtitle,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
