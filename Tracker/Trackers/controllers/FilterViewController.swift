//
//  FilterViewController.swift
//  Tracker
//
//  Created by Maxim on 08.06.2025.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilterCategory(_ filterCategory: String)
}


final class FilterViewController: UIViewController {
    private let filterCategories: [String] = [
        NSLocalizedString("allTrackers", comment: "allTrackers"),
        NSLocalizedString("trackersForToday", comment: "trackersForToday"),
        NSLocalizedString("completed", comment: "completed"),
        NSLocalizedString("notCompleted", comment: "notCompleted")
    ]
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "сell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = 75
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    private var currentFilterCategory = ""
    
    private var previuosFilterCategory: IndexPath?
    
    weak var delegate: FilterViewControllerDelegate?
    
    init(filterCategory: String,delegate:FilterViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        currentFilterCategory = filterCategory
        print(filterCategory)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setUI(){
        view.backgroundColor = .whiteYP
        navigationItem.title = NSLocalizedString("filters", comment: "filters")
        navigationItem.hidesBackButton = true
        setTableView()
    }
    
    private func configCell(cell: CategoryCell, indexPath: IndexPath){
        cell.categoryName.text = filterCategories[indexPath.row]
        previuosFilterCategory = (currentFilterCategory == filterCategories[indexPath.row]) ? indexPath : previuosFilterCategory
        cell.checkMarkImageView.isHidden = !(currentFilterCategory == filterCategories[indexPath.row])
        if indexPath.row == 3 {
            cell.layer.masksToBounds = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
        } else{
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 0
        }
    }
}

extension FilterViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "сell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
}
extension FilterViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if let newIndexPath = self.previuosFilterCategory{
            guard let cell = self.tableView.cellForRow(at: newIndexPath) as? CategoryCell else {
                return
            }
            cell.checkMarkImageView.isHidden = true
        }
        guard let cell = self.tableView.cellForRow(at: indexPath) as? CategoryCell else {
            return
        }
        currentFilterCategory = filterCategories[indexPath.row]
        cell.checkMarkImageView.isHidden = false
        previuosFilterCategory = indexPath
        delegate?.didSelectFilterCategory(currentFilterCategory)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true)
        }
    }
}

