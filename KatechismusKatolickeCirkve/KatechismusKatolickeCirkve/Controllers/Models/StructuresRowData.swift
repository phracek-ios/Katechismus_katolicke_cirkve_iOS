//
//  SectionsRowData.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 22.02.2021.
//  Copyright © 2021 Petr Hracek. All rights reserved.
//

import Foundation

struct SectionsRowData {
    var main_section: Bool
    var id: Int
    var name: String
    var exist_paragraph: Bool
    var sub_sections: String
}

struct IndexRowData {
    var refs = String()
    var name = NSAttributedString()
    var see = String()
}
