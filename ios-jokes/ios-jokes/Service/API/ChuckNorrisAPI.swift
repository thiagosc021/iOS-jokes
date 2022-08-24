//
//  ChuckNorrisAPI.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/1/22.
//

import Foundation
import FileProvider

struct ChuckNorrisJoke: Decodable {
    var id: String
    var value: String
}

public class ChuckNorrisAPI: JokersAPI {
    private let categoryModelController = CategoryModelController.shared
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
    
    public func loadJokes(completion: @escaping ((Joke?, DownloadError?) -> Void)) {
        guard let jokeCategory = categoryModelController.selectedCategories.randomElement() else {
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

