//
//  IndexDataService.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 05/03/2019.
//  Copyright © 2019 Petr Hracek. All rights reserved.
//

import Foundation


class IndexDataService {
    
    // MARK: - Shared
    static var shared = IndexDataService()
    
    // MARK: - Properties
    var indexStructure: IndexStructure?
    
    // MARK: -
    func loadData() {
        parseJSON()
    }
    
    private func parseJSON() {
        if let path = Bundle.main.path(forResource: "index", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                indexStructure = try JSONDecoder().decode(IndexStructure.self, from: data)
                //print(indexStructure.debugDescription)
            } catch {
                print(error)
            }
        } else {
            print("File not found")
        }
    }
    
}
