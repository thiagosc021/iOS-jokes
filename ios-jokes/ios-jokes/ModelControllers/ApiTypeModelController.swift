//
//  ApiTypeModelController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/24/22.
//

import Foundation

class ApiTypeModelController {
    public static let shared = ApiTypeModelController()
    public var activeAPIList: [APIType] = []
    
    private init() {
        let defaults = UserDefaults.standard
        if let selectedApiTypes = defaults.array(forKey: "selectedApiTypes") as? [String] {
            self.activeAPIList = selectedApiTypes.map({ APIType(rawValue: $0)! })
        } else {
            self.activeAPIList = APIType.allCases
        }
    }
    
    public func selectApi(_ api: APIType) {
        self.activeAPIList.append(api)
        let defaults = UserDefaults.standard
        let activeApis = self.activeAPIList.map({ $0.rawValue})
        defaults.set(activeApis, forKey: "selectedApiTypes")
    }
    
    public func removeApi(_ api: APIType) {
        self.activeAPIList.removeAll(where: { $0 == api })
        let defaults = UserDefaults.standard
        let activeApis = self.activeAPIList.map({ $0.rawValue})
        defaults.set(activeApis, forKey: "selectedApiTypes")
    }
    
    public func isSelected(_ api: APIType) -> Bool {
        return self.activeAPIList.contains(where: { $0 == api})
    }
}
