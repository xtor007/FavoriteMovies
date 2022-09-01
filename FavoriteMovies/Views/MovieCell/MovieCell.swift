//
//  MovieCell.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 01.09.2022.
//

import UIKit

class MovieCell: UITableViewCell {

    static let cellId = "movieCellId"
    static let nibName = "MovieCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    func initData(movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = String(movie.year)
    }
    
}
