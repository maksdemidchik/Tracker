//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Maxim on 30.05.2025.
//

import Foundation

protocol CategoryViewModelDelegate: AnyObject {
    func didNameCategory()
}

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    private let service = CreateNewTrackerAndScheduleServices.shared
    
    weak var delegate: CategoryViewModelDelegate?
    
    var didChangeCountCategories: Binding<Bool>?
    
    var categoryIsChoose: Binding<Bool>?
    
    lazy var model : TrackerCategoryStore = {
        let model = TrackerCategoryStore()
        return model
    }()
    
    func getCategories() -> [String] {
        return model.getGategories()
    }
    
    func getCountCategories() -> Int {
        return model.getGategories().count
    }
    
    func addNewCategory(name: String) {
        model.addNewCategory(name: name)
        didChangeCountCategories?(true)
    }
    
    func chooseCategory(currentIndexPath: IndexPath) {
        service.setIndexPathAndNameCategory(indexPath: currentIndexPath, nameCategory: model.getGategories()[currentIndexPath.row])
        delegate?.didNameCategory()
        categoryIsChoose?(true)
    }
    
    func checkNeedACheckmark(currentIndexPath: IndexPath) -> Bool {
        return getCurrentIndexPath()?.row == currentIndexPath.row
    }
    
    func getCurrentIndexPath() -> IndexPath? {
        return service.currentIndexPath
    }
    
    func getPreviousIndexPath() -> IndexPath? {
        return service.previousIndexPath
    }
    
}
