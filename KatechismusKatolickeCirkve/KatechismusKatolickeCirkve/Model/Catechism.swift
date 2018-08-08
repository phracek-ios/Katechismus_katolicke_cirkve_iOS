//
//  Catechism.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation

struct Catechism: Decodable {
    var id: Int
    var name: String
    var decades: [String]
}
