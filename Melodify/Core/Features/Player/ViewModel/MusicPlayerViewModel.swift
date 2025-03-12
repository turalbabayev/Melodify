import Foundation
import Combine

class MusicPlayerViewModel: ObservableObject {
    static let shared = MusicPlayerViewModel()
    private let audioPlayer = AudioPlayer.shared
    
    @Published var currentSong: Song?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var progress: Double = 0
    @Published var volume: Double = 0.5
    @Published var isShuffleOn = false
    @Published var repeatMode: RepeatMode = .off
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // İsPlaying durumunu dinle
        audioPlayer.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isPlaying = value
            }
            .store(in: &cancellables)
        
        // Süre bilgilerini dinle
        audioPlayer.$currentTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.currentTime = value
                if let duration = self?.duration, duration > 0 {
                    self?.progress = value / duration
                }
            }
            .store(in: &cancellables)
        
        audioPlayer.$duration
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.duration = value
            }
            .store(in: &cancellables)
        
        // Yükleme durumunu dinle
        audioPlayer.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isLoading = value
            }
            .store(in: &cancellables)
    }
    
    func playSong(_ song: Song) {
        if currentSong?.id != song.id {
            audioPlayer.stop()
        }
        
        print("ViewModel - Şarkı çalınıyor:", song.title)
        currentSong = song
        audioPlayer.play(song)
    }
    
    func togglePlayPause() {
        audioPlayer.togglePlayPause()
    }
    
    func updateProgress(_ newProgress: Double) {
        let time = newProgress * duration
        audioPlayer.seekTo(time)
    }
    
    func toggleShuffle() {
        isShuffleOn.toggle()
    }
    
    func toggleRepeat() {
        switch repeatMode {
        case .off: repeatMode = .all
        case .all: repeatMode = .one
        case .one: repeatMode = .off
        }
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