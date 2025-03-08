import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var selectedTab: LibraryTab = .songs
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Animated Gradient Background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.3),
                        //Color.blue.opacity(0.2),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Modern Header
                    HStack(alignment: .lastTextBaseline) {
                        Text("Library")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            // Search action
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    
                    // Modern Tab Selector
                    HStack(spacing: 20) {
                        ForEach(LibraryTab.allCases, id: \.self) { tab in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTab = tab
                                }
                            } label: {
                                Text(tab.title)
                                    .font(.system(size: 15, weight: selectedTab == tab ? .semibold : .regular))
                                    .foregroundColor(selectedTab == tab ? .white : .gray)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    .background(
                                        selectedTab == tab ?
                                        Color.white.opacity(0.1) : Color.clear
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        SongsTab(viewModel: viewModel)
                            .tag(LibraryTab.songs)
                        
                        PlaylistsTab(viewModel: viewModel)
                            .tag(LibraryTab.playlists)
                        
                        FavoritesTab(viewModel: viewModel)
                            .tag(LibraryTab.favorites)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .padding(.top, 20)
                }
            }
        }
    }
}

// MARK: - Songs Tab
struct SongsTab: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(viewModel.songs) { song in
                    ModernSongRow(song: song, onFavoriteToggle: {
                        viewModel.toggleFavorite(song)
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct ModernSongRow: View {
    let song: Song
    let onFavoriteToggle: () -> Void
    @State private var isPlaying = false
    @State private var showPlayer = false // Sheet kontrolü için
    
    var body: some View {
        HStack(spacing: 16) {
            // Song Cover ve Info kısmı - tıklanabilir alan
            Button {
                showPlayer = true
            } label: {
                HStack(spacing: 16) {
                    // Song Cover
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 55, height: 55)
                        
                        Image(systemName: "music.note")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Song Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(song.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(formatDuration(song.duration))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 12) {
                Button {
                    onFavoriteToggle()
                } label: {
                    Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(song.isFavorite ? .purple : .gray)
                }
                
                Button {
                    showPlayer = true
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(
                            LinearGradient(
                                colors: [.purple, .purple.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .fullScreenCover(isPresented: $showPlayer, content: {
            MusicPlayerView(song: song)
               // .edgesIgnoringSafeArea(.all)
        })
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Playlists Tab
struct PlaylistsTab: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ],
                spacing: 15
            ) {
                ForEach(viewModel.playlists) { playlist in
                    LibraryPlaylistCard(playlist: playlist)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Favorites Tab
struct FavoritesTab: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(viewModel.favoriteSongs) { song in
                    ModernSongRow(song: song, onFavoriteToggle: {
                        viewModel.toggleFavorite(song)
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Library Song Row
struct LibrarySongRow: View {
    let song: Song
    var showFavoriteButton: Bool = true
    @State private var isPlaying = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Song Cover
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "music.note")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Song Info
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(formatDuration(song.duration))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Favorite Button
            if showFavoriteButton {
                Button {
                    // Toggle favorite
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.purple)
                        .font(.system(size: 18))
                }
                .padding(.trailing, 8)
            }
            
            // Play Button
            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.purple)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Library Playlist Card
struct LibraryPlaylistCard: View {
    let playlist: Playlist
    
    var body: some View {
        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
            VStack(alignment: .leading, spacing: 12) {
                // Cover
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.5), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 160)
                        .overlay(
                            Image(systemName: "music.note.list")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.8))
                        )
                }
                .shadow(color: .purple.opacity(0.2), radius: 8, x: 0, y: 4)
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(playlist.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(playlist.songs.count) songs")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
            }
            .background(Color.white.opacity(0.03))
            .cornerRadius(16)
        }
    }
}

// MARK: - Library Tab Enum
enum LibraryTab: String, CaseIterable {
    case songs, playlists, favorites
    
    var title: String {
        switch self {
        case .songs: return "Songs"
        case .playlists: return "Playlists"
        case .favorites: return "Favorites"
        }
    }
    
    var icon: String {
        switch self {
        case .songs: return "music.note"
        case .playlists: return "music.note.list"
        case .favorites: return "heart.fill"
        }
    }
}

#Preview {
    LibraryView()
} 
