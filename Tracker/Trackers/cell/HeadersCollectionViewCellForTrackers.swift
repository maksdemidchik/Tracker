//
//  HeadersCollectionViewCellForTrackers.swift
//  Tracker
//
//  Created by Maxim on 27.04.2025.
//

import UIKit
final class HeadersCollectionViewCellForTrackers: UICollectionReusableView {
    var titleLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setTitleUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
    }
}
