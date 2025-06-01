//
//  CellCategoriesAndSchedule.swift
//  Tracker
//
//  Created by Maxim on 23.04.2025.
//

import UIKit

final class CellCategoriesAndSchedule: UITableViewCell {
    
    let image = UIImageView()
    
    let label = UILabel()
    
    let daysOrCategoryNameLabel = UILabel()
    
    var stackView = UIStackView()
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        contentView.backgroundColor = .textField
        accessoryType = .none
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageUI(){
        image.image = UIImage(named: "buttonCell")
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(image)
        image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        image.heightAnchor.constraint(equalToConstant: 24).isActive = true
        image.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setStackViewUI(){
        daysOrCategoryNameLabel.isHidden = true
        stackView = UIStackView(arrangedSubviews: [label,daysOrCategoryNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.textColor = .blackYP
        daysOrCategoryNameLabel.textColor = .grayYP
    }
    
    private func setUI(){
        setImageUI()
        setStackViewUI()
    }
}
