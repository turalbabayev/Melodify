//
//  MusicGeneratorViewModel.swift
//  Melodify
//
//  Created by Tural Babayev on 5.03.2025.
//

import SwiftUI

class MusicGeneratorViewModel: ObservableObject {
    @Published var musicPrompt = MusicPrompt()
    @Published var selectedTab: Tab = .prompt
    @Published var isLoading = false
    @Published var error: String?
    @Published var generatedMusic: [GeneratedMusic] = []
    
    enum Tab {
        case prompt, compose
    }
    
    private let service = MusicGenerationService.shared
    private let mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
    }
    
    // Compose View için müzik üretme
    func generateMusicFromCompose() {
        print("🎵 Generating music from Compose View")
        print("📝 Lyrics: \(musicPrompt.lyrics)")
        print("🎨 Style: \(musicPrompt.style)")
        print("📌 Title: \(musicPrompt.title)")
        print("🎼 Instrumental: \(musicPrompt.instrumental)")
        
        guard validateComposeInput() else {
            print("❌ Validation failed for Compose View")
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
        print("🎵 Generating music from Prompt View")
        print("📝 Prompt: \(musicPrompt.prompt)")
        print("🎼 Instrumental: \(musicPrompt.instrumental)")
        
        guard validatePromptInput() else {
            print("❌ Validation failed for Prompt View")
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
        
        // 2 tane "generating" durumunda şarkı oluştur
        let generatingSongs = [
            GeneratedMusic(
                id: UUID().uuidString,
                title: "Creating your first song...",
                prompt: prompt,
                status: .PENDING
            ),
            GeneratedMusic(
                id: UUID().uuidString,
                title: "Preparing your second song...",
                prompt: prompt,
                status: .PENDING
            )
        ]
        
        // MainViewModel'e ekle ve Library'ye yönlendir
        mainViewModel.addGeneratedSongs(generatingSongs)
        mainViewModel.selectedTab = .library
        
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
                
                try await pollTaskStatus(taskId: taskId)
                
            } catch {
                print("❌ API Request Failed")
                print("💥 Error: \(error.localizedDescription)")
                
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
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
}
