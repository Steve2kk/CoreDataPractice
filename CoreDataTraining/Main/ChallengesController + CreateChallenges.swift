//
//  ChallengesController + CreateChallenges.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 30.03.2021.
//

import Foundation
extension ChallengesController: CreateChallengeControllerDelegate {
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
}
