//
//  UsersListViewController.swift
//  FirebaeDelegate
//
//  Created by C4Q on 11/18/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit

class UsersListViewController: UIViewController {

    lazy var tableView: UITableView = {
           let tableView = UITableView()
           tableView.backgroundColor = .lightGray
           //MARK: TODO - set up custom cells
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.userListCell.rawValue)
           return tableView
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupNavigation() {
            self.title = "Users"
        }
        
        private func setupTableView() {
            view.addSubview(tableView)
            tableView.backgroundColor = .lightGray
           // tableView.delegate = self
            //tableView.dataSource = self
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        }
    
    

 

}
