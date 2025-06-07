//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Maxim on 21.04.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarViewControllerSettings()
    }
    
    private func setLine(){
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .line
        tabBar.addSubview(line)
        
        line.topAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.2).isActive = true
    }
    
    private func setTabBarViewControllerSettings(){
        let vc = TrackersViewController()
        let rootVc = UINavigationController(rootViewController: vc)
        let trackerText = NSLocalizedString("trackerText", comment: "trackerText")
        rootVc.tabBarItem = UITabBarItem(title: trackerText, image: UIImage(named: "Property 1=trackers"), tag: 0)
        let statistikViewController = StatistikViewController()
        let statistikText = NSLocalizedString("statistikText", comment: "statistikText")
        statistikViewController.tabBarItem = UITabBarItem(title: statistikText, image: UIImage(named: "Property 1=stats"), tag: 0)
        viewControllers = [rootVc, statistikViewController]
        setLine()
    }
    
}
