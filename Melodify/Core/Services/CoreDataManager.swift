import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer
    private let containerName = "SongEntity"
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveSong(_ generatedMusic: GeneratedMusic) {
        let entity = SongEntity(context: context)
        entity.id = generatedMusic.id
        entity.title = generatedMusic.title
        entity.streamUrl = generatedMusic.audioUrl
        entity.imageUrl = generatedMusic.imageUrl
        entity.duration = generatedMusic.duration ?? 0
        entity.isFavorite = false
        entity.createdAt = Date()
        
        saveContext()
    }
    
    func loadSongs() -> [Song] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SongEntity")
        
        do {
            let results = try context.fetch(fetchRequest)
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
            let results = try context.fetch(fetchRequest)
            if let song = results.first {
                song.setValue(isFavorite, forKey: "isFavorite")
                try context.save()
            }
        } catch {
            print("Failed to update song favorite status: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
            print("Song saved successfully")
        } catch {
            print("Failed to save song: \(error)")
        }
    }
} 
