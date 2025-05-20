//
//  EmojiAndColorCollectionCell.swift
//  Tracker
//
//  Created by Maxim on 09.05.2025.
//

import UIKit

final class EmojiAndColorCollectionCell: UICollectionViewCell {
    var emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    var color: UIView = {
        let colorView = UIView()
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 12
        return colorView
    }()
    /*
    override var isSelected: Bool{
        didSet {
            contentView.backgroundColor = isSelected ?  .textField : .clear
        }
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    private func setColor(){
        color.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(color)
        color.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        color.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        color.heightAnchor.constraint(equalToConstant: 40).isActive = true
        color.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func SetUI(){
        setEmojiLabel()
        setColor()
    }
    
    func emojiSelected(){
        contentView.backgroundColor = .selected
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
    }
    
    func colorSelected(color: UIColor){
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    func removeSelection(){
        contentView.backgroundColor = .whiteYP
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 0
    }
}
