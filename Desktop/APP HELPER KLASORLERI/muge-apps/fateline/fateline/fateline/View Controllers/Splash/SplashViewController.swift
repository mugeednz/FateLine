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
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
        // Remove existing gradient if any
        gradientLayer?.removeFromSuperlayer()
        
        // Create gradient layer (same as MainViewController)
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor.mainBackgroundTop.cgColor,
            UIColor.mysticalPurple.cgColor,
            UIColor.mainBackgroundBottom.cgColor
        ]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // Insert gradient at the bottom
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // First request ATT, then navigate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestATTIfNeeded()
        }
    }
    
    func requestATTIfNeeded() {
        guard #available(iOS 14, *) else {
            print("📱 iOS < 14, tracking not required")
            // Navigate immediately for iOS < 14
            checkOnboardingStatus()
            return
        }
        
        // Check if tracking is already determined
        let currentStatus = ATTrackingManager.trackingAuthorizationStatus
        switch currentStatus {
        case .authorized:
            print("🔓 Already authorized")
            Settings.shared.isAdvertiserTrackingEnabled = true
            // Already determined, navigate immediately
            checkOnboardingStatus()
            return
        case .denied, .restricted:
            print("❌ Already denied/restricted")
            Settings.shared.isAdvertiserTrackingEnabled = false
            // Already determined, navigate immediately
            checkOnboardingStatus()
            return
        case .notDetermined:
            print("🕐 Requesting tracking authorization...")
        @unknown default:
            print("⚠️ Unknown tracking status")
            // Navigate anyway
            checkOnboardingStatus()
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
                    Settings.shared.isAdvertiserTrackingEnabled = false
                case .restricted:
                    print("🚫 Tracking restricted")
                    Settings.shared.isAdvertiserTrackingEnabled = false
                @unknown default:
                    print("⚠️ Unknown status: \(status)")
                    Settings.shared.isAdvertiserTrackingEnabled = false
                }
                
                // Navigate after user responds to ATT prompt
                self?.checkOnboardingStatus()
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
