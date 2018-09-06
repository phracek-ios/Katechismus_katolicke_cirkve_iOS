//
//  ChaptersDataService.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 08/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation


class ChaptersDataService {
    
    // MARK: - Shared
    static var shared = ChaptersDataService()
    
    // MARK: - Properties
    var chaptersStructure: ChaptersStructure?
    
    // MARK: -
    func loadData() {
        parseJSON()
    }
    
    private func parseJSON() {
        if let path = Bundle.main.path(forResource: "part", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                chaptersStructure = try JSONDecoder().decode(ChaptersStructure.self, from: data)
                //print(chaptersStructure.debugDescription)
            } catch {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
}
