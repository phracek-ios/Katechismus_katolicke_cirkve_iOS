//
//  FindWordViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 12/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit
import Foundation

class FindWordViewController: UIViewController {

    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var wordTextField: UITextField!

    var findWordData = [Int]()
    fileprivate var paragraphStructure: ParagraphStructure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paragraphStructure = ParagraphDataService.shared.paragraphStructure
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowParagraph":
            guard let paragraphViewController = segue.destination as? ParagraphViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            paragraphViewController.kindOfSource = 2
            paragraphViewController.findWordData = findWordData
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    @IBAction func findWordInParagraphs(_ sender: UIButton) {
        guard let paragraphStructure = paragraphStructure else { return }
        let text2find: String = wordTextField.text!
        for par in paragraphStructure.paragraph {
            if par.text.range(of: text2find) != nil {
                findWordData.append(par.id)
            }
        }
        if findWordData.count != 0 {
            performSegue(withIdentifier: "ShowParagraph", sender: self)
        }
    }
    
}
