//
//  Joker.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/2/22.
//

import Foundation
import BackgroundTasks
public class Joker {
    private var currentJoke = 0
    private var selectedCategory: Category?
    private var jokesIds: [String] = []
    public static let shared = Joker()
    public var jokesList: [Joke] = []    
    public var activeAPIList: [APIType] = [.ChuckNorris,.Daddys]
    
    public func favorite(_ joke: Joke, isFavorite: Bool) {
        guard let index = jokesList.firstIndex(of: joke) else {
            return
        }
        jokesList[index].isFavorite = isFavorite
    }
    
    public func block(_ joke: Joke, isBlocked: Bool) {
        guard let index = jokesList.firstIndex(of: joke) else {
            return
        }
        jokesList[index].isBlocked = isBlocked
    }
    
    public func preFetchJokesIfNeeded(currentIndex: Int) {
        if currentIndex >= (jokesList.count - 3) {
            fetchJokes(max: 10)
            debugPrint("prefetching jokes \(currentIndex), \(jokesList.count)")
        }
    }

    public func fetchJokes(max: Int) {
        var numberOfCalls = max
        guard let apiType = activeAPIList.randomElement() else {
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
        
        if max > 30 {
            numberOfCalls = 30
        }
        
        for _ in 1...numberOfCalls {
            api.loadJokes { [weak self]
                joke, error in
                guard let self = self else {
                    return
                }
                
                guard let joke = joke else {
                    switch error {
                    case .apiThrottling(_):
                        self.activeAPIList.removeAll(where: { $0 == .Daddys })
                    default:
                        print(error?.description ?? DownloadError.error.description)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    if !self.jokesIds.contains(where: { $0 == joke.id }) {
                        self.jokesIds.append(joke.id)
                        self.jokesList.append(joke)
                        NotificationCenter.default.post(name: .jokeDidAdd, object: self, userInfo: nil)
                    }
                }
            }
        }
        
    }
    
   
    
}

