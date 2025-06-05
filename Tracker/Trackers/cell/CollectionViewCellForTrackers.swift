//
//  CollectionViewCellForTrackers.swift
//  Tracker
//
//  Created by Maxim on 27.04.2025.
//

import UIKit

protocol CollectionViewCellForTrackersDelegate: AnyObject {
    func didTapButton(id: UUID)
}

final class CollectionViewCellForTrackers: UICollectionViewCell {
    weak var delegate: CollectionViewCellForTrackersDelegate?
    
    let nameAndEmojiView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var trackerID : UUID?
    
    var indexPath: IndexPath?
    
    var emojiLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    var emojiView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    
    var namesTrackers: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 5
        return label
    }()
    
    var daylabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var color: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func plusButtonAction() {
        if let id = trackerID {
            delegate?.didTapButton(id: id)
        }
    }
    
    private func setButtonUI() {
        let button = UIButton.systemButton(with: UIImage(named: "plus CollectionView") ?? UIImage(), target: self, action: #selector(plusButtonAction))
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        self.button = button
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.topAnchor.constraint(equalTo: nameAndEmojiView.bottomAnchor, constant: 8).isActive = true
        button.trailingAnchor.constraint(equalTo: nameAndEmojiView.trailingAnchor, constant: -12).isActive = true
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    private func setLabelUI(){
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        namesTrackers.translatesAutoresizingMaskIntoConstraints = false
        daylabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameAndEmojiView.addSubview(namesTrackers)
        emojiView.addSubview(emojiLabel)
        contentView.addSubview(daylabel)
        
        emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor).isActive = true
        emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor).isActive = true
        
        namesTrackers.leadingAnchor.constraint(equalTo: nameAndEmojiView.leadingAnchor, constant: 12).isActive = true
        namesTrackers.trailingAnchor.constraint(equalTo: nameAndEmojiView.trailingAnchor, constant: -12).isActive = true
        namesTrackers.bottomAnchor.constraint(equalTo: nameAndEmojiView.bottomAnchor,constant: -12).isActive = true
        
        daylabel.topAnchor.constraint(equalTo: nameAndEmojiView.bottomAnchor, constant: 16).isActive = true
        daylabel.leadingAnchor.constraint(equalTo: nameAndEmojiView.leadingAnchor, constant: 12).isActive = true
    }
    
    private func setViewsUI() {
        nameAndEmojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameAndEmojiView)
        nameAndEmojiView.addSubview(emojiView)
        
        nameAndEmojiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        nameAndEmojiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        nameAndEmojiView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameAndEmojiView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        emojiView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        emojiView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        emojiView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setUI() {
        setViewsUI()
        setLabelUI()
        setButtonUI()
    }
    
    func setImageButton(isCompleted: Bool){
        if isCompleted {
            button.setImage(UIImage(named: "done"), for: .normal)
            button.tintColor = .whiteYP
            button.backgroundColor = color?.withAlphaComponent(0.3)
        }
        else{
            button.setImage(UIImage(named: "plus CollectionView"), for: .normal)
            button.backgroundColor = .whiteYP
            button.tintColor = color
        }
    }
}
