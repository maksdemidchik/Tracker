//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Maxim on 07.06.2025.
//

import UIKit

protocol EditTrackerViewControllerDelegate: AnyObject {
    func editNewTracker(id: UUID,oldCategory:String,TrackerCategory:TrackerCategory)
}

final class EditTrackerViewController: UIViewController {
    
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
    
    private let saveButton : UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        let text = NSLocalizedString("save", comment: "save")
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
    
    private var trackerId = UUID()
    
    private var nameTracker = ""
    
    private var isFixed = false
    
    private var textBeforeWarning = ""
    
    private var dateOfAddition = Date()
    
    private var emojiTracker : String = ""
    
    private var schedule = [Int]()
    
    private var colorTracker : UIColor? = nil
    
    private var category = ""
    
    private lazy var dataCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    weak var delegate: EditTrackerViewControllerDelegate?
    
    init(tracker: TrackerCategory,delegate:EditTrackerViewControllerDelegate,count:Int) {
        self.trackerId = tracker.tracker[0].id
        self.nameTracker = tracker.tracker[0].name
        self.emojiTracker = tracker.tracker[0].emoji
        self.colorTracker = tracker.tracker[0].color
        self.dateOfAddition = tracker.tracker[0].dateOfAddition
        self.schedule = tracker.tracker[0].schedule
        self.isFixed = tracker.tracker[0].isItPinned
        self.category = tracker.categoryName
        shared.setTrackerAndCategoryName(tracker: tracker.tracker[0], name: category)
        shared.habitOrEventName("Edit")
        self.delegate = delegate
        let dayText = String.localizedStringWithFormat(NSLocalizedString("numberOfdays", comment: "dayCountCompleted"), count)
        super.init(nibName: nil, bundle: nil)
        dataCountLabel.text = dayText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        shared.setNilIndexPath()
        shared.deletedWarning()
    }
    
    @objc private func cancelAction(){
        shared.remove()
        dismiss(animated: true)
    }
    
    @objc private func saveButtonAction(){
        let schedule = shared.numberOfDaysForDateInt
        guard let color = colorTracker else { return }
        let newTracker = Tracker(id: trackerId,color: color, name: nameTracker, emoji: emojiTracker, schedule: schedule, dateOfAddition: dateOfAddition, isItPinned: isFixed)
        delegate?.editNewTracker(id: trackerId, oldCategory: category, TrackerCategory: TrackerCategory(categoryName: shared.curruntCategory, tracker: [newTracker]))
        dismiss(animated: true)
    }
    
    private func setSaveButton(){
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchDown)
        view.addSubview(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
    }
    
    private func setCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchDown)
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    private func setDataCountLabel(){
        dataCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataCountLabel)
        dataCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 24).isActive = true
        dataCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16).isActive = true
        dataCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16).isActive = true
    }
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: dataCountLabel.bottomAnchor,constant: 40).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor,constant: -16).isActive = true
    }
    
    private func setUI(){
        setDataCountLabel()
        setCancelButton()
        setSaveButton()
        setCollectionView()
        view.backgroundColor = .whiteYP
        let text = NSLocalizedString("EditingHabit", comment: "EditingHabit")
        navigationItem.title = text
        navigationItem.hidesBackButton = true
    }
    
    private func createButtonIsActiveCheck(){
        if nameTracker.count > 0 && emojiTracker.count > 0  && colorTracker != nil && shared.curruntCategory != "" && shared.schdule.count > 0 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = .blackYP
            saveButton.setTitleColor(.whiteYP, for: .normal)
        }
        else{
            createButtonIsNotActive()
        }
    }
    
    private func createButtonIsNotActive(){
        saveButton.isEnabled = false
        saveButton.backgroundColor = .grayYP
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

extension EditTrackerViewController: UICollectionViewDataSource {
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

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
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

extension EditTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            showScheduleController()
        }
        else{
            showCategoryController()
        }
    }
}

extension EditTrackerViewController: UITextFieldDelegate{
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

extension EditTrackerViewController: AddHabitDelegate{
    func setScheduleText(){
        collectionView.reloadData()
        createButtonIsActiveCheck()
    }
}

extension EditTrackerViewController: CollectionViewForCreateTrackerCellDelegate {
    
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

extension EditTrackerViewController: CategoryViewModelDelegate{
    func didNameCategory() {
        collectionView.reloadData()
        createButtonIsActiveCheck()
    }
    
}
