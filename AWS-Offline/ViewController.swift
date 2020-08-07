//
//  ViewController.swift
//  AWS-Offline
//
//  Created by Hoàng Anh on 07/08/2020.
//  Copyright © 2020 Hoàng Anh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    let manager = DataManager()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        getUsers()
    }
    
    func configTableView() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func getUsers() {
        manager.getUsers { [weak self] users in
            self?.populate(with: users)
        }
    }
    
    func populate(with users: [User]) {
        print(users)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].id
        cell.detailTextLabel?.text = users[indexPath.row].content
        return cell
    }
}
