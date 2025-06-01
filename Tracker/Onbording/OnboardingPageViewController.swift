//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Maxim on 25.05.2025.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController  {
    
    private var positionYPageControl : CGFloat = 0
    
    lazy private var pages: [UIViewController] = {
        let firstOnboardingVC = OnboardingViewController()
        firstOnboardingVC.textLabel.text = "Отслеживайте только то, что хотите"
        firstOnboardingVC.imageOnboarding.image = UIImage(named: "1")
        
        let secondOnboardingVC = OnboardingViewController()
        secondOnboardingVC.textLabel.text = "Даже если это не литры воды и йога"
        secondOnboardingVC.imageOnboarding.image = UIImage(named: "2")
        
        positionYPageControl = firstOnboardingVC.BottomButtonY
        return [firstOnboardingVC,secondOnboardingVC]
    }()
    
    lazy private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .blackYP
        pageControl.pageIndicatorTintColor = .placeholderText
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI(){
        dataSource = self
        delegate = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -(positionYPageControl+60+50+24)).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension OnboardingPageViewController:UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
    
    
}

extension OnboardingPageViewController:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
