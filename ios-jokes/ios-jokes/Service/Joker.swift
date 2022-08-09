//
//  Joker.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/2/22.
//

import Foundation

public class Joker {
    
    private var currentJoke = 0
    private var selectedCategory: Category?
    private var jokesIds: [String] = []
    public static let shared = Joker()
    public var jokesList: [Joke] = []    
    public let activeAPIList: [JokersAPI] = [ChuckNorrisAPI.shared] //, DaddysAPI.shared
    
    public func preFetchJokesIfNeeded(currentIndex: Int) {
        if currentIndex >= (jokesList.count - 3) {
            fetchJokes(max: 10)
            debugPrint("prefetching jokes \(currentIndex), \(jokesList.count)")
        }
    }

    public func fetchJokes(max: Int) {
        var numberOfCalls = max
        guard let api = activeAPIList.randomElement() else {
            debugPrint("No API available")
            return
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
                    if let error = error {
                        debugPrint(error.description())
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

