import SwiftUI

struct PlaylistHeaderView: View {
    let playlist: Playlist
    
    var body: some View {
        VStack(spacing: 16) {
            // Playlist Cover
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
            
            // Playlist Info
            VStack(spacing: 8) {
                Text(playlist.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(playlist.songs.count) songs")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 20)
    }
} 
