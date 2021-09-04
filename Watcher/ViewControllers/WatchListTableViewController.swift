//
//  WatchListTableViewController.swift
//  Watcher
//
//  Created by Евгений Березенцев on 01.09.2021.
//

import UIKit

class WatchListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: StorageManager.shared.updateNotification, object: nil)

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        StorageManager.shared.watchList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let movie = StorageManager.shared.watchList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = movie.title
        cell.contentConfiguration = content
        return cell
    }
    

    

    



}
