import AVFoundation
import AVKit

class AudioPlayer: NSObject, ObservableObject {
    static let shared = AudioPlayer()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    
    @Published var isPlaying = false
    @Published var isLoading = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var currentSongId: String?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
            print("✅ Audio session başarıyla ayarlandı")
        } catch {
            print("🔊 Audio Session Hatası:", error)
        }
    }
    
    func play(_ song: Song) {
        print("📱 Çalma isteği başladı")
        
        guard let urlString = song.url?.absoluteString,
              let url = URL(string: urlString) else {
            print("❌ URL bulunamadı")
            return
        }
        
        // URL'yi kontrol et ve .mp3 uzantılı olduğundan emin ol
        if !urlString.hasSuffix(".mp3") {
            print("❌ Geçersiz URL formatı - MP3 değil")
            return
        }
        
        // Eğer aynı şarkı çalıyorsa, tekrar yüklemeye gerek yok
        if currentSongId == song.id {
            togglePlayPause()
            return
        }
        
        // Yükleniyor durumunu güncelle
        isLoading = true
        
        // Önceki çaları temizle
        stop()
        
        print("🎵 MP3 URL'si kontrol ediliyor:", urlString)
        
        // URL'nin geçerli olduğunu kontrol et
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ URL kontrol hatası:", error.localizedDescription)
                    self.isLoading = false
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("❌ URL erişilemez")
                    self.isLoading = false
                    return
                }
                
                print("✅ MP3 URL'si geçerli, çalma başlatılıyor")
                
                // AVPlayer için item oluştur
                let asset = AVURLAsset(url: url)
                let playerItem = AVPlayerItem(asset: asset)
                
                // Player'ı ayarla
                self.player = AVPlayer(playerItem: playerItem)
                self.playerItem = playerItem
                
                // Status değişikliklerini dinle
                playerItem.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
                
                // Asset yüklendiğinde bildirim al
                NotificationCenter.default.addObserver(self,
                                                     selector: #selector(self.playerItemDidReachEnd),
                                                     name: .AVPlayerItemDidPlayToEndTime,
                                                     object: playerItem)
                
                // Zaman gözlemcisini ayarla
                self.addTimeObserver()
                
                // Şarkı ID'sini güncelle
                self.currentSongId = song.id
                
                // Çalmaya başla
                self.player?.play()
                self.isPlaying = true
            }
        }.resume()
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = CMTimeGetSeconds(time)
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            player?.pause()
            isPlaying = false
            print("⏸️ Şarkı duraklatıldı")
        } else {
            player?.play()
            isPlaying = true
            print("▶️ Şarkı devam ediyor")
        }
    }
    
    func seekTo(_ time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self?.player?.seek(to: cmTime)
        }
    }
    
    func setVolume(_ volume: Float) {
        player?.volume = volume
    }
    
    func stop() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Çalmayı durdur
            self.player?.pause()
            self.player?.seek(to: .zero)
            self.isPlaying = false
            self.currentTime = 0
            
            // Önceki kaynakları temizle
            //self.removeTimeObserver()
            self.player = nil
            self.playerItem = nil
            self.currentSongId = nil
            
            print("⏹️ Oynatma durduruldu ve sıfırlandı")
        }
    }
    
    deinit {
        //removeTimeObserver()
        player?.pause()
        player = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status",
           let playerItem = object as? AVPlayerItem {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch playerItem.status {
                case .readyToPlay:
                    print("✅ Oynatıcı hazır")
                    self.duration = CMTimeGetSeconds(playerItem.duration)
                    self.isLoading = false
                case .failed:
                    print("❌ Oynatma hatası:", playerItem.error?.localizedDescription ?? "Bilinmeyen hata")
                    if let error = playerItem.error as NSError? {
                        print("Hata detayı:", error)
                    }
                    self.isLoading = false
                default:
                    print("⏳ Yükleniyor...")
                    break
                }
            }
        }
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            print("🎵 Şarkı bitti")
            // Şarkı bittiğinde işlem yapabilirsiniz
        }
    }
}

