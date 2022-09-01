//
//  PersistenceManager.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 01.09.2022.
//

import Foundation

protocol PersistenceManager {
    func addMovie(title: String, year: Int, onSuccess: @escaping ()->(Void), onError: @escaping (String)->(Void))
    func getAllMovies(onSuccess: @escaping ([Movie])->(Void), onError: @escaping (String)->(Void))
    func deleteMovie(_ movie: Movie, onSuccess: @escaping ()->(Void), onError: @escaping (String)->(Void))
}
