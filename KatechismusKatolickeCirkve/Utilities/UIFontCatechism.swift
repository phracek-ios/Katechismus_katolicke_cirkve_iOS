//
//  UIFontCatechism.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 17/10/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

extension UIFont {
    
    struct Catechishm {
        
        static func regularFontOfSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Ubuntu", size: size)!
        }
        
        static func regularItalicFontOfSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Ubuntu-Italic", size: size)!
        }
        
        static func regularBoldFontOfSize(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Ubuntu-Bold", size: size)!
        }
        
    }
}
