//
//  CollectionViewForCreateTrackerCell.swift
//  Tracker
//
//  Created by Maxim on 09.05.2025.
//

import UIKit

protocol CollectionViewForCreateTrackerCellDelegate: AnyObject {
    func setEmoji(emoji: String)
    func setColor(color: UIColor)
    func changeSizeCollectionView()
}

final class CollectionViewForCreateTrackerCell:UICollectionViewCell {
    
    private let shared = CreateNewTrackerAndScheduleServices.shared
    
    private let emoji = ["🙂","😻","🌺","🐶","❤️","😱","😇", "😡" , "🥶", "🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝️","😪"]
    
    private let color: [UIColor] = [.colorSelection1,.colorSelection2,.colorSelection3,.colorSelection4,.colorSelection5,.colorSelection6,.colorSelection7,.colorSelection8,.colorSelection9,.colorSelection10,.colorSelection11,.colorSelection12,.colorSelection13,.colorSelection14,.colorSelection15,.colorSelection16,.colorSelection17,.colorSelection18]
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CellCategoriesAndSchedule.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = (UIScreen.main.bounds.width - 18 * 2 - 5 * 5 )/6
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 24, left: 18, bottom: 34, right: 18)
        layout.itemSize = CGSize(width: size, height: size)
        layout.headerReferenceSize = CGSize(width: size, height: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EmojiAndColorCollectionCell.self, forCellWithReuseIdentifier: "tableViewCollectionCell")
        collectionView.register(HeadersCollectionViewCellForTrackers.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        return label
    }()
    
    let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .textField
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.setIndents()
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private var stackView = UIStackView()
    
    private var pastSelectedEmojiIndexPath : IndexPath?
    
    private var pastSelectedColorIndexPath : IndexPath?
    
    private var nameTracker = ""
    
    private var textBeforeWarning = ""
    
    
    weak var delegate: CollectionViewForCreateTrackerCellDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func setWarnings(){
        guard let textCount = textField.text?.count else { return }
        if textCount == 38 {
            warningLabel.isHidden = false
            shared.setWarning()
            delegate?.changeSizeCollectionView()
        }
        else{
            if textCount == 37 && shared.isWarning {
                shared.deletedWarning()
                delegate?.changeSizeCollectionView()
            }
            warningLabel.isHidden = true
        }
    }
    private func setStackViewTextFieldAndWarningLabel(){
        stackView = UIStackView(arrangedSubviews: [textField,warningLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.addTarget(self, action: #selector(setWarnings), for: .editingChanged)
        warningLabel.isHidden = true
    }
    
    private func setTableView(){
        tableView.dataSource = self
        if shared.habitOrEvent == "Нерегулярное событие" {
            tableView.separatorStyle = .none
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24).isActive = true
        tableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,constant: -16).isActive = true
        if shared.habitOrEvent == "Привычка"{
            tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
        else{
            tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    private func setCollectionView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func setUI(){
        setStackViewTextFieldAndWarningLabel()
        setTableView()
        setCollectionView()
    }
    
    private func configCell(cell: CellCategoriesAndSchedule,indexPath:IndexPath) {
        if indexPath.row == 0{
            cell.label.text = "Категория"
        }
        else{
            cell.label.text = "Расписание"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
        if shared.numberOfDays.count > 0 && indexPath.row == 1 {
            cell.daysLabel.isHidden = false
            cell.daysLabel.text = shared.setSchudule()
        }
    }
    private func configCellCollection(cell:EmojiAndColorCollectionCell, indexPath: IndexPath){
        if indexPath.section == 0{
            cell.color.isHidden = true
            cell.emojiLabel.isHidden = false
            cell.emojiLabel.text = emoji[indexPath.row]
        }
        else{
            cell.emojiLabel.isHidden = true
            cell.color.isHidden = false
            cell.color.backgroundColor = color[indexPath.row]
        }
    }
}

extension CollectionViewForCreateTrackerCell:  UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shared.habitOrEvent == "Привычка"{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellCategoriesAndSchedule else {
            return UITableViewCell()
        }
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? HeadersCollectionViewCellForTrackers {
            if indexPath.section == 0 {
                header.titleLabel.text = "Emoji"
            }
            else{
                header.titleLabel.text = "Цвет"
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension CollectionViewForCreateTrackerCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableViewCollectionCell", for: indexPath) as? EmojiAndColorCollectionCell else {
            return UICollectionViewCell()
        }
        configCellCollection(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension CollectionViewForCreateTrackerCell: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionCell else {
            return
        }
        if indexPath.section == 0 {
            if pastSelectedEmojiIndexPath != nil {
                guard let pastSelectedIndexPath = pastSelectedEmojiIndexPath,let pastSelectedCell = collectionView.cellForItem(at: pastSelectedIndexPath) as? EmojiAndColorCollectionCell else {
                    return
                }
                pastSelectedCell.removeSelection()
            }
            cell.emojiSelected()
            pastSelectedEmojiIndexPath = indexPath
            delegate?.setEmoji(emoji: emoji[indexPath.row])
        }
        else{
            if pastSelectedColorIndexPath != nil {
                guard let pastSelectedColorIndexPath = pastSelectedColorIndexPath,let pastSelectedCell = collectionView.cellForItem(at: pastSelectedColorIndexPath) as? EmojiAndColorCollectionCell else {
                    return
                }
                pastSelectedCell.removeSelection()
            }
            cell.colorSelected(color: color[indexPath.row])
            pastSelectedColorIndexPath = indexPath
            delegate?.setColor(color: color[indexPath.row])
        }
    }
}
