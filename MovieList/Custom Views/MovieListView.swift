//
//  MovieListView.swift
//  MovieList
//
//  Created by Suresh Kumar on 18/02/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieListViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                HeaderView(title: "🎬 Movie List")

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            MovieRow(movie: movie, viewModel: viewModel)
                                .onAppear {
                                    if viewModel.movies.last?.id == movie.id {
                                        viewModel.fetchNextBatch()
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct HeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 16)
            .shadow(radius: 5)
    }
}

struct MovieRow: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieListViewModel

    var body: some View {
        VStack {
            HStack {
                Text(movie.name)
                    .font(.title3)
                    .foregroundColor(.white)
                    .bold()

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
        .background(BlurView(style: .systemThinMaterialDark))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.3))
    }
}

struct WatchButton: View {
    let isWatched: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isWatched ? "✔ Unwatch" : "👀 Watched")
                .font(.caption)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isWatched ? Color.green.opacity(0.8) : Color.gray.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .shadow(radius: 3)
    }
}

struct WatchlistButton: View {
    let isInWatchlist: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(isInWatchlist ? "🗑 Remove" : "➕ Watchlist")
                .font(.caption)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isInWatchlist ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .shadow(radius: 3)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}




#Preview {
    MovieListView()
}

