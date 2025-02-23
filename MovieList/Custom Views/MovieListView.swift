//
//  MovieListView.swift
//  MovieList
//
//  Created by Suresh Kumar on 18/02/25.
//

import SwiftUI

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieListViewModel()

    var body: some View {
        VStack {
            HeaderView(title: "Movie List")

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.movies) { movie in
                        MovieRow(movie: movie, viewModel: viewModel)
                            .onAppear {
                                if viewModel.movies.last?.id == movie.id {
                                    viewModel.fetchNextBatch()
                                }
                            }
                    }
                }
                .padding(.top)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

// ✅ Header View Component
struct HeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .padding(.top, 10)
    }
}

// ✅ Movie Row Component
struct MovieRow: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieListViewModel

    var body: some View {
        VStack {
            HStack {
                Text(movie.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()

                WatchButton(isWatched: movie.watched) {
                    viewModel.toggleWatchedList(movie.id)
                }

                WatchlistButton(isInWatchlist: movie.watch) {
                    viewModel.toggleWatchList(movie.id)
                }
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)

        Divider()
            .padding(.horizontal, 16)
    }
}

// ✅ Watch Button Component
struct WatchButton: View {
    let isWatched: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isWatched ? "Unwatch" : "Watched")
                .font(.footnote)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isWatched ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}

// ✅ Watchlist Button Component
struct WatchlistButton: View {
    let isInWatchlist: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isInWatchlist ? "Remove" : "Watchlist")
                .font(.footnote)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isInWatchlist ? Color.orange : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }
}



#Preview {
    MovieListView()
}

