//
//  GeneratorText.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr "Stone" Hracek on 06.11.18.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import BonMot

func generateContent(text: String, font_name: String = "Helvetica", size: CGFloat = 16) -> NSAttributedString {
    
    let baseStyle = StringStyle(
        .font(UIFont(name: font_name, size: size)!),
        .lineHeightMultiple(1)
    )
    let strong = baseStyle.byAdding(
        .font(UIFont(name: font_name, size: size)!.bold())
    )
    let emphasized = baseStyle.byAdding(
        .font(UIFont(name: font_name, size: size)!.italic())
    )
    let small = baseStyle.byAdding(
        .font(UIFont(name: font_name, size: size-4)!)
    )
    let paragraph = baseStyle.byAdding(
        .paragraphSpacingBefore(20)
    )
    
    let redStyle = StringStyle(
        .color(.red)
    )
    
    let rules: [XMLStyleRule] = [
        .style("em", emphasized),
        .style("b", strong),
        .style("small", small),
        .style("p", paragraph),
        .style("br", paragraph),
        .style("red", redStyle)
    ]
    
    let content = baseStyle.byAdding(
        .color(UIColor.darkGray),
        .xmlRules(rules)
    )
    var generated_text = text
    generated_text = generated_text.replacingOccurrences(of: "<p>\n", with: "<p>")
    generated_text = generated_text.replacingOccurrences(of: "<smaal>", with: "<small>")
    generated_text = generated_text.replacingOccurrences(of: "\n</p>", with: "</p>")
    generated_text = generated_text.replacingOccurrences(of: "[\\t\\n\\r][\\t\\n\\r]+", with: "\n", options: .regularExpression)
    generated_text = generated_text.replacingOccurrences(of: "<p>", with: "")
    generated_text = generated_text.replacingOccurrences(of: "</p>", with: "\n\n")
    generated_text = generated_text.replacingOccurrences(of: "<br>", with: "\n")
    generated_text = generated_text.trimmingCharacters(in: .whitespacesAndNewlines)
    return generated_text.styled(with: content)
}

func get_html_text(par: Paragraph, kindOfSource: Int, parentID: Int) -> String {
    var references: String = ""
    var caption: String = ""
    if kindOfSource == 0 && parentID != 1 && parentID != 2 {
        if par.id < 10000 {
            references = "§" + String(par.id) + "\n"
        }
    }
    else if kindOfSource == 1 || kindOfSource == 2 || kindOfSource == 3 || kindOfSource == 4 || kindOfSource == 5 {
        if par.id < 10000 {
            references = "§" + String(par.id) + "\n"
        }
    }
    if par.caption != "" {
        caption = par.caption + "<br><br>"
    }
    return "\(caption)\(references)\(par.text)"
}

extension UIFont {
    func withTraits(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
