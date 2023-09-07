//
//  UsersViewController.swift
//  mvpPatternDemo_puran
//
//  Created by Puran on 27/07/23.
//

import UIKit

class UsersViewController: UIViewController {

    private let _tblView : UITableView = {
        
        let tableview = UITableView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    private let presenter = UsersPresenter()
    private var usersList = [Users]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Users List"
        
        //setup table view
        view.addSubview(_tblView)
        _tblView.dataSource = self
        _tblView.delegate = self
        
        //call presenter
        presenter.setViewDelegate(delegate: self)
        presenter.getUsersList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _tblView.frame = self.view.bounds
    }
}

extension UsersViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentUser = self.usersList[indexPath.row]
        cell.textLabel?.text = currentUser.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //ask presenter here to do the task
        presenter.didTapOnUser(user: self.usersList[indexPath.row])
    }
}
//Presenter delegate
extension UsersViewController : UserPresenterDelegate{
    
    func presentUsers(users: [Users]) {
        
        self.usersList = users
        DispatchQueue.main.async {
            
            self._tblView.reloadData()
        }
    }
    func presentAlert(title: String, message: String) {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .default))
        self.present(alertController, animated: true)
    }
}
