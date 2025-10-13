//
//  SplashViewController.swift
//  fateline
//
//  Created by Müge Deniz on 13.10.2025.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkOnboardingStatus()
    }
    
    func checkOnboardingStatus() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            navigateToHome()
        } else {
            navigateToOnboarding()
        }
    }
    
    func navigateToHome() {
        GlobalHelper.pushController(id: "MainViewController", self) { vc in }
        
    }
    
    func navigateToOnboarding() {
        GlobalHelper.pushController(id: "OnboardingOneViewController", self) { vc in
            (vc as? OnboardingOneViewController)?.navigationItem.hidesBackButton = true
        }

    }
}
