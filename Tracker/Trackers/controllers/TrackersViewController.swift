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
    
    private lazy var filterCategories: [String] = [
        NSLocalizedString("allTrackers", comment: "allTrackers"),
        NSLocalizedString("trackersForToday", comment: "trackersForToday"),
        NSLocalizedString("completed", comment: "completed"),
        NSLocalizedString("notCompleted", comment: "notCompleted")
    ]
    
    private var todayDate: Date = Date()
    
    private var placeholderSearchBar = false
    
    private var name = ""
    private var moreTwoSymbol = false
    
    private var selectedFilterCategory: String {
        get{
            UserDefaults.standard.string(forKey: "selectedFilterCategory") ?? filterCategories[0]
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "selectedFilterCategory")
        }
    }
    
    private var categories: [TrackerCategory] = []
    
    private var currentCategories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var searchBarText = ""
    
    private let searchBar: UISearchController = {
        let searchBar = UISearchController()
        return searchBar
    }()
    
    private let analytics = AnalyticsService.shared
    
    private let collectionView :UICollectionView = {
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CollectionViewCellForTrackers.self, forCellWithReuseIdentifier: "CollectionTrackerCell")
        collectionView.register(HeadersCollectionViewCellForTrackers.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("filters", comment: "filters"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .blueYP
        return button
    }()
    
    private let dataPicker: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .compact
        dataPicker.backgroundColor = .white
        dataPicker.layer.cornerRadius = 8
        dataPicker.layer.masksToBounds = true
        dataPicker.overrideUserInterfaceStyle = .light
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
    
    override func viewDidAppear(_ animated: Bool) {
        analytics.reportEvent("open", parameters: ["screen" : "Main"])
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        categories = trackerCategoryStore.getTracker()
        trackerStore.delegate = self
        trackersAfterFilters(selectedFilterCategory)
        completedTrackers = trackerStore.getCompletedTrackers()
        trackerCategoryStore.delegate = self
        placeholderSearchBar = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        analytics.reportEvent("close", parameters: ["screen" : "Main"])
        super.viewDidDisappear(animated)
    }
    
    @objc private func plusButtonAction(){
        analytics.reportEvent("click", parameters: ["screen" : "Main", "item": "add_track"])
        let vc = ChoosingCategoryOrHabit()
        vc.delegate = self
        let vc1 = UINavigationController(rootViewController: vc)
        present(vc1,animated: true)
    }
    @objc private func filterButtonAction(){
        analytics.reportEvent("click", parameters: ["screen" : "Main", "item": "filter"])
        let vc = FilterViewController(filterCategory: selectedFilterCategory, delegate: self)
        let vc1 = UINavigationController(rootViewController: vc)
        present(vc1,animated: true)
    }
    
    @objc private func changeDate(_ sender: UIDatePicker){
        let date = sender.date
        actionWhenChangingTheDate(date: date)
        placeholderSearchBar = false
        trackersAfterFilters(selectedFilterCategory)
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
    
    private func setFilterButton(){
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        view.addSubview(filterButton)
        filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 114).isActive = true
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
        setFilterButton()
    }
    
    private func setCurrentDayCollections(){
        searchCurrentDayCategories()
        collectionView.reloadData()
        isHiddenCollectionView(count: currentCategories.count)
    }

    private func searchCurrentDayCategories(){
        currentCategories = []
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
                            currentCategories.append(newCategory)
                        }
                        else{
                            currentCategories[x1] = newCategory
                        }
                        check+=1
                    }
                    else if categories[i].tracker[z].schedule[0] == 0 {
                        let tracker = Tracker(id: categories[i].tracker[z].id, color: categories[i].tracker[z].color, name: categories[i].tracker[z].name, emoji: categories[i].tracker[z].emoji, schedule: [selectedDayInt], dateOfAddition: Date(), isItPinned: false)
                        trackerList.append(tracker)
                        let newCategory = TrackerCategory(categoryName:categories[i].categoryName , tracker: trackerList)
                        if check == 0 {
                            currentCategories.append(newCategory)
                        }
                        else{
                            currentCategories[x1] = newCategory
                        }
                        check+=1
                    }
                }
            }
            if check != 0{
                x1+=1
            }
        }
    }
    
    private func isHiddenCollectionView(count:Int){
        collectionView.isHidden = currentCategories.count == 0
        filterButton.isHidden = count == 0
        let nameImage = filterButton.isHidden == false || placeholderSearchBar == true  ? "placeholder SearchBar" : "placeholder"
        let textPlaceholder = filterButton.isHidden == false || placeholderSearchBar == true ? NSLocalizedString("placeholderSearchBar", comment: "Placeholder text") : NSLocalizedString("textPlaceholder", comment: "Placeholder text")
        imagePlaceholder.image = UIImage(named: nameImage)
        plugText.text = textPlaceholder
    }
    
    private func configCell(cell: CollectionViewCellForTrackers,indexPath: IndexPath){
        let id = currentCategories[indexPath.section].tracker[indexPath.row].id
        cell.emojiLabel.text = currentCategories[indexPath.section].tracker[indexPath.row].emoji
        cell.namesTrackers.text = currentCategories[indexPath.section].tracker[indexPath.row].name
        cell.nameAndEmojiView.backgroundColor = currentCategories[indexPath.section].tracker[indexPath.row].color
        cell.button.backgroundColor = currentCategories[indexPath.section].tracker[indexPath.row].color
        cell.color = currentCategories[indexPath.section].tracker[indexPath.row].color
        cell.setImageButton(isCompleted: isComplete(id: id))
        cell.trackerID = id
        let number = countIfCompleted(id: id)
        let dayText = String.localizedStringWithFormat(NSLocalizedString("numberOfdays", comment: "dayCountCompleted"), number)
        cell.daylabel.text = dayText
        cell.delegate = self
        cell.isItPin = currentCategories[indexPath.section].tracker[indexPath.row].isItPinned
        cell.pinEmojiView.isHidden = !currentCategories[indexPath.section].tracker[indexPath.row].isItPinned
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
    
    private func editingTheTracker(id:UUID,category:String,trackerCategory:TrackerCategory){
        var indexCategory = -1
        var indexTracker = -1
        let categoryIsSame = category == trackerCategory.categoryName
        for i in 0..<currentCategories.count {
            var trackers = currentCategories[i].tracker
            for j in 0..<currentCategories[i].tracker.count {
                if currentCategories[i].tracker[j].id == id && trackerCategory.categoryName == category {
                    trackers.remove(at: j)
                    trackers.insert(trackerCategory.tracker[0], at: j)
                    currentCategories[i] = TrackerCategory(categoryName: category, tracker: trackers)
                    return
                }
                else if currentCategories[i].tracker[j].id == id && trackerCategory.categoryName != category {
                    indexCategory = i
                    indexTracker = j
                }
                else if currentCategories[i].categoryName == trackerCategory.categoryName{
                    let newTrackers = currentCategories[i].tracker
                    currentCategories[i] = TrackerCategory(categoryName: trackerCategory.categoryName, tracker: newTrackers+trackerCategory.tracker)
                }
            }
        }
        if categoryIsSame == false{
            var trackers = currentCategories[indexCategory].tracker
            trackers.remove(at: indexTracker)
            currentCategories[indexCategory] = TrackerCategory(categoryName: category, tracker: trackers)
        }
    }
    
    private func actionWhenChangingTheDate(date:Date){
        let weekdayInt = Calendar.current.component(.weekday, from: date)
        selectedDayInt = weekdayInt
        currentDate = date
    }
    
    private func ifTheFilterCategoryCompletedOrUnCompleted(completedOrUnCompleted:String){
        var newCurrentcCategories: [TrackerCategory] = []
        let bool = completedOrUnCompleted == filterCategories[2] ? true : false
        for i in 0..<currentCategories.count{
            var trackers: [Tracker] = []
            for z in 0..<currentCategories[i].tracker.count{
                if isComplete(id: currentCategories[i].tracker[z].id) == bool{
                    trackers.append(currentCategories[i].tracker[z])
                }
            }
            if trackers.count > 0 {
                let NewTrackerCategory = TrackerCategory(categoryName: currentCategories[i].categoryName, tracker: trackers)
                newCurrentcCategories.append(NewTrackerCategory)
            }
        }
        currentCategories = newCurrentcCategories
        collectionView.reloadData()
    }
    
    private func trackersAfterFilters(_ filterCategory: String){
        searchCurrentDayCategories()
        let count = currentCategories.count
        if filterCategory != filterCategories[1]{
            selectedFilterCategory = filterCategory
            if selectedFilterCategory == filterCategories[0]{
                setCurrentDayCollections()
            }
            else{
                ifTheFilterCategoryCompletedOrUnCompleted(completedOrUnCompleted: selectedFilterCategory)
            }
            isHiddenCollectionView(count: count)
            if !placeholderSearchBar{
                print(count)
                placeholderSearchBar = count > 0
            }
        }
        else{
            selectedFilterCategory = filterCategories[0]
            dataPicker.date = Date()
            actionWhenChangingTheDate(date: Date())
            setCurrentDayCollections()
        }
        
    }
    
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && currentCategories.count == 0 {
            return 0
        }
        return currentCategories[section].tracker.count
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
            header.titleLabel.text = currentCategories[indexPath.section].categoryName
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentCategories.count
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
        if section == currentCategories.count-1{
            return UIEdgeInsets(top: 0, left: 16, bottom: 66, right: 16)
        }
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
    func editTracker(id: UUID) {
        analytics.reportEvent("click", parameters: ["screen" : "Main", "item": "edit"])
        let tracker = trackerCategoryStore.getTrackerAndCategoryName(id: id)
        let vc = EditTrackerViewController(tracker: tracker,delegate: self,count:countIfCompleted(id: id))
        let vc1 = UINavigationController(rootViewController: vc)
        present(vc1,animated: true)
    }
    
    func pinnedOrUnpinned(id: UUID) {
        trackerStore.trackerPinnedOrUnpinned(id: id)
        categories = trackerCategoryStore.getTracker()
        setCurrentDayCollections()
    }
    
    func deleteTrecker(id: UUID) {
        analytics.reportEvent("click", parameters: ["screen" : "Main", "item": "delete"])
        let alertText = NSLocalizedString("textDeleteAlert", comment: "textDeleteAlert")
        let alert = UIAlertController(title: alertText, message: nil, preferredStyle: .actionSheet)
        let deleteText = NSLocalizedString("delete", comment: "delete")
        let delete = UIAlertAction(title: deleteText, style: .destructive){[weak self] _ in
            guard let self = self else { return }
            self.trackerStore.deleteTracker(id: id)
            
        }
        let cancelText = NSLocalizedString("cancel", comment: "cancel")
        let cancel = UIAlertAction(title: cancelText, style: .cancel){ _ in }
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func didTapButton(id: UUID) {
        analytics.reportEvent("click", parameters: ["screen" : "Main", "item": "track"])
        if idSameDate(date: todayDate) || todayDate>currentDate{
            trackerStore.addOrDeleteTrackerRecord(id: id,date: currentDate,isComplete:isComplete(id: id))
        }
        
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            searchBarText = text
            if searchBarText.count == 1 && !moreTwoSymbol{
                if !placeholderSearchBar{
                    placeholderSearchBar = currentCategories.count > 0
                }
            }
            else if searchBarText.count == 2{
                moreTwoSymbol = true
            }
            else if searchBarText.count == 0{
                placeholderSearchBar = false
            }
            trackersAfterFilters(selectedFilterCategory)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarText = ""
        moreTwoSymbol = false
        placeholderSearchBar = false
        trackersAfterFilters(selectedFilterCategory)
    }
    
}
extension TrackersViewController: TrackerCategoryStoreDelegate{
    func getCategories() {
        categories = trackerCategoryStore.getTracker()
        setCurrentDayCollections()
    }
}
extension TrackersViewController:TrackerStoreDelegate{
    
    func changeRecordValue(completedTrackers: [TrackerRecord],changeSchedule:Bool) {
        self.completedTrackers = completedTrackers
        categories = trackerCategoryStore.getTracker()
        if changeSchedule{
            setCurrentDayCollections()
        }
        else{
            if selectedFilterCategory == filterCategories[0] || selectedFilterCategory == filterCategories[1]{
                collectionView.reloadData()
            }
            else{
                trackersAfterFilters(selectedFilterCategory)
            }
        }
    }
    
}

extension TrackersViewController: EditTrackerViewControllerDelegate{
    
    func editNewTracker(id: UUID,oldCategory:String,TrackerCategory:TrackerCategory) {
        editingTheTracker(id: id, category: oldCategory, trackerCategory: TrackerCategory)
        trackerStore.editTracker(id: id, oldCategory: oldCategory, newCategory: TrackerCategory.categoryName, trackerEdit: TrackerCategory.tracker[0])
    }
}

extension TrackersViewController: FilterViewControllerDelegate {
    
    func didSelectFilterCategory(_ filterCategory: String) {
        trackersAfterFilters(filterCategory)
    }
    
}
