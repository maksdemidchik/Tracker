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

final class ChoosingCategoryOrHabit: UIViewController, UINavigationControllerDelegate {
    
    weak var delegate: TrackersViewControllerDelegate?
    
    private let habitButton: UIButton = {
        let button = UIButton(type: .system)
        let text = NSLocalizedString("buttomHabbitText", comment: "buttomHabbitText")
        button.setTitle(text, for: .normal)
        return button
    }()
    
    private let irrgularButton: UIButton = {
        let button = UIButton(type: .system)
        let text = NSLocalizedString("buttomNewIrregularEventText", comment: "buttonIrregularEvent")
        button.setTitle(text, for: .normal)
        return button
    }()
    private let shared = CreateNewTrackerAndScheduleServices.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc private func habitAction(){
        showNextController(name: "Привычка")
    }
    
    @objc private func action(){
        showNextController(name: "Нерегулярное событие")
    }
    private func showNextController(name: String){
        shared.habitOrEventName(name)
        let vc = CreateNewTrackerViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func setHabitButton(){
        habitButton.addTarget(self, action: #selector(habitAction), for: .touchDown)
        generalAtThePositionOfTheButtons(button: habitButton, float: 281)
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
        let text = NSLocalizedString("CreateTrackerText", comment: "CreateTrackerText")
        navigationItem.title = text
        view.backgroundColor = .whiteYP
        setHabitButton()
        setIrregularEvents()
    }
}

extension ChoosingCategoryOrHabit: CreatingTrackerViewControllerDelegate {
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
