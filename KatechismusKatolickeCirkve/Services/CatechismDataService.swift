//
//  CatechismDataService.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//


import Foundation

class CatechismDataService {
    
    // MARK: - Shared
    static var shared = CatechismDataService()
    
    // MARK: - Properties
    var catechismStructure: CatechismStructure?
    
    // MARK: -
    func loadData() {
        parseJSON()
    }
    
    private func parseJSON() {
        if let path = Bundle.main.path(forResource: "catechism", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                catechismStructure = try JSONDecoder().decode(CatechismStructure.self, from: data)
                //print(catechismStructure.debugDescription)
            } catch {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
}
