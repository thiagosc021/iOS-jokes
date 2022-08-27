//
//  Joker.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/2/22.
//

import Foundation
import BackgroundTasks

public enum JokeListFilterType {
    case favorited
    case blocked
    case all
}

public class Joker {
    private var jokesIds: [String] = []
    private var allJokes: [Joke] = []
    private var activeFilter: JokeListFilterType = .all
    private var apiTypeModelController = ApiTypeModelController.shared
    private var localJokeModelController = LocalJokeModelController.shared
    public static let shared = Joker()
    public var jokesList: [Joke] = []    
   
    
    public func favorite(_ joke: Joke, isFavorite: Bool) {
        guard let index = jokesList.firstIndex(of: joke) else {
            return
        }
        var joke = allJokes[index]
        joke.isFavorite = isFavorite
        localJokeModelController.updateJoke(joke)
        allJokes[index].isFavorite = isFavorite
    }
    
    public func block(_ joke: Joke, isBlocked: Bool) {
        guard let index = jokesList.firstIndex(of: joke) else {
            return
        }
        var joke = allJokes[index]
        joke.isBlocked = isBlocked
        localJokeModelController.updateJoke(joke)
        allJokes[index].isBlocked = isBlocked
    }
    
    public func preFetchJokesIfNeeded(currentIndex: Int) {
        if currentIndex >= (jokesList.count - 1) && activeFilter == .all {            
            fetchJokes(max: 10)
            debugPrint("prefetching jokes \(currentIndex), \(jokesList.count)")            
        }
    }
    
    public func applyFilter(_ filterType: JokeListFilterType) {
        activeFilter = filterType
        switch filterType {
        case .favorited:
            let filteredJokes = allJokes.filter( { $0.isFavorite })
            jokesList.removeAll()
            jokesList.append(contentsOf: filteredJokes)
        case .blocked:
            let filteredJokes = allJokes.filter( { $0.isBlocked })
            jokesList.removeAll()
            jokesList.append(contentsOf: filteredJokes)
        case .all:
            jokesList = allJokes
        }
    }
    
    func fetchLocal() -> Bool {
        localJokeModelController.fetch()
        localJokeModelController.jokesList.forEach { joke in
            if !self.jokesIds.contains(where: { $0 == joke.id }) {
                self.jokesIds.append(joke.id)
                self.jokesList.append(joke)
                self.allJokes.append(joke)
            }
        }
        return self.jokesList.count > 0
    }
    
    public func fetchJokes(max: Int) {
        var numberOfCalls = max
        
        if max > 30 {
            numberOfCalls = 30
        }
               
        guard let apiType = apiTypeModelController.activeAPIList.randomElement() else {
            debugPrint("No API available")
            return
        }
        var api: JokersAPI
        
        switch apiType {
        case .Daddys:
            api = DaddysAPI.shared
        case .ChuckNorris:
            api = ChuckNorrisAPI.shared
        }
              
        fetchRemote(numberOfCalls, api)
    }
}

private extension Joker {
    
    
    func fetchRemote(_ numberOfCalls: Int, _ api: JokersAPI) {
        for _ in 1...numberOfCalls {
            api.loadJokes { [weak self]
                joke, error in
                guard let self = self else {
                    return
                }
                
                guard let joke = joke else {
                    switch error {
                    case .apiThrottling(_):
                        self.apiTypeModelController.removeApi(.Daddys)
                    default:
                        print(error?.description ?? DownloadError.error.description)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    if !self.jokesIds.contains(where: { $0 == joke.id }) {
                        self.jokesIds.append(joke.id)
                        self.jokesList.append(joke)
                        self.allJokes.append(joke)
                        self.localJokeModelController.saveJoke(joke)
                        NotificationCenter.default.post(name: .jokeDidAdd, object: self, userInfo: nil)
                    }
                }
            }
        }
    }
}
