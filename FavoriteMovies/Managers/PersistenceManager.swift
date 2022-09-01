//
//  PersistenceManager.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 01.09.2022.
//

import Foundation

protocol PersistenceManager {
    func addMovie(title: String, year: Int, onSucces: @escaping ()->(Void), onError: @escaping (String)->(Void))
    func getAllMovies(onSucces: @escaping ([Movie])->(Void), onError: @escaping (String)->(Void))
}
