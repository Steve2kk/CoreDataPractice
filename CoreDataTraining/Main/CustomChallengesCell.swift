//
//  CustomChallengesCell.swift
//  CoreDataTraining
//
//  Created by Vsevolod Shelaiev on 10.04.2021.
//

import UIKit

class CustomChallengesCell: UITableViewCell {
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var termLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(termLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        termLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        termLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        termLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
