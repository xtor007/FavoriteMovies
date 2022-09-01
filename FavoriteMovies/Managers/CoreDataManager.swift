//
//  CoreDataManager.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 01.09.2022.
//

import UIKit
import CoreData

class CoreDataManager: PersistenceManager {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    func addMovie(title: String, year: Int, onSuccess: @escaping ()->(Void), onError: @escaping (String) -> (Void)) {
        getContext(onError: onError) { context in
            let movie = Movie(context: context)
            movie.title = title
            movie.year = Int16(year)
            movie.date = Date(timeIntervalSinceNow: 0) //current date
            do {
                try context.save()
                onSuccess()
            } catch {
                onError(error.localizedDescription)
            }
        }
    }
    
    func getAllMovies(onSuccess: @escaping ([Movie])->(Void), onError: @escaping (String) -> (Void)) {
        getContext(onError: onError) { context in
            var movies = [Movie]()
            let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
            do {
                try movies = context.fetch(fetchRequest)
                onSuccess(movies)
            } catch {
                onError(error.localizedDescription)
            }
        }
    }
    
    func deleteMovie(_ movie: Movie, onSuccess: @escaping () -> (Void), onError: @escaping (String) -> (Void)) {
        getContext(onError: onError) { context in
            context.delete(movie)
            do {
                try context.save()
                onSuccess()
            } catch {
                onError(error.localizedDescription)
            }
        }
    }
    
    private func getContext(onError: @escaping (String) -> (Void), onSuccess: @escaping (NSManagedObjectContext) -> (Void)) {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            onError("Connot load context")
            return
        }
        onSuccess(context)
    }
    
}
