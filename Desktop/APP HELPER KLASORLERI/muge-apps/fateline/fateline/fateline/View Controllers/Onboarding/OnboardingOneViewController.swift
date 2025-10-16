//
//  OnboardingOneViewController.swift
//  fateline
//
//  Created by Müge Deniz on 12.10.2025.
//

import UIKit
import AVFoundation
import AVKit

class OnboardingOneViewController: UIViewController {

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
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to FateLine"
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
        label.text = "Unlock the mysteries of your destiny through tarot, numerology, and cosmic wisdom"
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
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
    
    private let tarotDeckImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tarot_deck_onboarding")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Minimal glow for premium feel
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 12
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
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
            self.welcomeLabel.alpha = 1.0
            self.welcomeLabel.transform = .identity
        })
        
        // 2. Description - slide up and fade in
        UIView.animate(withDuration: 1.0, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseOut], animations: {
            self.descriptionLabel.alpha = 1.0
            self.descriptionLabel.transform = .identity
        })
        
        // 3. Tarot deck - scale up and fade in
        UIView.animate(withDuration: 1.2, delay: 1.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseOut], animations: {
            self.tarotDeckImageView.alpha = 1.0
            self.tarotDeckImageView.transform = .identity
        }) { _ in
            // Start continuous rotation after appearing
            self.addRotationAnimation()
        }
        
        // 4. Button - fade in slowly
        UIView.animate(withDuration: 1.5, delay: 1.8, options: [.curveEaseOut], animations: {
            self.startButton.alpha = 1.0
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Add video container
        view.addSubview(videoContainerView)
        
        // Add overlay
        view.addSubview(overlayView)
        
        // Add welcome label
        view.addSubview(welcomeLabel)
        
        // Add description label
        view.addSubview(descriptionLabel)
        
        // Add tarot deck image
        view.addSubview(tarotDeckImageView)
        
        // Add start button
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        // Initially hide elements for fade in animations
        startButton.alpha = 0
        welcomeLabel.alpha = 0
        welcomeLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        descriptionLabel.alpha = 0
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        tarotDeckImageView.alpha = 0
        tarotDeckImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
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
            
            // Welcome label constraints (top)
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            // Description label constraints (under title)
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            // Tarot deck image constraints (center)
            tarotDeckImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tarotDeckImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            tarotDeckImageView.widthAnchor.constraint(equalToConstant: 300),
            tarotDeckImageView.heightAnchor.constraint(equalToConstant: 300
                                                      ),
            
            // Start button constraints (bottom)
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            startButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupVideoPlayer() {
        // Get video path
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
        gradient.frame = startButton.bounds
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 26
        
        // Insert gradient at the bottom of button's layers
        startButton.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Minimal border
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Subtle shadow for depth
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        startButton.layer.shadowRadius = 12
        startButton.layer.shadowOpacity = 0.2
        
        // Add strong white glow to button text
        startButton.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        startButton.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        startButton.titleLabel?.layer.shadowRadius = 14
        startButton.titleLabel?.layer.shadowOpacity = 0.9
        startButton.titleLabel?.layer.masksToBounds = false
    }
    
    // MARK: - Animations
    private func addRotationAnimation() {
        // Slow, elegant continuous rotation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 30.0  // 30 seconds for smooth, slow rotation
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        tarotDeckImageView.layer.add(rotationAnimation, forKey: "continuousRotation")
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        // Navigate to second onboarding screen
        GlobalHelper.pushController(id: "OnboardingSecondViewController", self) { vc in
            (vc as? OnboardingSecondViewController)?.navigationItem.hidesBackButton = true
        }
    }
}
