//
//  Chapter.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation

struct Chapter: Decodable {
    var id: Int
    var parent: Int
    var name: String
    var exist_paragraph: Bool
    var sub_sections: String
}
