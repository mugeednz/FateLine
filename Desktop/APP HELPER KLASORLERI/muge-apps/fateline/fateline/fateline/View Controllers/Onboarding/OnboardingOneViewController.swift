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
    
    // Check if device is iPhone SE or similar small screen
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
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Continue".translate, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isSmallScreen ? 18 : 22, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Button styling
        button.backgroundColor = UIColor(hex: "5D2F77")
        button.layer.cornerRadius = isSmallScreen ? 24 : 28
        button.clipsToBounds = false
        
        // White glow effect
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 20
        button.layer.shadowOpacity = 0.8
        button.layer.masksToBounds = false
        
        // Add gradient background
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "5D2F77").cgColor,
            UIColor(hex: "6B3F69").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = isSmallScreen ? 24 : 28
        button.layer.insertSublayer(gradient, at: 0)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        setupOverlayGradient()
        playerLayer?.frame = videoContainerView.bounds
        
        // Update button gradient
        if let gradient = startButton.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = startButton.bounds
        }
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
        
        // Add button
        view.addSubview(startButton)
        
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
            
            tarotDeckImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tarotDeckImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tarotDeckImageView.widthAnchor.constraint(equalToConstant: isSmallScreen ? 200 : 250),
            tarotDeckImageView.heightAnchor.constraint(equalToConstant: isSmallScreen ? 200 : 250),
            
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topSpacing),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomSpacing),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
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
        
        // Welcome label fade in animation
        welcomeLabel.alpha = 0
        welcomeLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [.curveEaseOut], animations: {
            self.welcomeLabel.alpha = 1.0
            self.welcomeLabel.transform = .identity
        })
        
        // Description label fade in animation
        descriptionLabel.alpha = 0
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 1.0, delay: 0.8, options: [.curveEaseOut], animations: {
            self.descriptionLabel.alpha = 1.0
            self.descriptionLabel.transform = .identity
        })
        
        // Button fade in animation
        startButton.alpha = 0
        startButton.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 1.0, delay: 1.1, options: [.curveEaseOut], animations: {
            self.startButton.alpha = 1.0
            self.startButton.transform = .identity
        })
        
        // Button pulse animation
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.05
        pulse.duration = 2.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        startButton.layer.add(pulse, forKey: "pulse")
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Navigate to next onboarding screen
        GlobalHelper.pushController(id: "OnboardingSecondViewController", self) { vc in
            (vc as? OnboardingSecondViewController)?.navigationItem.hidesBackButton = true
        }
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
        playerLayer = nil
    }
}
