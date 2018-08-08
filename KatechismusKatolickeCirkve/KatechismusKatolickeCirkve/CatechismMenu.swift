//
//  CatechismMenu.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 07/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class CatechismMenu {
            
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var order: Int
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, order: Int){
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The type must not be negative
        guard (order >= 0) && (order <= 7) else {
            return nil
        }
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.order = order
        
    }
}
