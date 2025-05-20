//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Maxim on 23.04.2025.
//

import UIKit
protocol AddHabitDelegate: AnyObject {
    func setScheduleText()
}

final class ScheduleViewController: UIViewController, UITableViewDelegate  {
    weak var delegate: AddHabitDelegate?
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        return tableView
    }()
    
    private let warningAboutExceedingTheNumberOfCharsactersLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        
        return label
    }()
    
    private let readyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .blackYP
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.tintColor = .whiteYP
        return button
    }()
    
    private let weekDays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    private let service = CreateNewTrackerAndScheduleServices.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc func readyAction(){
        dismiss(animated: true)
        delegate?.setScheduleText()
    }
    
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalToConstant: 75 * 7).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setReadyButton(){
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.addTarget(self, action: #selector(readyAction), for: .touchUpInside)
        view.addSubview(readyButton)
        readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        readyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setUI(){
        navigationItem.hidesBackButton = true
        view.backgroundColor = .whiteYP
        navigationItem.title = "Расписание"
        setTableView()
        setReadyButton()
    }
    
    private func configCell(for cell: ScheduleCell, with indexPath: IndexPath) {
        cell.dayTitle.text = weekDays[indexPath.row]
        for i in service.numberOfDays{
            if indexPath.row == i{
                cell.onOffSwitch.setOn(true, animated: true)
                break
            }
        }
        if indexPath.row == 6{
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
       
    }
    
}

extension ScheduleViewController: ScheduleCelldDelegate {
    func OnOffSwitchValueChanged(for cell: ScheduleCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if cell.onOffSwitch.isOn {
            service.addToSchdule(numberDays: indexPath.row)
        }
        else{
            service.removeFromSchdule(numberDays: indexPath.row)
        }
    }
       
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)  as? ScheduleCell else
        {
            return UITableViewCell()
        }
        cell.delegate = self
        configCell(for: cell, with: indexPath)
        return cell
    }
    
}
