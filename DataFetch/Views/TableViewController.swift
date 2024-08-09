//
//  TableViewController.swift
//  DataFetch
//
//  Created by Bhavitha Gottimukkula on 07/08/24.
//

import UIKit


class TableViewController: UITableViewController {
    
   // var users = [User]()
    var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the async fetchData() method
        if #available(iOS 15.0, *) {
            Task {
                await userViewModel.fetchData()
                tableView.reloadData()
            }
        } else {
            // Fallback on earlier versions
            // You might want to handle fetching data differently for earlier iOS versions
            print("Fetching data is not supported on iOS versions earlier than 15.0")
        }
    }
    
}

extension TableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userViewModel.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return TableViewCell() }
        cell.titleLabel?.text = userViewModel.users[indexPath.row].name
        cell.subTitleLabel.text = userViewModel.users[indexPath.row].location
        cell.descriptionLabel.text = userViewModel.users[indexPath.row].bio
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

