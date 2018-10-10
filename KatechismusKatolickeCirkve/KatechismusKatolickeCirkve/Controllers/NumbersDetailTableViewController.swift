//
//  NumbersDetailTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 05/09/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersDetailTableViewController: UITableViewController {

    var beginNumber = 1
    var endNumber = 499
    
    struct NumbersDetailRowData {
        var number : Int
        var number_final: Int
        var text: String
    }
    
    fileprivate var numbersDetailRowData = [NumbersDetailRowData]()
    fileprivate var diff = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNumbers()
        self.tableView.rowHeight = 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbersDetailRowData.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NumbersDetailTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NumbersDetailTableViewCell else { return UITableViewCell()
        }
        cell.numberDetails?.text = numbersDetailRowData[indexPath.row].text
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowParagraph":
            guard let paragraphTableViewController = segue.destination as? ParagraphTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            var parentNumber = numbersDetailRowData[indexPath.row].number
            print(parentNumber)
            if parentNumber == 0 {
                parentNumber = 1
            }
            paragraphTableViewController.kindOfSource = 1
            paragraphTableViewController.parentID = parentNumber
            paragraphTableViewController.rangeID = numbersDetailRowData[indexPath.row].number_final
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowParagraph", sender: indexPath)
    }
    private func addRow() {
        if beginNumber == 2830 {
            endNumber = 2865
        }
        else {
            endNumber = beginNumber + diff - 1
        }
        let text_for_disp: String = ("\(beginNumber)-\(endNumber)")
        numbersDetailRowData.append(NumbersDetailRowData(number: beginNumber,
                                                         number_final: endNumber, text: text_for_disp))
    }
    private func initNumbers() {
        let count = (endNumber - beginNumber) / diff + 1
        for _ in 1...count {
            addRow()
            beginNumber += diff
        }
    }
}
