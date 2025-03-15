import AVFoundation

class PaywallAudioPlayer {
    static let shared = PaywallAudioPlayer()
    var player: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Paywall Audio Session Hatası:", error)
        }
    }
    
    func setupPlayer(with url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("❌ Paywall Audio Player Hatası:", error)
        }
    }
    
    func play() {
        player?.play()
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
} 