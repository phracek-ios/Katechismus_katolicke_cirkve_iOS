//
//  NumbersTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 09/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class NumbersTableViewController: UITableViewController {

    fileprivate var diff = 500
    fileprivate var beginNumber = 1
    fileprivate var endNumber = 2865

    struct NumbersRowData {
        var number : Int
        var text: String
    }
    
    fileprivate var numbersRowData = [NumbersRowData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initNumbers()
        self.tableView.rowHeight = 80
        self.navigationItem.title = "Vyhledávat podle čísel"

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
        return numbersRowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NumbersTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NumbersTableViewCell else { return UITableViewCell()
        }
        cell.numberLabel?.text = numbersRowData[indexPath.row].text
        return cell

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowNumbersDetail":
            guard let numbersDetailTableViewController = segue.destination as? NumbersDetailTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let parentNumber = numbersRowData[indexPath.row].number
            numbersDetailTableViewController.beginNumber = parentNumber
            var endNumber: Int = 0
            if parentNumber == 2500 {
                endNumber = 2865
            }
            else {
                endNumber = parentNumber + diff - 1
            }
            numbersDetailTableViewController.endNumber = endNumber
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNumbersDetail", sender: indexPath)
    }
    
    private func addRow() {
        if beginNumber == 2500 {
            endNumber = 2865
        }
        else {
            endNumber = beginNumber + diff - 1
        }
        let text_for_disp: String = ("\(beginNumber)-\(endNumber)")
        numbersRowData.append(NumbersRowData(number: beginNumber, text: text_for_disp))

    }
    private func initNumbers() {
        let count = endNumber / diff + 1
        for _ in 1...count {
            addRow()
            beginNumber += diff
        }
    }
}
