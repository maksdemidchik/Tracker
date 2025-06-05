//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Maxim on 25.05.2025.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private var service = OnboardingService.shared
    
    private var button : UIButton = {
        let button = UIButton()
        let text = NSLocalizedString("ButtonOnboarding", comment: "ButtonOnboarding")
        button.setTitle(text, for: .normal)
        button.tintColor = .colorSelection10
        button.backgroundColor = .blackYP
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.isHidden = false
        return button
    }()
    
    var BottomButtonY : CGFloat = 0
    
    var imageOnboarding = UIImageView()
    
    var textLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .blackYP
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        view.backgroundColor = .white
    }
    
    @objc private func buttonTapped() {
        service.isOnboardingCompleted = true
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true) {
            DispatchQueue.main.async {
                guard let window = UIApplication.shared.windows.first else { return }
                window.rootViewController = vc
            }
        }
    }
    
    private func setButton(){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        BottomButtonY = button.frame.minY
    }
    private func setLabel(){
        view.addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 388).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16).isActive = true
    }
    
    private func setImageView(){
        imageOnboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageOnboarding)
        imageOnboarding.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageOnboarding.leadingAnchor.constraint(equalTo: view.leadingAnchor ).isActive = true
        imageOnboarding.trailingAnchor.constraint(equalTo: view.trailingAnchor ).isActive = true
        imageOnboarding.bottomAnchor.constraint(equalTo: view.bottomAnchor ).isActive = true
    }
    
    private func setUI(){
        setImageView()
        setButton()
        setLabel()
    }
    
}
