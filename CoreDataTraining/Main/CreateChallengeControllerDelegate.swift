//
//  CreateChallengeControllerDelegate.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 30.03.2021.
//

import Foundation
protocol CreateChallengeControllerDelegate {
    func didAddChallenge(challenge: Challenge)
    func didEditChallenge(challenge: Challenge)
}
