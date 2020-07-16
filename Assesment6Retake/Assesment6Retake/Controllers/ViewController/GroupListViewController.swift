//
//  GroupListViewController.swift
//  Assesment6Retake
//
//  Created by Connor Holland on 7/16/20.
//  Copyright © 2020 Connor Holland. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var groupListTableView: UITableView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    // MARK: - Actions
    @IBAction func addBarButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        alertController.addTextField { (texField) in
            texField.placeholder = "Add a person."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else {return}
            PersonController.shared.addPerson(with: text)
            self.refreshRandomize()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: true)
        
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        refreshRandomize()
    }
    
    // MARK: - Helper Methods
    func refreshRandomize() {
        PersonController.shared.pairs = []
        PersonController.shared.randomize()
        updateView()
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.groupListTableView.reloadData()
        }
    }
    
    func setupViews() {
        self.groupListTableView.delegate = self
        self.groupListTableView.dataSource = self
        PersonController.shared.loadFromPersistenceStore()
        refreshRandomize()
    }
}

extension GroupListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PersonController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PersonController.shared.sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonController.shared.pairs[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let name = PersonController.shared.pairs[indexPath.section][indexPath.row]
        cell.textLabel?.text = name?.fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let personToDelete = PersonController.shared.pairs[indexPath.section][indexPath.row] else {return}
            PersonController.shared.delete(person: personToDelete)
            refreshRandomize()
            updateView()
        }
    }
}
