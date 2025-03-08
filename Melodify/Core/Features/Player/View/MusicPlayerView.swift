import SwiftUI

struct MusicPlayerView: View {
    let song: Song
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MusicPlayerViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var showLyrics = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background layers
                Color.black.ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.3),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main Content
                VStack(spacing: 0) {
                    // Header with drag indicator
                    PlayerHeader(dismiss: dismiss, showLyrics: $showLyrics)
                    
                    if showLyrics {
                        // Lyrics View
                        LyricsView(
                            lyrics: song.lyrics ?? [],
                            currentTime: viewModel.currentTime
                        )
                    } else {
                        // Normal Player View
                        PlayerContent(song: song, viewModel: viewModel)
                    }
                }
                .offset(y: dragOffset)
            }
        }
        .presentationDragIndicator(.hidden)
        .presentationDetents([.large])
        .presentationBackground(.ultraThinMaterial)
        .interactiveDismissDisabled()
        .gesture(DragGesture()
            .onChanged { gesture in
                let translation = gesture.translation.height
                let progress = min(max(0, translation / UIScreen.main.bounds.height), 1)
                dragOffset = translation * pow(progress, 0.5)
            }
            .onEnded { gesture in
                let translation = gesture.translation.height
                let velocity = gesture.velocity.height
                
                if translation > 150 || velocity > 1500 {
                    withAnimation(.easeOut(duration: 0.2)) {
                        dragOffset = UIScreen.main.bounds.height
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        dismiss()
                    }
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dragOffset = 0
                    }
                }
            }
        )
    }
}

// MARK: - Player Header
struct PlayerHeader: View {
    let dismiss: DismissAction
    @Binding var showLyrics: Bool
    
    var body: some View {
        VStack {
            // Drag Indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, 10)
            
            HStack {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showLyrics.toggle()
                    }
                } label: {
                    Text(showLyrics ? "Player" : "Lyrics")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Button {
                    // Options menu
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
}

// MARK: - Lyrics View
struct LyricsView: View {
    let lyrics: [LyricLine]
    let currentTime: TimeInterval
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    ForEach(lyrics) { line in
                        Text(line.text)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(isCurrentLine(line) ? .white : .gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .id(line.id)
                            .scaleEffect(isCurrentLine(line) ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCurrentLine(line))
                    }
                }
                .padding(.vertical, 40)
            }
            .onChange(of: currentTime) { _ in
                if let currentLine = lyrics.first(where: { isCurrentLine($0) }) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        proxy.scrollTo(currentLine.id, anchor: .center)
                    }
                }
            }
        }
    }
    
    private func isCurrentLine(_ line: LyricLine) -> Bool {
        let nextLineTime = lyrics
            .first(where: { $0.timestamp > line.timestamp })?
            .timestamp ?? Double.infinity
        
        return currentTime >= line.timestamp && currentTime < nextLineTime
    }
}

// MARK: - Player Content
struct PlayerContent: View {
    let song: Song
    @ObservedObject var viewModel: MusicPlayerViewModel
    
    var body: some View {
        // Album Art
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            .purple.opacity(0.5),
                            .blue.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: UIScreen.main.bounds.width - 80)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                )
                .shadow(color: .purple.opacity(0.3), radius: 20)
        }
        .padding(.horizontal, 40)
        .padding(.top, 40)
        
        // Song Info
        VStack(spacing: 8) {
            Text(song.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("Artist Name") // Bu kısmı Song modeline artist ekleyince güncelleyeceğiz
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
        
        // Progress Bar
        VStack(spacing: 8) {
            Slider(value: $viewModel.progress, in: 0...1) { editing in
                viewModel.isEditing = editing
            }
            .tint(.white)
            
            HStack {
                Text(formatDuration(viewModel.currentTime))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(formatDuration(song.duration))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        
        // Controls
        HStack(spacing: 40) {
            Button {
                viewModel.toggleShuffle()
            } label: {
                Image(systemName: viewModel.isShuffleOn ? "shuffle" : "shuffle")
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.isShuffleOn ? .purple : .gray)
            }
            
            Button {
                viewModel.previousTrack()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Button {
                viewModel.togglePlayPause()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.white)
            }
            
            Button {
                viewModel.nextTrack()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Button {
                viewModel.toggleRepeat()
            } label: {
                Image(systemName: viewModel.repeatMode.icon)
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.repeatMode != .off ? .purple : .gray)
            }
        }
        .padding(.top, 40)
        
        Spacer()
        
        // Volume Slider
        HStack(spacing: 15) {
            Image(systemName: "speaker.fill")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Slider(value: $viewModel.volume)
                .tint(.white)
            
            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
} 