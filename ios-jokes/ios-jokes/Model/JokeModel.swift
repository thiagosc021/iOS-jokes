//
//  JokeModel.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/1/22.
//

import Foundation


public enum JokeStyle {
    case ChuckNorris
    case Daddys
    
    var API_URL: String {
        switch self {
        case .ChuckNorris:
            return ""
        case .Daddys:
            return ""
        }
    }
}

public struct Joke: Hashable {
    var style: JokeStyle
    var id: String
    var setup: String
    var punchLine: String
    var isFavorite: Bool
    var isBlocked: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

