import Foundation
import AVFoundation

class AudioPlayer {
    static let shared = AudioPlayer()
    private var player: AVAudioPlayer?
    
    private init() {
        prepareAudio()
    }
    
    private func prepareAudio() {
        if let url = Bundle.main.url(forResource: "sample-music", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                print("Audio hazırlandı, duration: \(player?.duration ?? 0)")
            } catch {
                print("Müzik yüklenemedi: \(error.localizedDescription)")
                print("Error detayı: \(error)")
            }
        } else {
            print("sample-music.mp3 dosyası bulunamadı")
            print("Bundle içindeki dosyalar:")
            for path in Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil) {
                print(path)
            }
        }
    }
    
    func play() {
        if player == nil {
            prepareAudio()
        }
        
        if let player = player {
            if !player.isPlaying {
                player.play()
                print("Audio çalmaya başladı")
            }
        } else {
            print("Player nil")
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
        player?.currentTime = 0
    }
    
    func getCurrentTime() -> TimeInterval {
        return player?.currentTime ?? 0
    }
    
    func getDuration() -> TimeInterval {
        return player?.duration ?? 0
    }
    
    func setVolume(_ volume: Float) {
        player?.volume = volume
    }
    
    func seekTo(_ time: TimeInterval) {
        player?.currentTime = time
    }
    
    func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }
} 