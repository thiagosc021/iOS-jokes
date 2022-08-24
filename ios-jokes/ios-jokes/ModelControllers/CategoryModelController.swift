//
//  CategoryModelController.swift
//  ios-jokes
//
//  Created by Thiago Costa on 8/24/22.
//

import Foundation

class CategoryModelController {
    public static let shared = CategoryModelController()
    public var selectedCategories: [Category] = []
    
    private init() {
        let defaults = UserDefaults.standard
        if let selectedCategories = defaults.array(forKey: "selectedCategories") as? [String] {
            self.selectedCategories = selectedCategories.map({ Category(rawValue: $0)! })
        } else {
            self.selectedCategories = Category.allCases
        }
    }
    
    public func selectCategory(_ category: Category) {
        self.selectedCategories.append(category)
        let defaults = UserDefaults.standard
        let categories = self.selectedCategories.map({ $0.rawValue})
        defaults.set(categories, forKey: "selectedCategories")
    }
    
    public func removeCategory(_ category: Category) {
        self.selectedCategories.removeAll(where: { $0 == category })
        let defaults = UserDefaults.standard
        let categories = self.selectedCategories.map({ $0.rawValue})
        defaults.set(categories, forKey: "selectedCategories")
    }
    
    public func isSelected(_ category: Category) -> Bool {
        return self.selectedCategories.contains(where: { $0 == category})
    }
}
