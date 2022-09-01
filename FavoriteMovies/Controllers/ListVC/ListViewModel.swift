//
//  ListViewModel.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 31.08.2022.
//

import Foundation

class ListViewModel {
    
    let coreDataManager: PersistenceManager = CoreDataManager()
    
    var data = [Movie]()
    var currentSortingCase = SortingCase.byTitle {
        didSet {
            sorted(by: currentSortingCase)
        }
    }
    
    func addMovie(title: String, yearString: String, onSuccess: @escaping ()->(Void), onError: @escaping (String)->(Void)) {
        
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
        
        //check title for uniqueness
        if data.contains(where: { movie in
            return movie.title! == title
        }) {
            onError("The title cannot have duplicates")
            return
        }
        
        coreDataManager.addMovie(title: title, year: year) {
            self.getAllMovies(onError: onError)
            onSuccess()
        } onError: { message in
            onError(message)
        }
        
    }
    
    func getAllMovies(onError: @escaping (String)->(Void)) {
        coreDataManager.getAllMovies { movies in
            self.data = movies
            self.sorted(by: self.currentSortingCase)
        } onError: { message in
            onError(message)
        }
    }
    
    func deleteMovie(movieIndex: Int, onError: @escaping (String)->(Void)) {
        coreDataManager.deleteMovie(data[movieIndex]) {
            self.getAllMovies(onError: onError)
        } onError: { message in
            onError(message)
        }
    }
    
    func sorted(by sortingCase: SortingCase) {
        data = data.sorted(by: sortingCase.sortingClosure())
    }
    
}
