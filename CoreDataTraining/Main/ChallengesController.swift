//
//  ViewController.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 07.12.2020.
//

import UIKit
import CoreData

class ChallengesController: UITableViewController {
    
    var challenges = [Challenge]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.challenges = CoreDataManager.shared.fetchChallenges()
        registerTableView()
        setupNavBarAppearance()
        setupNavItems()
    }
    
    fileprivate func registerTableView() {
        tableView.register(CustomChallengesCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = UIColor.white
    }
    
    fileprivate func setupNavItems() {
        navigationItem.title = "Challenges"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(handleAddChallenge))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(handleDeleteChallenge))
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
     
    @objc private func handleAddChallenge() {
        let addChallengeController = AddChallengeController()
        addChallengeController.delegate = self
        let addNavController = UINavigationController(rootViewController: addChallengeController)
        present(addNavController, animated: true)
    }
    
    @objc private func handleDeleteChallenge() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        challenges.forEach { (challenge) in
            context.delete(challenge)
        }
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Challenge.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            challenges.removeAll()
            tableView.reloadData()
        } catch let deleteError {
            print("Failed to delete objects from CoreData: ",deleteError)
        }
    }

}

extension ChallengesController {
    fileprivate func setupNavBarAppearance(){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.customPink
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}
