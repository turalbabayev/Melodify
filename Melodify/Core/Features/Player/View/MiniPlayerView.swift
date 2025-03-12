import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var viewModel: MusicPlayerViewModel
    @State private var showFullPlayer = false
    let song: Song
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.purple)
                    .frame(width: geometry.size.width * viewModel.progress, height: 2)
            }
            .frame(height: 2)
             
            
            // Mini Player Content
            Button {
                showFullPlayer = true
            } label: {
                HStack(spacing: 12) {
                    // Album Art
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "music.note")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Song Info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(song.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text("Now Playing")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Controls
                    HStack(spacing: 20) {
                        Button {
                            viewModel.togglePlayPause()
                        } label: {
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        
                        Button {
                            //viewModel.nextTrack()
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color.black.opacity(0.95))
        }
        .fullScreenCover(isPresented: $showFullPlayer) {
            MusicPlayerView(song: song)
        }
    }
} 
