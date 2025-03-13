import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var viewModel: MusicPlayerViewModel
    @State private var showFullPlayer = false
    @State private var offset: CGFloat = 0
    let song: Song
    
    var body: some View {
        Group {
            if viewModel.currentSong != nil {
                VStack(spacing: 0) {
                    // Progress Bar
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: geometry.size.width * viewModel.progress, height: 2)
                    }
                    .frame(height: 2)
                    
                    // Mini Player Content
                    HStack(spacing: 12) {
                        // Şarkı resmi ve bilgileri (tıklanabilir alan)
                        Button {
                            showFullPlayer = true
                        } label: {
                            HStack(spacing: 12) {
                                // Şarkı resmi
                                if let imageUrl = viewModel.currentSong?.imageUrl {
                                    AsyncImage(url: imageUrl) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.purple.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                                    .scaleEffect(0.7)
                                            )
                                    }
                                } else {
                                    // Varsayılan görünüm
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "music.note")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white.opacity(0.8))
                                        )
                                }
                                
                                // Şarkı bilgileri
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(viewModel.currentSong?.title ?? "")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                }
                            }
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
                .background(.ultraThinMaterial)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation.width
                        }
                        .onEnded { gesture in
                            let width = UIScreen.main.bounds.width
                            if abs(gesture.translation.width) > width * 0.3 {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = gesture.translation.width > 0 ? width : -width
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    viewModel.currentSong = nil
                                    if viewModel.isPlaying {
                                        viewModel.togglePlayPause()
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    offset = 0
                                }
                            }
                        }
                )
                .fullScreenCover(isPresented: $showFullPlayer) {
                    MusicPlayerView(song: song)
                }
            }
        }
    }
} 
