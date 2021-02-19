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
    var endNumber = 500
    
    struct NumbersDetailRowData {
        var number : Int
        var number_final: Int
        var text: String
    }
    
    fileprivate var numbersDetailRowData = [NumbersDetailRowData]()
    fileprivate var diff = 30
    var darkMode: Bool = false
    let lastSection: Int = 2861
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNumbers()
        self.tableView.rowHeight = 80
        self.tableView.tableFooterView = UIView()
        let userDefaults = UserDefaults.standard
        self.darkMode = userDefaults.bool(forKey: "NightSwitch")
        if self.darkMode {
            self.tableView.backgroundColor = KKCBackgroundNightMode
        } else {
            self.tableView.backgroundColor = KKCBackgroundLightMode
        }
        navigationController?.navigationBar.barStyle = UIBarStyle.black;
   }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
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
        return numbersDetailRowData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NumbersDetailTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NumbersDetailTableViewCell else { return UITableViewCell()
        }
        cell.numberDetails?.text = numbersDetailRowData[indexPath.row].text
        if self.darkMode == true {
            cell.backgroundColor = KKCBackgroundNightMode
            cell.numberDetails.textColor = KKCTextNightMode
        }
        else {
            cell.backgroundColor = KKCBackgroundLightMode
            cell.numberDetails.textColor = KKCTextLightMode
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            
        case "ShowParagraph":
            guard let pcvc = segue.destination as? ParagraphTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = sender as? IndexPath else {
                fatalError("The selected cell is not being displayed by the table")
            }
            var parentNumber = numbersDetailRowData[indexPath.row].number
            if parentNumber == 0 {
                parentNumber = 1
            }
            pcvc.kindOfSource = 1
            pcvc.parentID = parentNumber
            pcvc.rangeID = numbersDetailRowData[indexPath.row].number_final
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowParagraph", sender: indexPath)
    }
    private func addRow() {
        var finalNumber: Int = 0
        if beginNumber + diff >= endNumber {
            finalNumber = endNumber
        }
        else {
            finalNumber = beginNumber + diff
        }
        let text_for_disp: String = ("\(beginNumber)-\(finalNumber)")
        numbersDetailRowData.append(NumbersDetailRowData(number: beginNumber,
                                                         number_final: finalNumber, text: text_for_disp))
    }
    private func initNumbers() {
        let count = (endNumber - beginNumber) / diff + 1
        for _ in 1...count {
            if beginNumber <= lastSection {
                addRow()
                beginNumber += diff
            }
        }
    }
    @objc private func darkModeEnabled(_ notification: Notification) {
        self.darkMode = true
        self.tableView.backgroundColor = KKCBackgroundNightMode
        self.tableView.reloadData()
    }
    
    @objc private func darkModeDisabled(_ notification: Notification) {
        self.darkMode = false
        self.tableView.backgroundColor = KKCBackgroundLightMode
        self.tableView.reloadData()
    }
}
