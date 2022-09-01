//
//  SortingCase.swift
//  FavoriteMovies
//
//  Created by Anatoliy Khramchenko on 01.09.2022.
//

import UIKit

enum SortingCase: String {
    
    static let allCases = [SortingCase.byTitle,.byInvertedTitle,.byYear,.byInvertedYear,.byDate,.byInvertedDate]
    
    case byTitle = "Alphabetly",
         byInvertedTitle = "Reverse alphabetly",
         byYear = "By year",
         byInvertedYear = "By year reverse",
         byDate = "By date added",
         byInvertedDate = "By date added reverse"
    
    func sortingClosure() -> ((Movie,Movie)->(Bool)) {
        switch self {
        case .byTitle:
            return { movie1, movie2 in
                return movie1.title!<movie2.title!
            }
        case .byInvertedTitle:
            return { movie1, movie2 in
                return movie1.title!>movie2.title!
            }
        case .byYear:
            return { movie1, movie2 in
                return movie1.year>movie2.year
            }
        case .byInvertedYear:
            return { movie1, movie2 in
                return movie1.year<movie2.year
            }
        case .byDate:
            return { movie1, movie2 in
                return movie1.date!>movie2.date!
            }
        case .byInvertedDate:
            return { movie1, movie2 in
                return movie1.date!<movie2.date!
            }
        }
    }
    
    func getAction(handler: @escaping UIActionHandler) -> UIAction {
        var state = UIMenuElement.State.off
        if self == .byTitle {
            state = .on
        }
        return UIAction(title: self.rawValue, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: state, handler: handler)
    }
    
}
