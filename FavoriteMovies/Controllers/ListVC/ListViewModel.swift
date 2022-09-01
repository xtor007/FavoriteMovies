//
//  ListViewModel.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 31.08.2022.
//

import Foundation
import RxSwift

class ListViewModel {
    
    let disposeBag = DisposeBag()
    let coreDataManager: PersistenceManager = CoreDataManager()
    
    var data = [Movie]()
    
    func addMovie(title: String, yearString: String, onSucces: @escaping ()->(Void), onError: @escaping (String)->(Void)) {
        if title.isEmpty || yearString.isEmpty {
            onError("Fields cannot be empty")
            return
        }
        guard let year = Int(yearString) else {
            onError("The year must contain only digits")
            return
        }
        //year validation
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentYear = calendar.component(.year, from: date as Date)
        if year>currentYear || year<0 {
            onError("Incorrect year")
            return
        }
        //check header for uniqueness
        if data.contains(where: { movie in
            return movie.title! == title
        }) {
            onError("The title cannot have duplicates")
            return
        }
        coreDataManager.addMovie(title: title, year: year) {
            self.getAllMovies(onError: onError)
            onSucces()
        } onError: { message in
            onError(message)
        }
    }
    
    func getAllMovies(onError: @escaping (String)->(Void)) {
        coreDataManager.getAllMovies { movies in
            self.data = movies
            print(movies.count)
        } onError: { message in
            onError(message)
        }
    }
    
}
