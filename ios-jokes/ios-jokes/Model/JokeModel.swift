//
//  JokeModel.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/1/22.
//

import Foundation
import CoreData

public enum JokeStyle: String {
    case ChuckNorris
    case Daddys
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

extension LocalJoke {
    @discardableResult convenience init(joke: Joke, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.id = joke.id
        self.style = joke.style.rawValue
        self.setup = joke.setup
        self.punchLine = joke.punchLine
        self.isBlocked = joke.isBlocked
        self.isFavorite = joke.isFavorite
    }
  
}
