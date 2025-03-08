import Foundation

class MusicPlayerViewModel: ObservableObject {
    private let audioPlayer = AudioPlayer.shared
    @Published var isPlaying = false {
        didSet {
            if isPlaying {
                audioPlayer.play()
            } else {
                audioPlayer.pause()
            }
        }
    }
    @Published var progress: Double = 0 {
        didSet {
            if isEditing {
                let time = progress * audioPlayer.getDuration()
                audioPlayer.seekTo(time)
            }
        }
    }
    @Published var currentTime: TimeInterval = 0
    @Published var volume: Double = 0.5 {
        didSet {
            audioPlayer.setVolume(Float(volume))
        }
    }
    @Published var isShuffleOn = false
    @Published var repeatMode: RepeatMode = .off
    @Published var isEditing = false
    
    private var timer: Timer?
    
    init() {
        setupTimer()
    }
    
    private func setupTimer() {
        // Timer'ı daha sık güncelle (60 FPS)
        timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if !self.isEditing {
                DispatchQueue.main.async {
                    self.currentTime = self.audioPlayer.getCurrentTime()
                    self.progress = self.currentTime / self.audioPlayer.getDuration()
                    
                    // Şarkı bittiğinde kontrol
                    if !self.audioPlayer.isPlaying() && self.isPlaying {
                        self.isPlaying = false
                    }
                }
            }
        }
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
    func previousTrack() {
        audioPlayer.stop()
        audioPlayer.play()
        isPlaying = true
    }
    
    func nextTrack() {
        audioPlayer.stop()
        audioPlayer.play()
        isPlaying = true
    }
    
    func toggleShuffle() {
        isShuffleOn.toggle()
    }
    
    func toggleRepeat() {
        switch repeatMode {
        case .off:
            repeatMode = .all
        case .all:
            repeatMode = .one
        case .one:
            repeatMode = .off
        }
    }
    
    deinit {
        timer?.invalidate()
        audioPlayer.stop()
    }
}

enum RepeatMode {
    case off, all, one
    
    var icon: String {
        switch self {
        case .off: return "repeat"
        case .all: return "repeat"
        case .one: return "repeat.1"
        }
    }
} 