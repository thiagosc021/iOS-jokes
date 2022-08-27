//
//  LocalJokeModelController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/25/22.
//

import Foundation
import CoreData

enum MappingError: Error {
    case ErrorMappingLocalJokeToJoke(String)
}

public class LocalJokeModelController {
    public static let shared = LocalJokeModelController()
    private init() {}
    private lazy var fetchRequest: NSFetchRequest<LocalJoke> = {
        let request = NSFetchRequest<LocalJoke>(entityName: "LocalJoke")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    public var jokesList: [Joke] = []
    
    public func saveJoke(_ joke: Joke) {
        LocalJoke(joke: joke)
        CoreDataStack.saveContext()
    }
    
    public func updateJoke(_ joke: Joke) {
        fetchRequest.predicate = NSPredicate(format: "id == %@", joke.id as CVarArg)
        do {
            guard let localJoke = try CoreDataStack.context.fetch(fetchRequest).first else { return }
            localJoke.isFavorite = joke.isFavorite
            localJoke.isBlocked = joke.isBlocked
            CoreDataStack.saveContext()
        } catch let error {
            debugPrint(error)
        }
    }
    
    public func fetch() {
        var jokeList: [Joke] = []
        do {
            let localJokeList = try CoreDataStack.context.fetch(fetchRequest)
            jokeList = try localJokeList.map({ try self.map($0) })
        } catch let error {
            debugPrint(error)
        }
        self.jokesList = jokeList
    }
    
    private func map(_ localJoke: LocalJoke) throws -> Joke {
        guard let jokeStyleString = localJoke.style,
            let jokeStyle = JokeStyle(rawValue: jokeStyleString ),
              let id = localJoke.id,
              let setup = localJoke.setup,
              let punchLine = localJoke.punchLine else {
            throw MappingError.ErrorMappingLocalJokeToJoke("\(localJoke)")
        }
        let isFavorite = localJoke.isFavorite
        let isBlocked = localJoke.isBlocked
        let joke = Joke(style: jokeStyle,
                        id: id,
                        setup: setup,
                        punchLine: punchLine,
                        isFavorite: isFavorite,
                        isBlocked: isBlocked)
        return joke
    }
}
