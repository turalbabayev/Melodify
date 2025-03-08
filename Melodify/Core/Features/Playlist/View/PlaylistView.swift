import SwiftUI

struct PlaylistView: View {
    @StateObject private var viewModel = PlaylistViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background with gradient
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.2),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Modern Header with blur effect
                        ZStack {
                            // Blur background
                            Color.black.opacity(0.7)
                                .blur(radius: 10)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("PLAYLISTS")
                                    .font(.system(size: 14, weight: .semibold))
                                    .tracking(2)
                                    .foregroundColor(.gray)
                                
                                Text("Your Music Collection")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                        }
                        .frame(height: 140)
                        
                        if viewModel.playlists.isEmpty {
                            EmptyPlaylistView(viewModel: viewModel)
                        } else {
                            PlaylistContentView(viewModel: viewModel)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                // Floating Action Button
                if !viewModel.playlists.isEmpty {
                    FloatingAddButton(viewModel: viewModel)
                }
            }
            .navigationBarHidden(true) // Navigation bar'ı gizle
            .sheet(isPresented: $viewModel.showingCreateSheet) {
                CreatePlaylistSheet(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyPlaylistView: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image("playlist-empty-dark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .opacity(0.8)
            
            Text("No Playlists Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Create your first playlist to start organizing your music")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                viewModel.showingCreateSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Playlist")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.purple)
                .cornerRadius(25)
            }
            .padding(.top, 10)
        }
        .padding(.top, 40)
    }
}

// MARK: - Content View
struct PlaylistContentView: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            if let featured = viewModel.featuredPlaylist {
                FeaturedSection(featured: featured, viewModel: viewModel)
            }
            
            AllPlaylistsSection(viewModel: viewModel)
        }
        .padding(.top, 20)
    }
}

// MARK: - Featured Section
struct FeaturedSection: View {
    let featured: Playlist
    @ObservedObject var viewModel: PlaylistViewModel
    @State private var showingFeaturedOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("FEATURED PLAYLIST")
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(1.5)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button {
                    showingFeaturedOptions = true
                } label: {
                    HStack(spacing: 4) {
                        Text("Change")
                            .font(.system(size: 13, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.purple)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.purple.opacity(0.15))
                    .cornerRadius(15)
                }
            }
            .padding(.horizontal, 20)
            
            FeaturedPlaylistCard(playlist: featured)
                .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingFeaturedOptions) {
            FeaturedPlaylistPicker(viewModel: viewModel, showing: $showingFeaturedOptions)
        }
    }
}

// MARK: - All Playlists Section
struct AllPlaylistsSection: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ALL PLAYLISTS")
                .font(.system(size: 13, weight: .semibold))
                .tracking(1.5)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ],
                spacing: 15
            ) {
                ForEach(viewModel.playlists) { playlist in
                    ModernPlaylistCard(playlist: playlist)
                        .contextMenu {
                            Button(role: .none) {
                                viewModel.setFeaturedPlaylist(playlist)
                            } label: {
                                Label(
                                    playlist.id == viewModel.featuredPlaylistId ? "Remove from Featured" : "Set as Featured",
                                    systemImage: playlist.id == viewModel.featuredPlaylistId ? "star.slash" : "star.fill"
                                )
                            }
                            
                            Button(role: .destructive) {
                                viewModel.deletePlaylist(playlist)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100) // TabBar için extra padding
        }
    }
}

// MARK: - Floating Add Button
struct FloatingAddButton: View {
    @ObservedObject var viewModel: PlaylistViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.showingCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.purple)
                        .clipShape(Circle())
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 90)
            }
        }
    }
}

struct FeaturedPlaylistCard: View {
    let playlist: Playlist
    
    var body: some View {
        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
            HStack(spacing: 20) {
                // Playlist Cover
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.7), .blue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "music.note.list")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.8))
                        )
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                // Playlist Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(playlist.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(playlist.songs.count) songs")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Play Button
                    HStack {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                        
                        Text("Play")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.purple.opacity(0.3))
                    .cornerRadius(20)
                }
                
                Spacer()
            }
            .padding(15)
            .background(Color.white.opacity(0.05))
            .cornerRadius(25)
        }
    }
}

struct ModernPlaylistCard: View {
    let playlist: Playlist
    
    var body: some View {
        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
            VStack(alignment: .leading, spacing: 12) {
                // Cover
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
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
            .cornerRadius(20)
        }
    }
}

// Yeni Featured Playlist Picker View ekle
struct FeaturedPlaylistPicker: View {
    @ObservedObject var viewModel: PlaylistViewModel
    @Binding var showing: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.9).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.playlists) { playlist in
                            Button {
                                viewModel.setFeaturedPlaylist(playlist)
                                dismiss()
                            } label: {
                                HStack(spacing: 16) {
                                    // Playlist icon
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: "music.note.list")
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    // Playlist info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(playlist.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text("\(playlist.songs.count) songs")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    // Selected indicator
                                    if playlist.id == viewModel.featuredPlaylistId {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.purple)
                                            .font(.system(size: 22))
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Set Featured Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PlaylistView()
} 
