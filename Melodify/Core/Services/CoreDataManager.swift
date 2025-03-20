import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let songContainer: NSPersistentContainer
    
    let songContext: NSManagedObjectContext
    
    private init() {
        // Song Container
        songContainer = NSPersistentContainer(name: "SongEntity")
        songContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Song Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        songContext = songContainer.viewContext
    }
    
    func saveSong(_ generatedMusic: GeneratedMusic) {
        let entity = SongEntity(context: songContext)
        entity.id = generatedMusic.id
        entity.title = generatedMusic.title
        entity.streamUrl = generatedMusic.audioUrl
        entity.imageUrl = generatedMusic.imageUrl
        entity.duration = generatedMusic.duration ?? 0
        entity.isFavorite = false
        entity.createdAt = Date()
        
        saveContext(songContext)
    }
    
    func loadSongs() -> [Song] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
        
        do {
            let results = try songContext.fetch(fetchRequest)
            return results.compactMap { entity -> Song? in
                guard let id = entity.value(forKey: "id") as? String,
                      let title = entity.value(forKey: "title") as? String,
                      let duration = entity.value(forKey: "duration") as? Double,
                      let streamUrl = entity.value(forKey: "streamUrl") as? String,
                      let imageUrl = entity.value(forKey: "imageUrl") as? String,
                      let isFavorite = entity.value(forKey: "isFavorite") as? Bool else {
                    return nil
                }
                
                return Song(
                    id: id,
                    title: title,
                    duration: duration,
                    url: URL(string: streamUrl),
                    imageUrl: URL(string: imageUrl),
                    isFavorite: isFavorite,
                    lyrics: [],
                    isGenerating: false,
                    generationStatus: nil
                )
            }
        } catch {
            print("Failed to fetch songs: \(error)")
            return []
        }
    }
    
    func updateSongFavorite(id: String, isFavorite: Bool) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try songContext.fetch(fetchRequest)
            if let song = results.first {
                song.setValue(isFavorite, forKey: "isFavorite")
                try songContext.save()
            }
        } catch {
            print("Failed to update song favorite status: \(error)")
        }
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func clearAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SongEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try songContainer.persistentStoreCoordinator.execute(deleteRequest, with: songContext)
            try songContext.save()
            print("✅ Tüm şarkılar başarıyla silindi")
        } catch {
            print("❌ Veri silme hatası:", error)
        }
    }
} 
