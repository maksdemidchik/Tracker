//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Maxim on 09.05.2025.
//

import UIKit

final class CreateNewTrackerViewController: UIViewController {
    
    private let shared = CreateNewTrackerAndScheduleServices.shared
    
    private let cancelButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.systemRed.cgColor
        let text = NSLocalizedString("cancelText", comment: "cancelText")
        button.setTitle(text, for: .normal)
        button.layer.borderWidth = 1
        button.backgroundColor = .whiteYP
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let createButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        let text = NSLocalizedString("createText", comment: "createText")
        button.setTitle(text , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .grayYP
        return button
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewForCreateTrackerCell.self, forCellWithReuseIdentifier: "TrackerCreateCell")
        return collectionView
    }()
    
    private var nameTracker = ""
    
    private var textBeforeWarning = ""
    
    private var emojiTracker : String = ""
    
    private var colorTracker : UIColor? = nil
    
    weak var delegate: CreatingTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        shared.deletedWarning()
        shared.remove()
    }
    
    @objc private func cancelAction(){
        dismiss(animated: true)
    }
    
    @objc private func creatButtonAction(){
        guard let dataInt = delegate?.currentDateInt() else { return }
        guard let color = colorTracker else { return }
        let schedule = shared.numberOfDaysForDateInt.count > 0 ? shared.numberOfDaysForDateInt : [dataInt]
        let newTracker = Tracker(id: UUID(),color: color, name: nameTracker, emoji: emojiTracker, schedule: schedule, dateOfAddition: Date(), isItPinned: false)
        self.delegate?.dismissAndCreateCategory(tracker: newTracker, category: shared.curruntCategory)
        dismiss(animated: true)
    }
    
    private func setCreateButton(){
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(creatButtonAction), for: .touchDown)
        view.addSubview(createButton)
        createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
    }
    
    private func setCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchDown)
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor,constant: -16).isActive = true
        collectionView.backgroundColor = .whiteYP
    }
    
    private func setUI(){
        setCancelButton()
        setCreateButton()
        setCollectionView()
        view.backgroundColor = .whiteYP
        if shared.habitOrEvent == "Нерегулярное событие"{
            let text = NSLocalizedString("NewHabitText", comment: "NewHabitText")
            navigationItem.title = text
        }
        else{
            let text = NSLocalizedString("NewIrregularEvent", comment: "NewIrregularEvent")
            navigationItem.title = text
        }
        navigationItem.hidesBackButton = true
    }
    
    private func createButtonIsActiveCheck(){
        let checkingIfThereIsASchedule = (shared.habitOrEvent == "Привычка" && shared.setSchedule().count > 0) || shared.habitOrEvent == "Нерегулярное событие"   ? true : false
        if nameTracker.count > 0 && emojiTracker.count > 0 && checkingIfThereIsASchedule && colorTracker != nil && shared.curruntCategory != ""{
            createButton.isEnabled = true
            createButton.backgroundColor = .blackYP
            createButton.setTitleColor(.whiteYP, for: .normal)
        }
        else{
            createButtonIsNotActive()
        }
    }
    
    private func createButtonIsNotActive(){
        createButton.isEnabled = false
        createButton.backgroundColor = .grayYP
    }
    
    private func showScheduleController() {
        let vc = ScheduleViewController()
        vc.delegate = self
        let creatScheduleViewController = UINavigationController(rootViewController: vc)
        
        present(creatScheduleViewController,animated: true)
    }
    
    func showCategoryController() {
        let vc = CategoryViewController()
        let viewModel = CategoryViewModel()
        viewModel.delegate = self
        vc.viewModel = viewModel
        let creatCategoryViewController = UINavigationController(rootViewController: vc)
        present(creatCategoryViewController,animated: true)
    }
}

extension CreateNewTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCreateCell", for: indexPath) as? CollectionViewForCreateTrackerCell else { return UICollectionViewCell() }
        cell.tableView.delegate = self
        cell.textField.delegate = self
        cell.delegate = self
        cell.tableView.reloadData()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension CreateNewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let tableWithTwoElementsHeight: CGFloat = 150
        let tableWithOneElementsHeightOrTextField: CGFloat = 75
        let distanceBetweenTableViewAndCollectionView : CGFloat = 50
        let distanceBetweenElements: CGFloat = 24
        let warningHeight: CGFloat = 22
        let distanceBetweenElementsCollectionViewAndButtonCancel : CGFloat = 16
        if shared.isWarning{
            if shared.habitOrEvent == "Привычка" ||  shared.habitOrEvent == "Edit" {
                return CGSize(width: collectionView.bounds.width, height: tableWithOneElementsHeightOrTextField + distanceBetweenElements + tableWithTwoElementsHeight + distanceBetweenTableViewAndCollectionView + (collectionView.bounds.width/6) * 3 + (collectionView.bounds.width/6) * 3 + distanceBetweenElements * 4 + distanceBetweenElementsCollectionViewAndButtonCancel + warningHeight)
            }
            return CGSize(width: collectionView.bounds.width, height: tableWithOneElementsHeightOrTextField + distanceBetweenElements + tableWithOneElementsHeightOrTextField + distanceBetweenTableViewAndCollectionView + (collectionView.bounds.width/6) * 3 + (collectionView.bounds.width/6) * 3 + distanceBetweenElements * 4 + distanceBetweenElementsCollectionViewAndButtonCancel + warningHeight)
        }
        if shared.habitOrEvent == "Привычка" || shared.habitOrEvent == "Edit"{
            return CGSize(width: collectionView.bounds.width, height: tableWithOneElementsHeightOrTextField + distanceBetweenElements + tableWithTwoElementsHeight + distanceBetweenTableViewAndCollectionView + (collectionView.bounds.width/6) * 3 + (collectionView.bounds.width/6) * 3 + distanceBetweenElements * 4 + distanceBetweenElementsCollectionViewAndButtonCancel)
        }
        return CGSize(width: collectionView.bounds.width, height: tableWithOneElementsHeightOrTextField + distanceBetweenElements + tableWithOneElementsHeightOrTextField + distanceBetweenTableViewAndCollectionView + (collectionView.bounds.width/6) * 3 + (collectionView.bounds.width/6) * 3 + distanceBetweenElements * 4 + distanceBetweenElementsCollectionViewAndButtonCancel)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension CreateNewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            showScheduleController()
        }
        else{
            showCategoryController()
        }
    }
}

extension CreateNewTrackerViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        nameTracker = updatedText
        createButtonIsActiveCheck()
        return updatedText.count <= 38
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        createButtonIsActiveCheck()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        nameTracker = ""
        createButtonIsActiveCheck()
        return true
    }
}

extension CreateNewTrackerViewController: AddHabitDelegate{
    func setScheduleText(){
        collectionView.reloadData()
        createButtonIsActiveCheck()
    }
}

extension CreateNewTrackerViewController: CollectionViewForCreateTrackerCellDelegate {
    
    func setEmoji(emoji: String) {
        emojiTracker = emoji
        createButtonIsActiveCheck()
    }
    
    func setColor(color: UIColor) {
        colorTracker = color
        createButtonIsActiveCheck()
    }
    func changeSizeCollectionView(){
        collectionView.reloadData()
    }
}

extension CreateNewTrackerViewController: CategoryViewModelDelegate{
    func didNameCategory() {
        collectionView.reloadData()
        createButtonIsActiveCheck()
    }
    
}
