//
//  ViewController.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 07.12.2020.
//

import UIKit
import CoreData

class ChallengesController: UITableViewController, CreateChallengeControllerDelegate {
    func didEditChallenge(challenge: Challenge) {
        let row = challenges.firstIndex(of: challenge)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddChallenge(challenge: Challenge) {
        challenges.append(challenge)
        let newIndexPath = IndexPath(row: challenges.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.reloadData()
    }
   
    var challenges = [Challenge]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChallenge()
        registerTableView()
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Challenges"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(handleAddChallenge))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(handleDeleteChallenge))
    }
    
    fileprivate func fetchChallenge() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Challenge>(entityName: "Challenge")
        do {
            let challenges = try context.fetch(fetchRequest)
            self.challenges = challenges
            tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch:",fetchErr)
        }
    }
    
    @objc func handleAddChallenge() {
        let addChallengeController = AddChallengeController()
        let addNavController = UINavigationController(rootViewController: addChallengeController)
        addChallengeController.delegate  = self
        present(addNavController, animated: true)
    }
    
    @objc func handleDeleteChallenge() {
        print("Deleting challenge")
    }
    
    //MARK:- TableView setups
    let cellId = "cellId"
    fileprivate func registerTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        cell.textLabel?.textColor = .white
        let challenge = challenges[indexPath.row]
        if let name = challenge.name, let term = challenge.term {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            let termDate = dateFormatter.string(from: term)
            let stringText = "\(name) term: \(termDate)"
            cell.textLabel?.text = stringText
        }else {
            cell.textLabel?.text = challenge.name
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            self.deleteHandler(indexPath: indexPath)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, success) in
            self.editHandler(indexPath: indexPath)
        }
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        config.performsFirstActionWithFullSwipe = false
            return config
        }

    fileprivate func deleteHandler(indexPath: IndexPath) {
        let challenge = self.challenges[indexPath.row]
        self.challenges.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(challenge)
        do {
            try context.save()
        }catch let saveContextErr {
            print("Problem to save context:",saveContextErr)
        }
    }
    
    fileprivate func editHandler(indexPath: IndexPath) {
        let editChallengesController = AddChallengeController()
        editChallengesController.delegate = self
        editChallengesController.challenge = challenges[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editChallengesController)
        present(navController, animated: true)
    }
    
    
    
    
}
class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
