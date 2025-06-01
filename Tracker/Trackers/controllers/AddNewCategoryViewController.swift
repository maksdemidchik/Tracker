//
//  AddNewCategoryViewController.swift
//  Tracker
//
//  Created by Maxim on 30.05.2025.
//

import UIKit

class AddNewCategoryViewController: UIViewController {
    
    private var nameCategory = ""
    
    var viewModelForCategoryController : CategoryViewModel?
    
    private var textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = .textField
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.setIndents()
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let createButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle( "Готово", for: .normal)
        button.tintColor = .whiteYP
        button.backgroundColor = .grayYP
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    @objc private func createCategory(){
        viewModelForCategoryController?.addNewCategory(name: nameCategory)
        self.dismiss(animated: true)
    }
    private func setTextField(){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        view.addSubview(textField)
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    private func setCreateButton(){
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createCategory), for: .touchDown)
        view.addSubview(createButton)
        createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setUI(){
        navigationItem.hidesBackButton = true
        view.backgroundColor = .whiteYP
        navigationItem.title = "Новая категория"
        setTextField()
        setCreateButton()
    }
    private func createButtonIsActiveCheck(){
        if nameCategory.count > 0{
            createButton.isEnabled = true
            createButton.backgroundColor = .blackYP
        }
        else{
            createButton.isEnabled = false
            createButton.backgroundColor = .grayYP
        }
    }
}
extension AddNewCategoryViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        nameCategory = updatedText
        createButtonIsActiveCheck()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        createButtonIsActiveCheck()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        nameCategory = ""
        createButtonIsActiveCheck()
        return true
    }
}
