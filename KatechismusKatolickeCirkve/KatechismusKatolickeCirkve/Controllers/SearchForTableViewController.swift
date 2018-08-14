//
//  SearchForTableViewController.swift
//  KatechismusKatolickeCirkve
//
//  Created by Petr Hracek on 08/08/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import UIKit

class SearchForTableViewController: UITableViewController {

    enum RowType {
        case by_chapters
        case by_numbers
    }
    
    struct SearchRowData {
        let type: RowType
        let searchFor: SearchForMenu?
    }
    fileprivate var rowData = [SearchRowData]()
    fileprivate var catechismStructure: CatechismStructure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSearchFor()
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
        return rowData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchForTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchForTableViewCell else {
            fatalError("The dequeue cell is not an entrance of SearchForTableViewCell")
        }
        
        let data = rowData[indexPath.row]
        cell.searchForLabel.text = data.searchFor?.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = rowData[indexPath.row]
        
        switch data.type {
        case .by_chapters:
            if let chaptersViewController = UIStoryboard(name: "Chapters", bundle: nil).instantiateInitialViewController() {
                navigationController?.pushViewController(chaptersViewController, animated: true)
            }
            
        case .by_numbers:
            print("Not implemented yet")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func loadSearchFor() {
        guard let browse_chapter = SearchForMenu(name: "Procházet kapitoly", photo: nil, order: 0) else {
            fatalError("Unable to instanciate Procházet kapitoly")
        }
        guard let search_for_numbers = SearchForMenu(name: "Vyhledávat podle čísel", photo: nil, order: 1) else {
            fatalError("Unable to instanciate Vyhledávat podle čísel")
        }

        
        rowData = [SearchRowData(type: .by_chapters, searchFor: browse_chapter)]
        rowData.append(SearchRowData(type: .by_numbers, searchFor: search_for_numbers))
    }
}
