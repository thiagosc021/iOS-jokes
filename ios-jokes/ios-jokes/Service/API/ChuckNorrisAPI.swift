//
//  ChuckNorrisAPI.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/1/22.
//

import Foundation
import FileProvider

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

struct ChuckNorrisJoke: Decodable {
    var id: String
    var value: String
}

public class ChuckNorrisAPI: JokersAPI {
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.chucknorris.io"
        components.path = "/jokes/random"
        return components
    }
    
    private func URL(for jokeCategory: Category) -> URL {
        var components = urlComponents
        components.setQueryItems(with: ["category": "\(jokeCategory)"])
        return components.url!
    }
    
    public static let shared = ChuckNorrisAPI()
    public var selectedCategories: [Category] = Category.allCases
    
    public func loadJokes(completion: @escaping ((Joke?, DownloadError?) -> Void)) {
        guard let jokeCategory = selectedCategories.randomElement() else {
            completion(nil, DownloadError.error)
            return
        }
        executeGET(with: jokeCategory, completion: completion)
    }
}

private extension ChuckNorrisAPI {
    func executeGET(with jokeCategory: Category, completion: @escaping ((Joke?, DownloadError?) -> Void)) {
        let task = URLSession.shared.dataTask(with: URL(for: jokeCategory)) { data, response, error in
                guard let data = data,
                let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                            completion(nil, DownloadError.statusNotOk)
                            return
                }

                do {
                    #if TEST
                    print(String(data: data, encoding: .utf8)!)
                    #endif

                    let chuckNorrisJoke = try JSONDecoder().decode(ChuckNorrisJoke.self, from: data)
                    
                    let joke = Joke(style: .ChuckNorris, id: chuckNorrisJoke.id, setup: chuckNorrisJoke.value, punchLine: "", isFavorite: false, isBlocked: false)

                    completion(joke, nil)
                } catch let error {
                    debugPrint(error)
                    completion(nil, DownloadError.decoderError)
                }
        }
        task.resume()
    }
}

