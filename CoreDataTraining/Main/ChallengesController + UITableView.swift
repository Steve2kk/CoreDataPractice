//
//  ChallengesController + UITableView.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 30.03.2021.
//

import UIKit
extension ChallengesController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomChallengesCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        let challenge = challenges[indexPath.row]
        if let name = challenge.name,let term = challenge.term {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            let termDate = dateFormatter.string(from: term)
            cell.nameLabel.text = "Name: " + name.maxLength(length: 30)
            cell.termLabel.text = "Term: " + termDate
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No challenges yet..."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return challenges.count == 0 ? 100 : 0
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

