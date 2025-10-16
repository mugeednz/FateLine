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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to FateLine"
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 1.0
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Exploring", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect to text
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowRadius = 8
        button.titleLabel?.layer.shadowOpacity = 0.8
        button.titleLabel?.layer.masksToBounds = false
        
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
        playerLayer?.frame = videoContainerView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
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
        
        // Add start button
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
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
            
            // Welcome label constraints
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            // Start button constraints
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.heightAnchor.constraint(equalToConstant: 50)
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
    
    private func setupGradient() {
        // Remove existing gradient if any
        gradientLayer?.removeFromSuperlayer()
        
        // Create gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = startButton.bounds
        gradient.colors = [
            UIColor(hex: "5D2F77").cgColor,
            UIColor(hex: "6B3F69").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 25
        
        // Insert gradient at the bottom of button's layers
        startButton.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Add glow effect
        startButton.layer.shadowColor = UIColor(hex: "6B3F69").cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        startButton.layer.shadowRadius = 20
        startButton.layer.shadowOpacity = 0.8
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        // Navigate to second onboarding screen
        GlobalHelper.pushController(id: "OnboardingSecondViewController", self) { vc in
            (vc as? OnboardingSecondViewController)?.navigationItem.hidesBackButton = true
        }
    }
}
