//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Maxim on 21.04.2025.
//

import UIKit

protocol CreatingTrackerViewControllerDelegate : AnyObject {
    func dismissAndCreateCategory(tracker: Tracker,category: String)
    func currentDateInt() -> Int
}

final class CreatingTrackerViewController: UIViewController, UINavigationControllerDelegate {
    weak var delegate: TrackersViewControllerDelegate?
    
    private let habbitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        return button
    }()
    
    private let irrgularButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc func habitAction(){
        let vc = AddHabitViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func action(){
        let vc = AddNewIrregularEventViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setHabbitButton(){
        habbitButton.addTarget(self, action: #selector(habitAction), for: .touchDown)
        generalAtThePositionOfTheButtons(button: habbitButton, float: 281)
    }
    
    private func setIrregularEvents(){
        irrgularButton.addTarget(self, action: #selector(action), for: .touchDown)
        generalAtThePositionOfTheButtons(button: irrgularButton, float: 357)
    }
    
    private func generalAtThePositionOfTheButtons(button:UIButton,float:CGFloat){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackYP
        button.tintColor = .whiteYP
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:float).isActive = true
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setUI(){
        navigationItem.title = "Создание трекера"
        view.backgroundColor = .whiteYP
        setHabbitButton()
        setIrregularEvents()
    }
}

extension CreatingTrackerViewController: CreatingTrackerViewControllerDelegate {
    func currentDateInt() -> Int {
        guard let dateInt = self.delegate?.returnSelectedDayInt() else {
            return 0
        }
        return dateInt
    }
    
    func dismissAndCreateCategory(tracker: Tracker,category: String) {
        self.delegate?.didAppendTracker(tracker: tracker, category: category)
    }
}
