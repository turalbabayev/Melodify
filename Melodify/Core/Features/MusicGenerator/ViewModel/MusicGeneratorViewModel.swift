//
//  MusicGeneratorViewModel.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI
import Combine

class MusicGeneratorViewModel: ObservableObject {
    @Published var musicPrompt = MusicPrompt()
    @Published var selectedTab: Tab = .prompt
    @Published var isLoading = false
    @Published var error: String?
    @Published var generatedMusic: [GeneratedMusic] = []
    @Published var showCreditAlert = false
    @Published var remainingCredits: Int = 0
    @Published var placeholder: String?
    @Published var deneme: Int = 0
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    enum Tab {
        case prompt, compose
    }
    
    private let service = MusicGenerationService.shared
    private let mainViewModel: MainViewModel
    private let creditManager = CreditStateManager.shared
    private let userService = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        creditManager.$currentCredits
            .assign(to: \.remainingCredits, on: self)
            .store(in: &cancellables)
    }
    
    // Compose View için müzik üretme
    func generateMusicFromCompose() {
        guard validateComposeInput() else {
            print("❌ Validation failed for Compose View")
            return 
        }
        
        // Kredi kontrolü (12 kredi)
        guard userService.updateCredits(-12) else {
            showCreditAlert = true
            return
        }
        
        print("✅ Validation passed for Compose View")
        generateMusicRequest(
            prompt: musicPrompt.lyrics,
            style: musicPrompt.style,
            title: musicPrompt.title,
            customMode: true,
            instrumental: musicPrompt.instrumental
        )
    }
    
    // Prompt View için müzik üretme
    func generateMusicFromPrompt() {
        guard validatePromptInput() else {
            print("❌ Validation failed for Prompt View")
            return
        }
        
        // Kredi kontrolü (12 kredi)
        guard userService.updateCredits(-12) else {
            showCreditAlert = true
            return
        }
        
        print("✅ Validation passed for Prompt View")
        generateMusicRequest(
            prompt: musicPrompt.prompt,
            customMode: false,
            instrumental: musicPrompt.instrumental
        )
    }
    
    private func generateMusicRequest(
        prompt: String,
        style: String? = nil,
        title: String? = nil,
        customMode: Bool,
        instrumental: Bool
    ) {
        print("\n🚀 Starting API Request:")
        print("📝 Prompt: \(prompt)")
        print("🎨 Style: \(style ?? "None")")
        print("📌 Title: \(title ?? "None")")
        print("⚙️ Custom Mode: \(customMode)")
        print("🎼 Instrumental: \(instrumental)")
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let taskId = try await service.generateMusic(
                    prompt: prompt,
                    style: style,
                    title: title,
                    customMode: customMode,
                    instrumental: instrumental
                )
                
                print("✅ API Request Successful")
                print("📋 Task ID: \(taskId)")
                
                // Başarılı durumda library'ye yönlendir ve pending şarkı ekle
                await MainActor.run {
                    let pendingMusic = GeneratedMusic(
                        id: UUID().uuidString,
                        title: "Creating your music...",
                        prompt: prompt,
                        status: .PENDING
                    )
                    mainViewModel.addGeneratedSongs([pendingMusic])
                    mainViewModel.selectedTab = .library
                }
                
                try await pollTaskStatus(taskId: taskId)
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    self.error = error.localizedDescription
                    self.errorMessage = "Müzik oluşturulurken bir hata oluştu. Lütfen daha sonra tekrar deneyin."
                    self.showErrorAlert = true
                    
                    // Hata durumunda kredileri geri yükle
                    userService.updateCredits(12)
                }
                print("❌ API Request Failed")
                print("💥 Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func pollTaskStatus(taskId: String) async throws {
            let delaySeconds: UInt64 = 10
            var attempts = 0
            let maxAttempts = 120
            
            while attempts < maxAttempts {
                attempts += 1
                
                let taskData = try await service.checkTaskStatus(taskId: taskId)
                
                // Durumu güncelle
                await MainActor.run {
                    // Tüm generating durumundaki şarkıları güncelle
                    mainViewModel.generatedSongs = mainViewModel.generatedSongs.map { song in
                        if song.status == .PENDING {
                            var updatedSong = song
                            updatedSong.status = taskData.status
                            updatedSong.title = getStatusTitle(taskData.status)
                            return updatedSong
                        }
                        return song
                    }
                }
                
                switch taskData.status {
                case .SUCCESS:
                    if let response = taskData.response {
                        await MainActor.run {
                            // Önce tüm PENDING durumundaki şarkıları kaldır
                            mainViewModel.generatedSongs.removeAll { $0.status != .SUCCESS }
                            
                            // Sonra yeni şarkıları ekle
                            mainViewModel.addGeneratedSongs(response.sunoData)
                            self.isLoading = false
                        }
                    }
                    return
                    
                case .PENDING, .TEXT_SUCCESS, .FIRST_SUCCESS:
                    try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                    continue
                    
                case .CREATE_TASK_FAILED, .GENERATE_AUDIO_FAILED,
                     .CALLBACK_EXCEPTION, .SENSITIVE_WORD_ERROR:
                    if let errorMessage = taskData.errorMessage {
                        throw MusicGenerationError.customError(errorMessage)
                    } else {
                        throw MusicGenerationError.invalidResponse
                    }
                }
            }
            
            throw MusicGenerationError.timeoutError
        }
    
    private func getStatusTitle(_ status: TaskStatus) -> String {
        switch status {
        case .PENDING:
            return "Waiting to start..."
        case .TEXT_SUCCESS:
            return "Generating lyrics..."
        case .FIRST_SUCCESS:
            return "Creating melody..."
        case .SUCCESS:
            return "Almost done..."
        default:
            return "Processing..."
        }
    }
    
    // Üretilen müzik detaylarını yazdırmak için yardımcı fonksiyon
    private func printGeneratedMusicDetails(_ music: [GeneratedMusic]) {
        print("\n🎵 Generated Music Details:")
        for (index, track) in music.enumerated() {
            print("\n📀 Track \(index + 1):")
            print("🎼 Title: \(track.title)")
            print("🎯 Tags: \(track.tags)")
            print("🔊 Stream URL: \(track.streamAudioUrl)")
            print("🖼️ Cover Image: \(track.imageUrl)")
            print("📝 Generated Lyrics/Prompt:")
            print(track.prompt)
            print("⏱️ Duration: \(track.duration ?? 0) seconds")
            print("-------------------")
        }
    }
    
    // Compose View için validasyon
    private func validateComposeInput() -> Bool {
        if musicPrompt.instrumental {
            guard !musicPrompt.style.isEmpty, !musicPrompt.title.isEmpty else {
                error = "Style and title are required in custom mode"
                return false
            }
        } else {
            guard !musicPrompt.lyrics.isEmpty, !musicPrompt.style.isEmpty, !musicPrompt.title.isEmpty else {
                error = "Lyrics, style and title are required in custom mode"
                return false
            }
            guard musicPrompt.lyrics.count <= 3000 else {
                error = "Lyrics cannot exceed 3000 characters"
                return false
            }
        }
        guard musicPrompt.style.count <= 200 else {
            error = "Style cannot exceed 200 characters"
            return false
        }
        guard musicPrompt.title.count <= 80 else {
            error = "Title cannot exceed 80 characters"
            return false
        }
        return true
    }
    
    // Prompt View için validasyon
    private func validatePromptInput() -> Bool {
        guard !musicPrompt.prompt.isEmpty else {
            error = "Prompt is required"
            return false
        }
        guard musicPrompt.prompt.count <= 400 else {
            error = "Prompt cannot exceed 400 characters"
            return false
        }
        return true
    }
    
    private func handleMusicResponse(_ music: GeneratedMusic) {
        // Önce .mp3 uzantılı URL'yi tercih et
        let audioUrl = [music.sourceAudioUrl, music.audioUrl]
            .compactMap { $0 }
            .first { $0.hasSuffix(".mp3") }
        
        if let audioUrl = audioUrl {
            print("🎵 MP3 URL'si bulundu:", audioUrl)
        } else {
            print("⚠️ MP3 URL'si bulunamadı, stream URL kullanılacak:", music.streamAudioUrl)
        }
        
        // Mevcut GeneratedMusic modelini kullan
        mainViewModel.addGeneratedSongs([music])
        
        // Core Data'ya kaydet
        CoreDataManager.shared.saveSong(music)
    }
    
    func useCredit() {
        creditManager.updateCredits(-1)
    }
    
    func updateWithPrompt(_ template: MusicPromptTemplate) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Önce tab'i prompt'a çevir
            self.selectedTab = .prompt
            
            // Placeholder'ı güncelle
            self.placeholder = template.prompt
            
            self.musicPrompt.prompt = template.prompt
            
            self.musicPrompt.instrumental = template.isInstrumental
            
            self.deneme = 700
            
            // UI'ı zorla güncelle
            self.objectWillChange.send()
            
            print("🔄 Placeholder güncellendi:")
            print("Tab değiştirildi: \(self.selectedTab)")
            print("Yeni placeholder: \(self.placeholder ?? "nil")")
        }
    }
    
    func resetState() {
        // State'i başlangıç değerlerine sıfırla
        musicPrompt = MusicPrompt()
        selectedTab = .prompt
        placeholder = nil
        isLoading = false
        error = nil
        
        print("🔄 MusicGenerator state sıfırlandı")
    }
    
   
}
