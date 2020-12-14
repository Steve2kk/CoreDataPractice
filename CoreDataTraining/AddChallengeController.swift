//
//  AddChallengeController.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 08.12.2020.
//

import UIKit
import CoreData

protocol CreateChallengeControllerDelegate {
    func didAddChallenge(challenge: Challenge)
    func didEditChallenge(challenge: Challenge)
}


class AddChallengeController: UIViewController {
    var delegate: CreateChallengeControllerDelegate?
    var challenge: Challenge? {
        didSet {
            nameTextField.text = challenge?.name
            guard let safeTerm = challenge?.term else {return}
            datePicker.date = safeTerm
        }
    }
    
    let nameLabel: UILabel =  {
        let label = UILabel()
        label.text = "Name:"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your challenge"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = UIDatePickerStyle.wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        setupNavBar()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = challenge == nil ? "Create Challenge" : "Edit Challenge"
    }
    fileprivate func setupUI() {
        let backGroundMenuView = UIView()
        view.addSubview(backGroundMenuView)
        backGroundMenuView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        backGroundMenuView.translatesAutoresizingMaskIntoConstraints = false
        backGroundMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backGroundMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backGroundMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backGroundMenuView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: backGroundMenuView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: backGroundMenuView.leadingAnchor,constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor,constant: 4).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: backGroundMenuView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "save"), style: .plain, target: self, action: #selector(handleSaveChallenge))
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    @objc func handleSaveChallenge() {
        if challenge == nil {
            addChallenge()
        }else {
            editChallengesChanges()
        }
    }
    
    fileprivate func editChallengesChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        challenge?.name = nameTextField.text
        challenge?.term = datePicker.date
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditChallenge(challenge: self.challenge!)
            }
        }catch let editErr {
            print("Failed to edit:",editErr)
        }
        
    }
    
    fileprivate func addChallenge() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let challenge = NSEntityDescription.insertNewObject(forEntityName: "Challenge", into: context)
        challenge.setValue(nameTextField.text, forKey: "name")
        challenge.setValue(datePicker.date, forKey: "term")
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddChallenge(challenge: challenge as! Challenge )
            }
        } catch let saveErr {
            print("Failed to save",saveErr)
        }
    }
}
