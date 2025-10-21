//
//  OnboardingSecondViewController.swift
//  fateline
//
//  Created by Müge Deniz on 12.10.2025.
//

import UIKit
import AVFoundation
import AVKit

class OnboardingSecondViewController: UIViewController {

    // MARK: - Video Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    // MARK: - UI Components
    private let videoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var overlayGradient: CAGradientLayer?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FateLine".translate
        label.font = UIFont.systemFont(ofSize: 38, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Strong white glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 20
        label.layer.shadowOpacity = 0.9
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Your personal guide to self-discovery".translate
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .white.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Strong white glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 16
        label.layer.shadowOpacity = 0.8
        label.layer.masksToBounds = false
        
        return label
    }()
    
    // Animated Feature Label
    private let animatedFeatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Strong white glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 24
        label.layer.shadowOpacity = 1.0
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let features = [
        "Unlimited Tarot Readings".translate,
        "Advanced Zodiac Compatibility".translate,
        "Life & Soul Card Insights".translate,
        "Spirit Animal Discovery".translate,
        "Deep Numerology Analysis".translate
    ]
    
    private var currentFeatureIndex = 0
    private var featureTimer: Timer?
    
    private let readyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started".translate, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 26
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var gradientLayer: CAGradientLayer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVideoPlayer()
        startFeatureAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
        setupOverlayGradient()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
        
        // Advanced cascading animations
        
        // 1. Title - scale up and fade in
        UIView.animate(withDuration: 1.2, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.titleLabel.alpha = 1.0
            self.titleLabel.transform = .identity
        })
        
        // 2. Description - slide up and fade in
        UIView.animate(withDuration: 1.0, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.descriptionLabel.alpha = 1.0
            self.descriptionLabel.transform = .identity
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        featureTimer?.invalidate()
        featureTimer = nil
    }
    
    deinit {
        featureTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Add video container
        view.addSubview(videoContainerView)
        
        // Add overlay
        view.addSubview(overlayView)
        
        // Add title label
        view.addSubview(titleLabel)
        
        // Add description label
        view.addSubview(descriptionLabel)
        
        // Add animated feature label
        view.addSubview(animatedFeatureLabel)
        
        // Add ready button
        view.addSubview(readyButton)
        readyButton.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        
        // Initially hide elements for fade in animations
        readyButton.alpha = 0
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        descriptionLabel.alpha = 0
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Video container constraints
            videoContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Overlay constraints
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title label constraints (top)
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            // Description label constraints (under title)
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            // Animated feature label constraints (center)
            animatedFeatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedFeatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            animatedFeatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            animatedFeatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            animatedFeatureLabel.heightAnchor.constraint(equalToConstant: 80),
            
            // Ready button constraints
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            readyButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupVideoPlayer() {
        // Get video path (same as OnboardingOne)
        guard let videoPath = Bundle.main.path(forResource: "onboarding_space", ofType: "mp4") else {
            print("Video file not found")
            return
        }
        
        let videoURL = URL(fileURLWithPath: videoPath)
        
        // Create player
        player = AVPlayer(url: videoURL)
        player?.isMuted = true
        
        // Create player layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoContainerView.bounds
        
        if let playerLayer = playerLayer {
            videoContainerView.layer.addSublayer(playerLayer)
        }
        
        // Loop video
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
    }
    
    @objc private func videoDidEnd() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    private func setupOverlayGradient() {
        // Remove existing overlay gradient if any
        overlayGradient?.removeFromSuperlayer()
        
        // Create elegant, sophisticated overlay gradient
        let gradient = CAGradientLayer()
        gradient.frame = overlayView.bounds
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.75).cgColor,
            UIColor.black.withAlphaComponent(0.65).cgColor,
            UIColor.black.withAlphaComponent(0.75).cgColor,
            UIColor.black.withAlphaComponent(0.85).cgColor
        ]
        gradient.locations = [0, 0.35, 0.65, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        overlayView.layer.addSublayer(gradient)
        overlayGradient = gradient
    }
    
    private func setupGradient() {
        // Remove existing gradient if any
        gradientLayer?.removeFromSuperlayer()
        
        // Create elegant gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = readyButton.bounds
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 26
        
        // Insert gradient at the bottom of button's layers
        readyButton.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Minimal border
        readyButton.layer.borderWidth = 1
        readyButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Subtle shadow for depth
        readyButton.layer.shadowColor = UIColor.black.cgColor
        readyButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        readyButton.layer.shadowRadius = 12
        readyButton.layer.shadowOpacity = 0.2
        
        // Add strong white glow to button text
        readyButton.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        readyButton.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        readyButton.titleLabel?.layer.shadowRadius = 14
        readyButton.titleLabel?.layer.shadowOpacity = 0.9
        readyButton.titleLabel?.layer.masksToBounds = false
    }
    
    // MARK: - Feature Animation
    private func startFeatureAnimation() {
        // Show first feature after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showNextFeature()
        }
        
        // Start timer for cycling through features (slower for elegance)
        featureTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            self?.showNextFeature()
        }
        
        // Fade in button elegantly
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseOut], animations: {
                self.readyButton.alpha = 1.0
            })
        }
    }
    
    private func showNextFeature() {
        let feature = features[currentFeatureIndex]
        
        // Fade out current (slower)
        UIView.animate(withDuration: 0.6, animations: {
            self.animatedFeatureLabel.alpha = 0
            self.animatedFeatureLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            // Update text
            self.animatedFeatureLabel.text = feature
            
            // Fade in new (elegant)
            UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
                self.animatedFeatureLabel.alpha = 1.0
                self.animatedFeatureLabel.transform = .identity
            })
        }
        
        // Move to next feature
        currentFeatureIndex = (currentFeatureIndex + 1) % features.count
    }
    
    // MARK: - Actions
    @objc private func readyButtonTapped() {
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        // Navigate to main screen
        GlobalHelper.pushController(id: "MainViewController", self) { vc in }
    }
}
