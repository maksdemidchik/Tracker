//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Maxim on 26.05.2025.
//

import UIKit

class CategoryViewController: UIViewController {
    var viewModel : CategoryViewModel?
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "сell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = 75
        return tableView
    }()
    
    private let plugText : UILabel = {
        let label = UILabel()
        label.text = "Привычки события можно\n объединить по смыслу"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        label.textAlignment = .center
        return label
    }()
    
    private let imagePlaceholder : UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(named: "placeholder")
        imgView.image = img
        return imgView
    }()
    
    private let addCategoryButton : UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .blackYP
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.tintColor = .whiteYP
        return button
    }()
    
    private var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    @objc private func goToAddNewCategory(){
        let vc = AddNewCategoryViewController()
        vc.viewModelForCategoryController = viewModel
        let creatNewCategoryVC = UINavigationController(rootViewController: vc)
        present(creatNewCategoryVC,animated: true)
    }
    
    private func bind(){
        guard let viewModel = viewModel else { return }
        
        viewModel.didChangeCountCategories = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            stackView.isHidden = true
        }
        
        viewModel.categoryIsChoose = { [weak self] _ in
            guard let self = self else { return }
            if viewModel.getPreviousIndexPath() != nil,let indexPath = viewModel.getPreviousIndexPath() {
                self.tableView.deselectRow(at: indexPath, animated: true)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? CategoryCell else {
                    return
                }
                cell.checkMarkImageView.isHidden = true
            }
            
            if let indexPath = viewModel.getCurrentIndexPath(){
                self.tableView.deselectRow(at: indexPath, animated: true)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? CategoryCell else {
                    return
                }
                cell.checkMarkImageView.isHidden = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: true)
            }
            
        }
    }
    
    private func setButton(){
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.addTarget(self, action: #selector(goToAddNewCategory), for: .touchDown)
        view.addSubview(addCategoryButton)
        addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor,constant: -47).isActive = true
    }
    
    private func setUpPlaceholder(){
        imagePlaceholder.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imagePlaceholder.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView = UIStackView(arrangedSubviews: [imagePlaceholder,plugText])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setUI(){
        view.backgroundColor = .whiteYP
        navigationItem.title = "Категория"
        navigationItem.hidesBackButton = true
        setButton()
        setTableView()
        setUpPlaceholder()
        stackView.isHidden = viewModel?.getCountCategories() ?? 0 > 0
    }
    
    private func configCell(cell: CategoryCell,indexPath: IndexPath){
        guard let categories = viewModel?.getCategories() else { return }
        cell.categoryName.text = categories[indexPath.row]
        cell.checkMarkImageView.isHidden = !(viewModel?.checkNeedACheckmark(currentIndexPath: indexPath) ?? false)
        if indexPath.row == categories.count - 1 {
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

extension CategoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getCountCategories() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "сell", for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.chooseCategory(currentIndexPath: indexPath)
    }
}

