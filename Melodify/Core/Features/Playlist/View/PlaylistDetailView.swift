import SwiftUI

struct PlaylistDetailView: View {
    let playlist: Playlist
    @Environment(\.dismiss) private var dismiss
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section with Parallax Effect
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .global).minY
                        
                        ZStack {
                            // Background Gradient
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.3),
                                    Color.black.opacity(0.9)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            
                            // Playlist Icon with Animation
                            VStack(spacing: 16) {
                                Circle()
                                    .fill(Color.purple.opacity(0.2))
                                    .frame(width: 160, height: 160)
                                    .overlay(
                                        Image(systemName: "music.note.list")
                                            .font(.system(size: 60))
                                            .foregroundColor(.white.opacity(0.8))
                                    )
                                    .shadow(color: .purple.opacity(0.3), radius: 10)
                                    .offset(y: -minY * 0.5)
                                
                                VStack(spacing: 8) {
                                    Text(playlist.name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    if let description = playlist.description {
                                        Text(description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                    
                                    HStack(spacing: 4) {
                                        Text("\(playlist.songs.count)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(playlist.songs.count == 1 ? "song" : "songs")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .offset(y: -minY * 0.2)
                            }
                            .padding(.top, 60)
                        }
                        .frame(height: 380 + max(0, minY))
                        .offset(y: -max(0, minY))
                    }
                    .frame(height: 380)
                    
                    // Songs List Section
                    VStack(spacing: 0) {
                        if playlist.songs.isEmpty {
                            // Empty State
                            VStack(spacing: 16) {
                                Image(systemName: "music.note")
                                    .font(.system(size: 44))
                                    .foregroundColor(.gray.opacity(0.6))
                                
                                Text("No Songs Yet")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("Add your favorite songs to this playlist")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Button {
                                    // Add song action
                                } label: {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add Songs")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                                    .background(Color.purple)
                                    .cornerRadius(25)
                                }
                                .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            // Songs List
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(playlist.songs) { song in
                                    ModernSongRow(song: song, onFavoriteToggle: {
                                        // Playlist içindeki şarkının favori durumunu güncelle
                                        // Bu kısmı PlaylistViewModel'e eklememiz gerekecek
                                    })
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(16)
                        }
                    }
                    .background(Color.black)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .none) {
                        // Add songs action
                    } label: {
                        Label("Add Songs", systemImage: "plus")
                    }
                    
                    Button(role: .none) {
                        // Share playlist action
                    } label: {
                        Label("Share Playlist", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                        // Delete playlist action
                    } label: {
                        Label("Delete Playlist", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        // Swipe back gesture'ı korumak için
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        dismiss()
                    }
                }
        )
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

