import SwiftUI

struct MusicPlayerView: View {
    let song: Song
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MusicPlayerViewModel
    @State private var dragOffset: CGFloat = 0
    @State private var showLyrics = false
    
    init(song: Song) {
        self.song = song
        self.viewModel = MusicPlayerViewModel.shared
    }
    
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
                    PlayerHeader(
                        dismiss: dismiss,
                        showLyrics: $showLyrics,
                        song: song
                    )
                    
                    if showLyrics {
                        // Lyrics View
                        LyricsView(
                            lyrics: song.lyrics ?? [],
                            currentTime: 0
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
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let translation = gesture.translation.height
                    let progress = min(max(0, translation / UIScreen.main.bounds.height), 1)
                    dragOffset = translation * pow(progress, 0.5)
                }
                .onEnded { gesture in
                    let translation = gesture.translation.height
                    let velocity = gesture.velocity.height
                    
                    if translation > 50 || velocity > 1000 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            dragOffset = UIScreen.main.bounds.height
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            dismiss()
                        }
                    } else {
                        withAnimation(.spring()) {
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
    let song: Song
    @State private var showShareSheet = false
    
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
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: ["Check out this awesome song I found on Melodify!\n\n🎵 \(song.title)"])
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
    
    var defaultCoverView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 300, height: 300)
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.8))
            )
            .shadow(color: .purple.opacity(0.3), radius: 20)
    }
    
    var body: some View {
        // Album Art
        ZStack {
            if let imageUrl = song.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } placeholder: {
                    // Yükleme sırasında gösterilecek placeholder
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.5), .blue.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300, height: 300)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                }
            } else {
                // Resim URL'si yoksa varsayılan görünüm
                defaultCoverView
            }
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
            Slider(value: Binding(
                get: { viewModel.progress },
                set: { viewModel.updateProgress($0) }
            ), in: 0...1)
            .accentColor(.purple)
            
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
                Image(systemName: "shuffle")
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.isShuffleOn ? .purple : .gray)
            }
            
            Button {
                //viewModel.previousTrack()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            Button {
                viewModel.togglePlayPause()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 64, height: 64)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                            .scaleEffect(1.5)
                    } else {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.purple)
                            .offset(x: viewModel.isPlaying ? 0 : 2)
                    }
                }
            }
            .disabled(viewModel.isLoading)
            
            Button {
                //viewModel.nextTrack()
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
            
            Slider(value: $viewModel.volume, in: 0...1)
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
