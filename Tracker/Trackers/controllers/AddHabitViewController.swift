//
//  AddHabitViewController.swift
//  Tracker
//
//  Created by Maxim on 22.04.2025.
//

import UIKit

protocol AddHabitDelegate: AnyObject {
    func setScheduleText()
}

final class AddHabitViewController: UIViewController{
    private let service = HabitAndScheduleServices.shared
    
    private let cancelButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.setTitle("Отменить", for: .normal)
        button.layer.borderWidth = 1
        button.backgroundColor = .whiteYP
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let creatButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle( "Создать", for: .normal)
        button.tintColor = .whiteYP
        button.backgroundColor = .grayYP
        return button
    }()
    
    private let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .textField
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.setIndents()
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CellCategoriesAndSchedule.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    private let categoriesORSchedule = ["Категория","Расписание"]
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        return label
    }()
    
    private var textBeforeWarning = ""
    
    private var nameCategory = "Важное"
    
    private var nameTracker = ""
    
    private var stackView = UIStackView()
    
    weak var delegate: CreatingTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc func creatButtonAction(){
        let newTracker = Tracker(id: UUID(),color: .colorSection5, name: nameTracker, emoji: "❤️", schedule: service.numberOfDaysForDateInt)
        self.delegate?.dismissAndCreateCategory(tracker: newTracker, category: nameCategory)
        self.dismiss(animated: true)
        service.remove()
    }
    
    @objc func cancelAction(){
        service.remove()
        dismiss(animated: true)
    }
    
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func setCreatButton(){
        creatButton.translatesAutoresizingMaskIntoConstraints = false
        creatButton.isEnabled = false
        creatButton.addTarget(self, action: #selector(creatButtonAction), for: .touchDown)
        view.addSubview(creatButton)
        creatButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        creatButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8).isActive = true
        creatButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        creatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        creatButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
    }
    
    private func setCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchDown)
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    private func setStackViewTextFieldAndWarningLabel(){
        stackView = UIStackView(arrangedSubviews: [textField,warningLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.delegate = self
        warningLabel.isHidden = true
    }
    
    private func setUI(){
        view.backgroundColor = .whiteYP
        navigationItem.title = "Новая привычка"
        navigationItem.hidesBackButton = true
        setCancelButton()
        setCreatButton()
        setStackViewTextFieldAndWarningLabel()
        setTableView()
    }
    
    private func createButtonIsActiveCheck(){
        if nameTracker.count > 0 &&  service.setSchudule().count > 0{
            creatButton.isEnabled = true
            creatButton.backgroundColor = .blackYP
        }
        else{
            createButtonIsNotActive()
        }
    }
    
    private func createButtonIsNotActive(){
        creatButton.isEnabled = false
        creatButton.backgroundColor = .grayYP
    }
    
    private func setWarningIfNeeds(){
        if nameTracker.count == 38 {
            textBeforeWarning = nameTracker
            warningLabel.isHidden = true
        }
        else if nameTracker.count > 38 {
            warningLabel.isHidden = false
            nameTracker = textBeforeWarning
        }
        else{
            warningLabel.isHidden = true
        }
    }
    
    private func configCell(CellCategoriesAndSchedule cell: CellCategoriesAndSchedule, forRowAt indexPath: IndexPath){
        cell.label.text = categoriesORSchedule[indexPath.row]
        if service.numberOfDays.count > 0 && indexPath.row == 1 {
            cell.daysLabel.isHidden = false
            cell.daysLabel.text = service.setSchudule()
        }
        if indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
    }
}

extension AddHabitViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.endEditing(true)
        if indexPath.row == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            let creatScheduleViewController = UINavigationController(rootViewController: vc)

            present(creatScheduleViewController,animated: true)
        }
    }
}

extension AddHabitViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesORSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellCategoriesAndSchedule else { return UITableViewCell() }
        configCell(CellCategoriesAndSchedule: cell, forRowAt: indexPath)
        return cell
    }
}

extension AddHabitViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        nameTracker = updatedText
        setWarningIfNeeds()
        createButtonIsActiveCheck()
        return updatedText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        createButtonIsActiveCheck()
        return true
    }
}

extension AddHabitViewController: AddHabitDelegate{
    func setScheduleText(){
        tableView.reloadData()
        createButtonIsActiveCheck()
    }

}
