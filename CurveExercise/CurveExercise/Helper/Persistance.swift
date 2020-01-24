//
//  Persistance.swift
//  CurveExercise
//

import Foundation
import CoreData

class Persistance {
    static let sharedInstance = Persistance()
    var movieFetched: Movie?
    
    var context: NSManagedObjectContext? = nil

    init() {
        movieFetched = nil
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurveExercise")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if context!.hasChanges {
            do {
                try context!.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK:- Saves all movies to coredata
    func saveToCoreData(moviesToStore: [CoreMovies]) {
        let entity = NSEntityDescription.entity(forEntityName: "MoviesStored", in: context!)
        for item in moviesToStore {
            let movie = NSManagedObject(entity: entity!, insertInto: context)
            movie.setValue(item.id, forKey: "id")
            movie.setValue(item.name, forKey: "name")
            movie.setValue(item.date, forKey: "date")
            movie.setValue("\(item.voteAvg)", forKey: "voteAvg")
            movie.setValue(item.isFav, forKey: "isFav")
            do {
                try context?.save()
            } catch {
                print("Failed to saved your message")
            }
        }
    }
    
    //MARK:- Fetches all movies from coredata
    func fetchMoviesFromCoreData() -> [CoreMovies]? {
        var movies: [CoreMovies] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesStored")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject] {
                let movieFetched = CoreMovies(id: data.value(forKey: "id") as! Int,
                                          voteAvg: Double(data.value(forKey: "voteAvg") as! String)!,
                                          name: data.value(forKey: "name") as! String,
                                          isFav: data.value(forKey: "isFav") as! Bool,
                                          date: data.value(forKey: "date") as! String)
                movies.append(movieFetched)
            }
        } catch {
           print("Failed")
        }
        return movies
    }
    
    //MARK:- Clears saved Movies From CoreData
    func clearAllMovies() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesStored")
            let deleteALL = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            try self.context?.execute(deleteALL)
            try self.context?.save()
        } catch {
            let errmsg = error as NSError
            print("Deleting movies, error = ", errmsg)
        }
    }
    
    //MARK:- Saves imageData to coredata
    func saveImage(imageData: NSData) {
        let entity = NSEntityDescription.entity(forEntityName: "Image", in: context!)
        let image = NSManagedObject(entity: entity!, insertInto: context)
        image.setValue(imageData, forKey: "imageData")
        do {
            try context?.save()
        } catch {
            print("Failed to save image")
        }
    }
    
    //MARK:- Fetches imageData from coredata
    func fetchImage() -> [NSData]? {
        var imageData: [NSData] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        do {
            let result = try context!.fetch(request)
            for data in result as! [NSManagedObject] {
                imageData.append((data.value(forKey: "imageData") as? NSData)!) 
            }
        } catch {
           print("Failed")
        }
        return imageData
    }
    
    //MARK:- Clears saved images From CoreData
    func clearAllImages() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
            let deleteALL = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            try self.context?.execute(deleteALL)
            try self.context?.save()
        } catch {
            let errmsg = error as NSError
            print("Deleting images, error = ", errmsg)
        }
    }
}
    
