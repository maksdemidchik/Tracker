//
//  StatistikViewController.swift
//  Tracker
//
//  Created by Maxim on 21.04.2025.
//

import UIKit

final class StatistikViewController: UIViewController {
    
    private let storageRecord = TrackerRecordStore()
    
    private var stackView = UIStackView()
    
    private let plugText : UILabel = {
        let label = UILabel()
        let text = NSLocalizedString("textPlaceholderStatistik", comment: "Placeholder text")
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        label.textAlignment = .center
        return label
    }()
    
    private let imagePlaceholder : UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(named: "placeholder Statistik")
        imgView.image = img
        return imgView
    }()
    
    private let nameStatistikLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        let statistikText = NSLocalizedString("statistikText", comment: "statistikText")
        label.text = statistikText
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let completedTrackersLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        let text = NSLocalizedString("trackersCompleted", comment: "trackersCompleted")
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var card = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 90))
    
    private var completedTrackersCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blackYP
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        completedTrackersCountLabel.text = String(storageRecord.getAllTrackerRecords().count)
        if storageRecord.getAllTrackerRecords().count > 0{
            stackView.isHidden = true
            card.isHidden = false
        }
        else{
            card.isHidden = true
            stackView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteYP
        setUI()
    }
    
    private func setNameStatistikLabel(){
        nameStatistikLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameStatistikLabel)
        nameStatistikLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        nameStatistikLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameStatistikLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        nameStatistikLabel.heightAnchor.constraint(equalToConstant: 41).isActive = true
    }
    
    private func setCard(){
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)
        card.topAnchor.constraint(equalTo: nameStatistikLabel.bottomAnchor, constant: 77).isActive = true
        card.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        card.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        card.heightAnchor.constraint(equalToConstant: 90).isActive = true
        card.layer.masksToBounds = false
        card.layer.cornerRadius = 16
        setGradient(view: card)
    }
    
    private func setCompletedTrackersLabel(){
        completedTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(completedTrackersLabel)
        completedTrackersLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12).isActive = true
        completedTrackersLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12).isActive = true
        completedTrackersLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12).isActive = true
    }
    
    private func setCompletedTrackersCountLabel(){
        completedTrackersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(completedTrackersCountLabel)
        completedTrackersCountLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12).isActive = true
        completedTrackersCountLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12).isActive = true
        completedTrackersCountLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12).isActive = true
    }
    
    private func setStackView(){
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
        setNameStatistikLabel()
        setCard()
        setCompletedTrackersCountLabel()
        setCompletedTrackersLabel()
        setStackView()
    }
    
    private func setGradient(view:UIView){
        let borderWidth: CGFloat = 2
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let firstGradientColor = UIColor(named: "Color selection 1")?.cgColor ?? UIColor.clear.cgColor
        let twoGradientColor = UIColor(named: "Color selection 9")?.cgColor ?? UIColor.clear.cgColor
        let threeGradientColor = UIColor(named: "Color selection 3")?.cgColor ?? UIColor.clear.cgColor
        let colors: [CGColor] = [firstGradientColor, twoGradientColor, threeGradientColor]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 16
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 16).cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = nil
        gradientLayer.mask = shapeLayer
        view.layer.addSublayer(gradientLayer)
    }
    
    
}
