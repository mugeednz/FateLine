//
//  OnboardingOneViewController.swift
//  fateline
//
//  Created by Müge Deniz on 12.10.2025.
//

import UIKit
import AVFoundation

class OnboardingOneViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    // MARK: - UI Components
    private let videoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isSmallScreen: Bool {
        return UIScreen.main.bounds.height <= 667
    }
    
    // MARK: - UI Components
    
    private lazy var tarotDeckImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tarot_deck_onboarding")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // White glow effect
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 20
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var overlayGradient: CAGradientLayer?
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to FateLine".translate
        label.font = UIFont.systemFont(ofSize: isSmallScreen ? 32 : 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // White glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 0.8
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock the mysteries of your destiny through tarot, numerology, and cosmic wisdom".translate
        label.font = UIFont.systemFont(ofSize: isSmallScreen ? 16 : 20, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // White glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.6
        label.layer.masksToBounds = false
        
        return label
    }()
    
    // Animated Feature Label
    private let animatedFeatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect (same as PremiumViewController)
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 20
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
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Get Started".translate, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 26
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Purple gradient background
        button.backgroundColor = UIColor(hex: "5D2F77")
        
        // White glow effect
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 15
        button.layer.shadowOpacity = 0.6
        button.layer.masksToBounds = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupVideoPlayer()
        addAnimations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        featureTimer?.invalidate()
        featureTimer = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        setupOverlayGradient()
        playerLayer?.frame = videoContainerView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
        
        // Start sequential animations
        startSequentialAnimations()
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(hex: "1a0a2e").cgColor,
            UIColor(hex: "2d1b3d").cgColor,
            UIColor(hex: "4a1e4f").cgColor,
            UIColor(hex: "1a0a2e").cgColor
        ]
        gradient.locations = [0.0, 0.3, 0.7, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupVideoPlayer() {
        // Get video path (same as OnboardingSecond)
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
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        player?.play()
    }
    
    private func setupOverlayGradient() {
        // Remove existing overlay gradient if any
        overlayGradient?.removeFromSuperlayer()
        
        // Create elegant, sophisticated overlay gradient (same as OnboardingSecond)
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
    
    private func setupUI() {
        // Add video container
        view.addSubview(videoContainerView)
        
        // Add overlay
        view.addSubview(overlayView)
        
        // Add tarot deck
        view.addSubview(tarotDeckImageView)
        
        // Add labels
        view.addSubview(welcomeLabel)
        view.addSubview(descriptionLabel)
        
        // Add animated feature label
        view.addSubview(animatedFeatureLabel)
        
        // Add button
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        // Initially hide elements for professional animations
        startButton.alpha = 0
        startButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        welcomeLabel.alpha = 0
        welcomeLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        descriptionLabel.alpha = 0
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        animatedFeatureLabel.alpha = 0
        animatedFeatureLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Small screen adjustments
        let topSpacing: CGFloat = isSmallScreen ? 60 : 80
        let bottomSpacing: CGFloat = isSmallScreen ? 40 : 60
        let buttonHeight: CGFloat = isSmallScreen ? 50 : 60
        
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
            
            // Welcome label constraints (top)
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topSpacing),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            // Description label constraints (under welcome)
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            // Tarot deck constraints (center)
            tarotDeckImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tarotDeckImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            tarotDeckImageView.widthAnchor.constraint(equalToConstant: isSmallScreen ? 200 : 250),
            tarotDeckImageView.heightAnchor.constraint(equalToConstant: isSmallScreen ? 200 : 250),
            
            // Animated feature label constraints (center of screen)
            animatedFeatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedFeatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animatedFeatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            animatedFeatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            animatedFeatureLabel.heightAnchor.constraint(equalToConstant: 100),
            
            // Start button constraints
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomSpacing),
            startButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    // MARK: - Professional Sequential Animations
    private func startSequentialAnimations() {
        // Phase 1: Elegant entrance (0-3s)
        elegantEntrance()
        
        // Phase 2: Smooth transition to features (3-4s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.smoothTransitionToFeatures()
        }
        
        // Phase 3: Features showcase (4-9s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.showcaseFeatures()
        }
        
        // Phase 4: Final call to action (9-10s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
            self.finalCallToAction()
        }
    }
    
    private func elegantEntrance() {
        // Welcome label - elegant scale and fade
        UIView.animate(withDuration: 1.5, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.welcomeLabel.alpha = 1.0
            self.welcomeLabel.transform = .identity
        })
        
        // Description label - smooth slide up
        UIView.animate(withDuration: 1.2, delay: 1.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
            self.descriptionLabel.alpha = 1.0
            self.descriptionLabel.transform = .identity
        })
    }
    
    private func smoothTransitionToFeatures() {
        // Elegant fade out with scale for text
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
            self.welcomeLabel.alpha = 0
            self.welcomeLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.descriptionLabel.alpha = 0
            self.descriptionLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        })
        
        // Tarot deck also fades out elegantly
        UIView.animate(withDuration: 1.2, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.curveEaseInOut], animations: {
            self.tarotDeckImageView.alpha = 0
            self.tarotDeckImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    private func showcaseFeatures() {
        // Start professional feature animation
        startProfessionalFeatureAnimation()
    }
    
    private func finalCallToAction() {
        // Stop feature animation
        featureTimer?.invalidate()
        featureTimer = nil
        
        // Elegant button entrance with scale and glow
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.startButton.alpha = 1.0
            self.startButton.transform = .identity
        })
        
        // Add subtle pulse animation to button
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.05
        pulse.duration = 2.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        startButton.layer.add(pulse, forKey: "pulse")
    }
    
    // MARK: - Professional Feature Animation
    private func startProfessionalFeatureAnimation() {
        // Show first feature with elegant entrance
        showProfessionalFeature()
        
        // Start timer for cycling through features (perfect timing)
        featureTimer = Timer.scheduledTimer(withTimeInterval: 1.8, repeats: true) { [weak self] _ in
            self?.showProfessionalFeature()
        }
    }
    
    private func showProfessionalFeature() {
        let feature = features[currentFeatureIndex]
        
        // If this is the first feature, elegant entrance
        if currentFeatureIndex == 0 {
            animatedFeatureLabel.text = feature
            animatedFeatureLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
                self.animatedFeatureLabel.alpha = 1.0
                self.animatedFeatureLabel.transform = .identity
            })
        } else {
            // Professional transition between features
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
                self.animatedFeatureLabel.alpha = 0
                self.animatedFeatureLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                // Update text
                self.animatedFeatureLabel.text = feature
                self.animatedFeatureLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                // Elegant entrance
                UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
                    self.animatedFeatureLabel.alpha = 1.0
                    self.animatedFeatureLabel.transform = .identity
                })
            }
        }
        
        // Move to next feature
        currentFeatureIndex = (currentFeatureIndex + 1) % features.count
    }
    
    
    private func addAnimations() {
        // Tarot deck rotation animation
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 8.0
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
        tarotDeckImageView.layer.add(rotation, forKey: "rotation")
        
        // Tarot deck float animation
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.fromValue = -10
        float.toValue = 10
        float.duration = 3.0
        float.autoreverses = true
        float.repeatCount = .infinity
        float.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        tarotDeckImageView.layer.add(float, forKey: "float")
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        // Navigate to main screen
        GlobalHelper.pushController(id: "MainViewController", self) { vc in }
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
        featureTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
        playerLayer = nil
    }
}
