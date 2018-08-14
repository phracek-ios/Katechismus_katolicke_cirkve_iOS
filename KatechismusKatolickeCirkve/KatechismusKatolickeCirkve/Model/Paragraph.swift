//
//  Paragraph.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 14/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//


import Foundation

struct Paragraph: Decodable {
    var chapter: Int
    var caption: String
    var refs: String
    var id: Int
    var text: String
}
