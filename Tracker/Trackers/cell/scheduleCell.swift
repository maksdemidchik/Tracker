//
//  scheduleCell.swift
//  Tracker
//
//  Created by Maxim on 23.04.2025.
//

import UIKit

protocol ScheduleCelldDelegate: AnyObject {
    func OnOffSwitchValueChanged(for cell: ScheduleCell)
}

final class ScheduleCell: UITableViewCell {
    weak var delegate: ScheduleCelldDelegate?
    
    let dayTitle = UILabel()
    
    let onOffSwitch = UISwitch()
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        contentView.backgroundColor = .textField
        accessoryType = .none
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchValueDidChange(for cell: ScheduleCell){
        delegate?.OnOffSwitchValueChanged(for: self)
    }
    
    private func setDayTitleUI(){
        dayTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayTitle)
        dayTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        dayTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setOnOffSwitchUI(){
        onOffSwitch.translatesAutoresizingMaskIntoConstraints = false
        onOffSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        contentView.addSubview(onOffSwitch)
        onOffSwitch.onTintColor = .blue
        onOffSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        onOffSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setUI(){
        setDayTitleUI()
        setOnOffSwitchUI()
    }
    
}
