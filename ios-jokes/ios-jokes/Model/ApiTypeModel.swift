//
//  ApiTypeModel.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/24/22.
//

import Foundation

public enum APIType: String, CaseIterable {
    case Daddys
    case ChuckNorris
    
    var description: String {
        switch self {
        case .Daddys:
            return "Daddy's jokes API"
        case .ChuckNorris:
            return "Chuck Norris jokes API"
        }
    }
    
    var icon: String {
        switch self {
        case .Daddys:
            return "brain.head.profile"
        case .ChuckNorris:
            return "bolt.fill"
        }
    }
}
