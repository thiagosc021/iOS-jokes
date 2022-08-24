//
//  CategoryModel.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/24/22.
//

import Foundation

public enum Category: String, CaseIterable {
    case animal
    case career
    case celebrity
    case dev
    case fashion
    case food
    case history
    case money
    case movie
    case music
    case political
    case religion
    case science
    case sport
    case travel
    
    var description: String {
        return self.rawValue.capitalizingFirstLetter()
    }
    
    var icon: String {
        switch self {
        case .animal:
            return "pawprint.circle"
        case .career:
            return "building.2.crop.circle"
        case .celebrity:
            return "book.circle"
        case .dev:
            return "book.circle"
        case .fashion:
            return "tshirt"
        case .food:
            return "book.circle"
        case .history:
            return "book.circle"
        case .money:
            return "book.circle"
        case .movie:
            return "book.circle"
        case .music:
            return "headphones.circle"
        case .political:
            return "music.mic.circle"
        case .religion:
            return "book.circle"
        case .science:
            return "book.circle"
        case .sport:
            return "book.circle"
        case .travel:
            return "airplane.circle"     
        }
    }
}
