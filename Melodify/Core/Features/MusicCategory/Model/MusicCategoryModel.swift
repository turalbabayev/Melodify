import SwiftUI

struct MusicCategory: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let style: String
    let type: String
    let prompts: [MusicPromptTemplate]
    
    // Hashable için
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable için
    static func == (lhs: MusicCategory, rhs: MusicCategory) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MusicPromptTemplate: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let style: String
    let prompt: String
    let lyrics: String?
    let isInstrumental: Bool
    let description: String
    let language: String  // "tr" veya "en"
    
    // Equatable için
    static func == (lhs: MusicPromptTemplate, rhs: MusicPromptTemplate) -> Bool {
        return lhs.id == rhs.id
    }
}

// Örnek kategoriler ve promptlar
extension MusicCategory {
    static let categories: [MusicCategory] = [
        .init(
            name: "Pop Music",
            description: "Create catchy and modern pop songs with infectious melodies and contemporary beats.",
            imageName: "template1",
            style: "Modern",
            type: "Pop",
            prompts: [
                .init(
                    title: "Modern Pop Hit",
                    style: "Contemporary pop with catchy hooks",
                    prompt: "Create a modern pop song with catchy hooks, upbeat rhythm, and contemporary production. Include meaningful lyrics about love and happiness.",
                    lyrics: nil,
                    isInstrumental: false,
                    description: "Perfect for radio play",
                    language: "en"
                ),
                .init(
                    title: "Türkçe Pop",
                    style: "Modern Türk pop müziği",
                    prompt: "Aşk ve özlem temalı sözleri olan, modern altyapılı, romantik bir Türk pop şarkısı üret",
                    lyrics: nil,
                    isInstrumental: false,
                    description: "Radyo için ideal",
                    language: "tr"
                ),
                .init(
                    title: "Summer Pop",
                    style: "Tropical house pop fusion",
                    prompt: "Generate a summer pop song with tropical house elements, uplifting melodies and beach vibes. Include lyrics about summer love and good times.",
                    lyrics: nil,
                    isInstrumental: false,
                    description: "Perfect for summer playlists",
                    language: "en"
                ),
                .init(
                    title: "Slow Türkçe",
                    style: "Duygusal Türk pop",
                    prompt: "Piyano ağırlıklı, duygusal ve romantik bir Türkçe slow şarkı üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Romantik anlar için",
                    language: "tr"
                ),
                .init(
                    title: "Dance Pop",
                    style: "Club-ready pop music",
                    prompt: "Create an energetic dance pop track with powerful beats and catchy vocal hooks",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Made for the dancefloor",
                    language: "en"
                ),
                .init(
                    title: "Türk Pop Rock",
                    style: "Rock elementli Türk pop",
                    prompt: "Elektro gitar ve orkestra elementleri içeren, dinamik bir Türk pop şarkısı üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Enerjik ve güçlü",
                    language: "tr"
                )
            ]
        ),
        .init(
            name: "Rock Music",
            description: "Generate powerful rock music with electric guitars and energetic rhythms.",
            imageName: "template2",
            style: "Classic",
            type: "Rock",
            prompts: [
                .init(
                    title: "Classic Rock",
                    style: "70s rock style",
                    prompt: "Generate a classic rock song with powerful guitar riffs, energetic drums, and meaningful lyrics about freedom and rebellion",
                    lyrics: nil,
                    isInstrumental: false,
                    description: "Vintage rock sound",
                    language: "en"
                ),
                .init(
                    title: "Anadolu Rock",
                    style: "Türk rock müziği",
                    prompt: "Anadolu rock tarzında, bağlama ve elektro gitar harmonisi içeren, toplumsal mesajlar içeren sözleri olan bir şarkı üret",
                    lyrics: nil,
                    isInstrumental: false,
                    description: "Geleneksel ve modern fusion",
                    language: "tr"
                ),
                .init(
                    title: "Metal Rock",
                    style: "Heavy metal fusion",
                    prompt: "Create a heavy metal track with aggressive guitars, double bass drums and epic solos",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Heavy and powerful",
                    language: "en"
                ),
                .init(
                    title: "Türk Hard Rock",
                    style: "Sert Türk rock",
                    prompt: "Distortion gitar ağırlıklı, güçlü davul ritimleri olan sert bir Türk rock parçası üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Güçlü ve dinamik",
                    language: "tr"
                ),
                .init(
                    title: "Alternative Rock",
                    style: "Modern alternative",
                    prompt: "Generate an alternative rock song with indie elements and atmospheric sounds",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Modern indie vibes",
                    language: "en"
                ),
                .init(
                    title: "Psychedelic Türk Rock",
                    style: "Psikedelik Türk rock",
                    prompt: "Doğu melodileri ve psikedelik efektler içeren deneysel bir Türk rock parçası üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Deneysel ve mistik",
                    language: "tr"
                )
            ]
        ),
        .init(
            name: "Hip Hop",
            description: "Urban beats and rhythms with powerful bass and modern production.",
            imageName: "template3",
            style: "Urban",
            type: "Hip Hop",
            prompts: [
                .init(
                    title: "Trap Beat",
                    style: "Modern trap production",
                    prompt: "Create a modern trap beat with heavy 808s and atmospheric melodies",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Modern trap sound",
                    language: "en"
                ),
                .init(
                    title: "Türkçe Rap",
                    style: "Türkçe rap beat",
                    prompt: "Türkçe rap için uygun, güçlü bass ve melodik altyapı içeren bir beat üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Rap için ideal",
                    language: "tr"
                ),
                .init(
                    title: "Boom Bap",
                    style: "Old school hip hop",
                    prompt: "Create an old school boom bap beat with vinyl samples and classic drum patterns",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Classic hip hop vibes",
                    language: "en"
                ),
                .init(
                    title: "Melodic Türkçe Trap",
                    style: "Melodik Türk trap",
                    prompt: "Melodik ve atmosferik elementler içeren, modern bir Türkçe trap beat üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Modern ve melodik",
                    language: "tr"
                ),
                .init(
                    title: "Lo-Fi Hip Hop",
                    style: "Chill lo-fi beats",
                    prompt: "Generate a relaxing lo-fi hip hop beat with jazzy samples and smooth drums",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Relaxing study beats",
                    language: "en"
                ),
                .init(
                    title: "Arabesk Rap",
                    style: "Arabesk rap fusion",
                    prompt: "Arabesk elementler içeren, duygusal bir Türkçe rap beat üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Duygusal ve güçlü",
                    language: "tr"
                )
            ]
        ),
        .init(
            name: "Electronic",
            description: "Create electronic music with modern synthesizers and dance rhythms.",
            imageName: "template4",
            style: "Electronic",
            type: "EDM",
            prompts: [
                .init(
                    title: "House Music",
                    style: "Deep house vibes",
                    prompt: "Generate a deep house track with groovy basslines and atmospheric pads",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Club ready",
                    language: "en"
                ),
                .init(
                    title: "Elektronik Türk",
                    style: "Elektronik Türk müziği",
                    prompt: "Geleneksel Türk müziği elementleri içeren modern bir elektronik parça üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Doğu-Batı füzyonu",
                    language: "tr"
                ),
                .init(
                    title: "Techno",
                    style: "Dark techno",
                    prompt: "Create a dark techno track with hypnotic rhythms and industrial sounds",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Underground techno",
                    language: "en"
                ),
                .init(
                    title: "Oriental House",
                    style: "Oryantal elektronik",
                    prompt: "Oryantal ritimler ve modern elektronik altyapı içeren dans müziği üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Doğu ritimleri",
                    language: "tr"
                ),
                .init(
                    title: "Ambient",
                    style: "Atmospheric electronic",
                    prompt: "Generate an ambient electronic track with ethereal textures and subtle rhythms",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Atmospheric journey",
                    language: "en"
                ),
                .init(
                    title: "Modern Tasavvuf",
                    style: "Modern sufi electronic",
                    prompt: "Tasavvuf müziği elementleri içeren modern bir elektronik ambient parça üret",
                    lyrics: nil,
                    isInstrumental: true,
                    description: "Mistik ve modern",
                    language: "tr"
                )
            ]
        )
    ]
} 
