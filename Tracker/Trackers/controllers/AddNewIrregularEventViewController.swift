//
//  AddNewIrregularEventViewController.swift
//  Tracker
//
//  Created by Maxim on 23.04.2025.
//

import UIKit

final class AddNewIrregularEventViewController: UIViewController, UITableViewDelegate {
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
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        return label
    }()
    
    private var stackView = UIStackView()
    
    private var nameTracker = ""
    
    private var nameCategory = "Важное"
    
    private var textBeforeWarning = ""
    
    weak var delegate: CreatingTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc private func cancelAction(){
        dismiss(animated: true)
    }
    
    @objc private func creatButtonAction(){
        guard let dataInt = delegate?.currentDateInt() else { return }
        let newTracker = Tracker(id: UUID(),color: .colorSection5, name: nameTracker, emoji: "❤️", schedule: [dataInt])
        self.delegate?.dismissAndCreateCategory(tracker: newTracker, category: nameCategory)
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
        tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
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
        navigationItem.title = "Новое нерегулярное событие"
        navigationItem.hidesBackButton = true
        setStackViewTextFieldAndWarningLabel()
        setTableView()
        setCancelButton()
        setCreatButton()
    }
    
    private func createButtonIsActiveCheck(){
        if nameTracker.count > 0 {
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
    
    
    private func configCell(cell: CellCategoriesAndSchedule) {
        cell.label.text = "Категория"
    }

}

extension AddNewIrregularEventViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellCategoriesAndSchedule else {
            return UITableViewCell()
        }
        configCell(cell: cell)
        return cell
    }
}
extension AddNewIrregularEventViewController:UITextFieldDelegate {
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
