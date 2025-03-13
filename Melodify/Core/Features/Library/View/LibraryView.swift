import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel: LibraryViewModel
    @ObservedObject var mainViewModel: MainViewModel
    @State private var showMusicGenerator = false
    
    init(mainViewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: LibraryViewModel(mainViewModel: mainViewModel))
        self.mainViewModel = mainViewModel
    }
    
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
                        Text("library_title".localized)
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
                    
                    ScrollView {
                        switch selectedTab {
                        case .songs:
                            if viewModel.songs.isEmpty {
                                emptyStateView(
                                    image: "music.note",
                                    title: "Henüz Şarkı Yok",
                                    message: "Yeni bir şarkı oluşturmak için tıklayın",
                                    buttonAction: { showMusicGenerator = true }
                                )
                            } else {
                                SongsTab(viewModel: viewModel)
                            }
                            
                        case .favorites:
                            if viewModel.favoriteSongs.isEmpty {
                                emptyStateView(
                                    image: "heart",
                                    title: "Favori Şarkı Yok",
                                    message: "Favori şarkılarınız burada görünecek",
                                    buttonAction: { selectedTab = .songs }
                                )
                            } else {
                                FavoritesTab(viewModel: viewModel)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    private func emptyStateView(image: String, title: String, message: String, buttonAction: @escaping () -> Void) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            // İkon
            Image(systemName: image)
                .font(.system(size: 70))
                .foregroundColor(.purple.opacity(0.7))
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Aksiyon butonu
            Button(action: buttonAction) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.purple)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Songs Tab
struct SongsTab: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(viewModel.songs) { song in
                    ModernSongRow(song: song) {
                        viewModel.toggleFavorite(song)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .padding(.top, 16)
        }
    }
}

struct ModernSongRow: View {
    let song: Song
    let onFavoriteToggle: () -> Void
    @StateObject private var playerViewModel = MusicPlayerViewModel.shared
    @State private var showPlayer = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Song Cover ve Info kısmı
            Button {
                if !song.isGenerating && song.url != nil {
                    showPlayer = true
                    Task {
                        await playWithDelay()
                    }
                }
            } label: {
                HStack(spacing: 16) {
                    // Song Cover
                    ZStack {
                        if let imageUrl = song.imageUrl {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            }
                            .frame(width: 50, height: 50 )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 55, height: 55)
                        }
                        
                        if song.isGenerating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else if song.url == nil {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Image(systemName: "music.note")
                                .font(.system(size: 22))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    // Song Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(song.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        if song.isGenerating {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(song.generationStatus?.generationStep.rawValue ?? "Generating...")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                // Progress bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 2)
                                        
                                        Rectangle()
                                            .fill(Color.purple)
                                            .frame(width: geometry.size.width * progressValue(for: song.generationStatus ?? .PENDING), height: 2)
                                    }
                                }
                                .frame(height: 2)
                            }
                        } else {
                            Text(formatDuration(song.duration))
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .disabled(song.isGenerating || song.url == nil)
            
            Spacer()
            
            
            
            // Favorite Button
            if !song.isGenerating && song.url != nil {
                Button(action: onFavoriteToggle) {
                    Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(song.isFavorite ? .purple : .gray)
                }
            }
            
            // Play Button - sadece şarkı hazırsa göster
            if !song.isGenerating && song.url != nil {
                Button {
                    Task {
                        await playWithDelay()
                    }
                } label: {
                    Image(systemName: playerViewModel.isPlaying && playerViewModel.currentSong?.id == song.id ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.purple)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .fullScreenCover(isPresented: $showPlayer) {
            MusicPlayerView(song: song)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func progressValue(for status: TaskStatus) -> Double {
        switch status {
        case .PENDING: return 0.1
        case .TEXT_SUCCESS: return 0.3
        case .FIRST_SUCCESS: return 0.7
        case .SUCCESS: return 1.0
        default: return 0.0
        }
    }
    
    private func playWithDelay() async {
        // UI'ın düzgün açılması için kısa bir gecikme
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 saniye
        
        // Ana thread'de çalıştır
        await MainActor.run {
            playerViewModel.playSong(song)
        }
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
                    ModernSongRow(song: song) {
                        viewModel.toggleFavorite(song)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
            .padding(.top, 16)
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
    case songs, favorites
    
    var title: String {
        switch self {
        case .songs: return "library_songs".localized
        case .favorites: return "library_favorites".localized
        }
    }
    
    var icon: String {
        switch self {
        case .songs: return "music.note"
        case .favorites: return "heart.fill"
        }
    }
}

#Preview {
    LibraryView(mainViewModel: MainViewModel())
} 
