//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Maxim on 21.04.2025.
//

import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func didAppendTracker(tracker: Tracker,category: String)
    func returnSelectedDayInt() -> Int
}

final class TrackersViewController: UIViewController,  UINavigationControllerDelegate {
    private var currentDate: Date = Date()
    
    private var todayDate: Date = Date()
    
    private var name = ""
    
    private var categories: [TrackerCategory] = []
    
    private var currentcCategories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var searchBarText = ""
    
    private let searchBar: UISearchController = {
        let searchBar = UISearchController()
        return searchBar
    }()
    
    private let collectionView :UICollectionView = {
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CollectionViewCellForTrackers.self, forCellWithReuseIdentifier: "CollectionTrackerCell")
        collectionView.register(HeadersCollectionViewCellForTrackers.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return collectionView
    }()
    
    private let dataPicker: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .compact
        return dataPicker
    }()
    
    private let plugText : UILabel = {
        let label = UILabel()
        let text = NSLocalizedString("textPlaceholder", comment: "Placeholder text")
        label.text = text
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
    
    private var plusButton : UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var stackView = UIStackView()
    
    private lazy var selectedDayInt: Int = {
        let weekdayInt = Calendar.current.component(.weekday, from: dataPicker.date)
        return weekdayInt
    }()
    
    private lazy var trackerStore = TrackerStore()
    
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        categories = trackerCategoryStore.getTracker()
        trackerStore.delegate = self
        setCurrentDayCollections()
        completedTrackers = trackerStore.getCompletedTrackers()
        trackerCategoryStore.delegate = self
    }
    
    @objc private func plusButtonAction(){
        let vc = ChoosingCategoryOrHabit()
        vc.delegate = self
        let vc1 = UINavigationController(rootViewController: vc)
        present(vc1,animated: true)
    }
    
    @objc private func changeDate(_ sender: UIDatePicker){
        let date = sender.date
        let weekdayInt = Calendar.current.component(.weekday, from: date)
        selectedDayInt = weekdayInt
        currentDate = date
        setCurrentDayCollections()
        collectionView.reloadData()
    }
    
    private func setUpSearchAndPlusButtonAndDataPickerUI(){
        let plusButton1 = UIBarButtonItem(image:UIImage(named: "plus"),style: .plain, target: self, action: #selector(self.plusButtonAction))
        plusButton1.tintColor = .blackYP
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let textTracker = NSLocalizedString("trackerText", comment: "tracker")
        navigationController?.navigationBar.topItem?.title = textTracker
        navigationController?.navigationBar.topItem?.leftBarButtonItem = plusButton1
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: dataPicker)
        dataPicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        navigationController?.navigationBar.backgroundColor = .whiteYP
        
        let searchText = NSLocalizedString("searchText", comment: "search")
        navigationController?.navigationBar.topItem?.searchController = searchBar
        searchBar.searchBar.placeholder = searchText
        searchBar.searchBar.delegate = self
    }
    
    private func setCollectionView(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant: 24).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.backgroundColor = .whiteYP
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
        setUpPlaceholder()
        setUpSearchAndPlusButtonAndDataPickerUI()
        setCollectionView()
        collectionView.isHidden = currentcCategories.count == 0
    }
    
    private func setCurrentDayCollections(){
        currentcCategories = []
        var x1=0
        for i in 0..<categories.count {
            var trackerList : [Tracker] = []
            var check = 0
            for z in 0..<categories[i].tracker.count {
                for y in 0..<categories[i].tracker[z].schedule.count {
                    if categories[i].tracker[z].schedule[y] == selectedDayInt && (searchBarText.count == 0 || categories[i].tracker[z].name.lowercased().contains(searchBarText.lowercased())){
                        trackerList.append(categories[i].tracker[z])
                        let newCategory = TrackerCategory(categoryName:categories[i].categoryName , tracker: trackerList)
                        if check == 0 {
                            currentcCategories.append(newCategory)
                        }
                        else{
                            currentcCategories[x1] = newCategory
                        }
                        check+=1
                    }
                    else if categories[i].tracker[z].schedule[0] == 0 {
                        let tracker = Tracker(id: categories[i].tracker[z].id, color: categories[i].tracker[z].color, name: categories[i].tracker[z].name, emoji: categories[i].tracker[z].emoji, schedule: [selectedDayInt], dateOfAddition: Date())
                        trackerList.append(tracker)
                        let newCategory = TrackerCategory(categoryName:categories[i].categoryName , tracker: trackerList)
                        if check == 0 {
                            currentcCategories.append(newCategory)
                        }
                        else{
                            currentcCategories[x1] = newCategory
                        }
                        check+=1
                    }
                }
            }
            if check != 0{
                x1+=1
            }
        }
        collectionView.reloadData()
        collectionView.isHidden = x1 == 0
    }
    
    private func configCell(cell: CollectionViewCellForTrackers,indexPath: IndexPath){
        let id = currentcCategories[indexPath.section].tracker[indexPath.row].id
        cell.emojiLabel.text = currentcCategories[indexPath.section].tracker[indexPath.row].emoji
        cell.namesTrackers.text = currentcCategories[indexPath.section].tracker[indexPath.row].name
        cell.nameAndEmojiView.backgroundColor = currentcCategories[indexPath.section].tracker[indexPath.row].color
        cell.button.backgroundColor = currentcCategories[indexPath.section].tracker[indexPath.row].color
        cell.color = currentcCategories[indexPath.section].tracker[indexPath.row].color
        cell.setImageButton(isCompleted: isComplete(id: id))
        cell.trackerID = id
        let number = countIfCompleted(id: id)
        let dayText = String.localizedStringWithFormat(NSLocalizedString("numberOfdays", comment: "dayCountCompleted"), number)
        cell.daylabel.text = dayText
        cell.delegate = self
    }
    
    private func isComplete(id:UUID) -> Bool {
        for i in 0..<completedTrackers.count {
            if completedTrackers[i].id == id && idSameDate(date: completedTrackers[i].date){
                return true
            }
        }
        return false
    }
    
    private func idSameDate(date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: currentDate)
    }
    
    private func countIfCompleted(id: UUID) -> Int {
        var count: Int = 0
        for i in 0..<completedTrackers.count {
            if completedTrackers[i].id == id {
                count += 1
            }
        }
        return count
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && currentcCategories.count == 0 {
            return 0
        }
        return currentcCategories[section].tracker.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionTrackerCell" , for: indexPath) as? CollectionViewCellForTrackers else {
            return UICollectionViewCell()
        }
        configCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? HeadersCollectionViewCellForTrackers {
            header.titleLabel.text = currentcCategories[indexPath.section].categoryName
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentcCategories.count
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-32-9)/2, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 9
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
}

extension TrackersViewController: TrackersViewControllerDelegate {
    func returnSelectedDayInt() -> Int {
        return selectedDayInt
    }
    
    func didAppendTracker(tracker: Tracker,category: String) {
        trackerStore.addNewTracker(tracker: tracker, category: category)
    }
    
}

extension TrackersViewController: CollectionViewCellForTrackersDelegate {
    func didTapButton(id: UUID) {
        if idSameDate(date: todayDate) || todayDate>currentDate{
            trackerStore.addOrDeleteTrackerRecord(id: id,date: currentDate,isComplete:isComplete(id: id))
        }
        
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            searchBarText = text
            setCurrentDayCollections()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarText = ""
        setCurrentDayCollections()
    }
    
}
extension TrackersViewController: TrackerCategoryStoreDelegate{
    func getCategories() {
        categories = trackerCategoryStore.getTracker()
        setCurrentDayCollections()
    }
}
extension TrackersViewController:TrackerStoreDelegate{
    func changeRecordValue(completedTrackers: [TrackerRecord]) {
        self.completedTrackers = completedTrackers
        collectionView.reloadData()
    }
    
}
