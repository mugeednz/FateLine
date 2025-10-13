//
//  OnboardingOneViewController.swift
//  fateline
//
//  Created by Müge Deniz on 12.10.2025.
//

import UIKit

class OnboardingOneViewController: UIViewController {
    
    // MARK: - UI Components
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboarding_first")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        label.font = UIFont.QuintessentialRegular(size: 44)
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
        button.titleLabel?.font = UIFont.QuintessentialRegular(size: 20)
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Add background image
        view.addSubview(backgroundImageView)
        
        // Add overlay
        view.addSubview(overlayView)
        
        // Add welcome label
        view.addSubview(welcomeLabel)
        
        // Add start button
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
        // TODO: Handle button tap
        print("Start Exploring button tapped")
    }
}
