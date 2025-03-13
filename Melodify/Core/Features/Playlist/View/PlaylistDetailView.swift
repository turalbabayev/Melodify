import SwiftUI

struct PlaylistDetailView: View {
    @StateObject private var viewModel: PlaylistDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSongPicker = false
    
    init(playlist: Playlist) {
        // PlaylistManager'dan güncel playlist'i al
        let currentPlaylist = PlaylistManager.shared.getPlaylist(by: playlist.id) ?? playlist
        _viewModel = StateObject(wrappedValue: PlaylistDetailViewModel(playlist: currentPlaylist))
    }
    
    var body: some View {
        ZStack {
            // Arkaplan
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
            
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    ZStack(alignment: .top) {
                        
                        
                        VStack(spacing: 20) {
                            // Playlist kapak resmi
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 200, height: 200)
                                    .shadow(color: .purple.opacity(0.3), radius: 10)
                                
                                Image(systemName: "music.note.list")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.top, 60)
                            
                            // Playlist bilgileri
                            VStack(spacing: 8) {
                                Text(viewModel.playlist.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("\(viewModel.playlist.songs.count) şarkı")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Şarkı listesi
                    VStack(spacing: 16) {
                        if viewModel.playlist.songs.isEmpty {
                            // Boş durum
                            VStack(spacing: 20) {
                                Image(systemName: "music.note")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                Text("Henüz şarkı eklenmemiş")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                
                                Button {
                                    showSongPicker = true
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Şarkı Ekle")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(Color.purple)
                                    .cornerRadius(25)
                                }
                            }
                            .padding(.top, 50)
                        } else {
                            // Şarkı listesi
                            ForEach(viewModel.playlist.songs) { song in
                                ModernSongRow(song: song) {
                                    // Favoriye ekleme işlemi
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.removeSong(song)
                                    } label: {
                                        Label("Listeden Çıkar", systemImage: "minus.circle")
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            
            // Üst bar
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    if !viewModel.playlist.songs.isEmpty {
                        Button {
                            showSongPicker = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSongPicker) {
            AddSongsView(viewModel: viewModel)
        }
    }
}

// Şarkı seçme ekranı
struct AddSongsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PlaylistDetailViewModel
    @State private var selectedSongs: Set<String> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.3),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.availableSongs) { song in
                            SongSelectionRow(
                                song: song,
                                isSelected: selectedSongs.contains(song.id)
                            ) {
                                if selectedSongs.contains(song.id) {
                                    selectedSongs.remove(song.id)
                                } else {
                                    selectedSongs.insert(song.id)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Add Songs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addSelectedSongs(Array(selectedSongs))
                        dismiss()
                    }
                    .disabled(selectedSongs.isEmpty)
                }
            }
        }
    }
}

// Şarkı seçim satırı
struct SongSelectionRow: View {
    let song: Song
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // Şarkı bilgileri (ModernSongRow'dan sadeleştirilmiş hali)
                HStack(spacing: 16) {
                    // Cover image
                    AsyncImage(url: song.imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 50, height: 50)
                    }
                    
                    Text(song.title)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .purple : .gray)
                    .font(.system(size: 22))
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
        }
    }
}

struct SongRow: View {
    let song: Song
    @State private var isPlaying = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Song Thumbnail
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.2))
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
            
            // Play Button
            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.purple)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

