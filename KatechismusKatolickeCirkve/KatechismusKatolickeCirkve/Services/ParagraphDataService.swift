//
//  ParagraphDataService.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 14/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation


class ParagraphDataService {
    
    // MARK: - Shared
    static var shared = ParagraphDataService()
    
    // MARK: - Properties
    var paragraphStructure: ParagraphStructure?
    
    // MARK: -
    func loadData() {
        parseJSON()
    }
    
    private func parseJSON() {
        if let path = Bundle.main.path(forResource: "database", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                paragraphStructure = try JSONDecoder().decode(ParagraphStructure.self, from: data)
                print(paragraphStructure.debugDescription)
            } catch {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
}
