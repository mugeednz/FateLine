//
//  SplashViewController.swift
//  fateline
//
//  Created by Müge Deniz on 13.10.2025.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import FacebookCore

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkOnboardingStatus()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Add delay to ensure everything is properly loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestATTIfNeeded()
        }
    }
    
    func requestATTIfNeeded() {
        guard #available(iOS 14, *) else {
            print("📱 iOS < 14, tracking not required")
            return
        }
        
        // Check if tracking is already determined
        let currentStatus = ATTrackingManager.trackingAuthorizationStatus
        switch currentStatus {
        case .authorized:
            print("🔓 Already authorized")
            Settings.shared.isAdvertiserTrackingEnabled = true
            return
        case .denied, .restricted:
            print("❌ Already denied/restricted")
            return
        case .notDetermined:
            print("🕐 Requesting tracking authorization...")
        @unknown default:
            print("⚠️ Unknown tracking status")
            return
        }
        
        // Only request if not determined
        ATTrackingManager.requestTrackingAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("🔓 Tracking authorized")
                    Settings.shared.isAdvertiserTrackingEnabled = true
                case .denied:
                    print("❌ Tracking denied")
                    Settings.shared.isAdvertiserTrackingEnabled = false
                case .notDetermined:
                    print("🕐 Still not determined")
                case .restricted:
                    print("🚫 Tracking restricted")
                    Settings.shared.isAdvertiserTrackingEnabled = false
                @unknown default:
                    print("⚠️ Unknown status: \(status)")
                    Settings.shared.isAdvertiserTrackingEnabled = false
                }
            }
        }
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
