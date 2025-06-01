//
//  categoryCell.swift
//  Tracker
//
//  Created by Maxim on 30.05.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    weak var delegate: ScheduleCelldDelegate?
    
    let categoryName = UILabel()
    
    let checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        return imageView
    }()
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDayTitleUI()
        setCheckMark()
        checkMarkImageView.isHidden = true
        contentView.backgroundColor = .textField
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setDayTitleUI(){
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryName)
        categoryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        categoryName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setCheckMark(){
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkMarkImageView)
        checkMarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        checkMarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
