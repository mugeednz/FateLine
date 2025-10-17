//
//  ZodiacViewController.swift
//  fateline
//
//  Created by Müge Deniz on 14.10.2025.
//

import UIKit

// MARK: - Zodiac Models
struct ZodiacData: Codable {
    let paragraph: String
    let compatibility: [String: ZodiacCompatibility]
}

struct ZodiacCompatibility: Codable {
    let score: Int
    let description: String
}

class ZodiacViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var zodiacData: [String: ZodiacData] = [:]
    private var selectedMaleSign: String?
    private var selectedFemaleSign: String?
    private var currentGender: Gender?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.8
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Zodiac Compatibility"
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 0.8
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover your cosmic connection"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.5
        label.layer.masksToBounds = false
        
        return label
    }()
    
    // Male Sign Selection
    private let maleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let maleLabel: UILabel = {
        let label = UILabel()
        label.text = "Male Sign"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maleSignButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Sign", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowRadius = 8
        button.titleLabel?.layer.shadowOpacity = 0.6
        button.titleLabel?.layer.masksToBounds = false
        
        return button
    }()
    
    // Female Sign Selection
    private let femaleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "Female Sign"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let femaleSignButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Sign", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 15
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowRadius = 8
        button.titleLabel?.layer.shadowOpacity = 0.6
        button.titleLabel?.layer.masksToBounds = false
        
        return button
    }()
    
    // Results Container
    private let resultsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.alpha = 0
        view.clipsToBounds = true
        return view
    }()
    
    private let maleIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zodiac_man")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let femaleIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zodiac_women")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Flip horizontally to face left (towards male)
        imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        // Add glow
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let scoreContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 20
        label.layer.shadowOpacity = 1.0
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let compatibilityLabel: UILabel = {
        let label = UILabel()
        label.text = "Compatibility Score"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Empty State
    private let emptyStateContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.astrology
        imageView.tintColor = .white.withAlphaComponent(0.6)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 6
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select both zodiac signs to discover your cosmic compatibility"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.5
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private var maleGradientLayer: CAGradientLayer?
    private var femaleGradientLayer: CAGradientLayer?
    private var resultsGradientLayer: CAGradientLayer?
    private var emptyStateGradientLayer: CAGradientLayer?
    private var maleButtonGradientLayer: CAGradientLayer?
    private var femaleButtonGradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        loadZodiacData()
        setupUI()
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        maleGradientLayer?.frame = maleContainer.bounds
        femaleGradientLayer?.frame = femaleContainer.bounds
        resultsGradientLayer?.frame = resultsContainer.bounds
        emptyStateGradientLayer?.frame = emptyStateContainer.bounds
        maleButtonGradientLayer?.frame = maleSignButton.bounds
        femaleButtonGradientLayer?.frame = femaleSignButton.bounds
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
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
        
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(maleContainer)
        contentView.addSubview(femaleContainer)
        contentView.addSubview(emptyStateContainer)
        contentView.addSubview(resultsContainer)
        
        // Male container setup
        maleContainer.addSubview(maleLabel)
        maleContainer.addSubview(maleSignButton)
        setupContainerGradient(for: maleContainer, gradientLayer: &maleGradientLayer)
        setupButtonGradient(for: maleSignButton, gradientLayer: &maleButtonGradientLayer)
        
        // Female container setup
        femaleContainer.addSubview(femaleLabel)
        femaleContainer.addSubview(femaleSignButton)
        setupContainerGradient(for: femaleContainer, gradientLayer: &femaleGradientLayer)
        setupButtonGradient(for: femaleSignButton, gradientLayer: &femaleButtonGradientLayer)
        
        // Empty State container setup
        emptyStateContainer.addSubview(emptyStateImageView)
        emptyStateContainer.addSubview(emptyStateLabel)
        setupContainerGradient(for: emptyStateContainer, gradientLayer: &emptyStateGradientLayer)
        
        // Results container setup
        resultsContainer.addSubview(scoreContainerView)
        scoreContainerView.addSubview(maleIconImageView)
        scoreContainerView.addSubview(scoreLabel)
        scoreContainerView.addSubview(femaleIconImageView)
        resultsContainer.addSubview(compatibilityLabel)
        resultsContainer.addSubview(descriptionLabel)
        setupContainerGradient(for: resultsContainer, gradientLayer: &resultsGradientLayer)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            maleContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            maleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            maleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            maleContainer.heightAnchor.constraint(equalToConstant: 140),
            
            maleLabel.topAnchor.constraint(equalTo: maleContainer.topAnchor, constant: 20),
            maleLabel.centerXAnchor.constraint(equalTo: maleContainer.centerXAnchor),
            
            maleSignButton.topAnchor.constraint(equalTo: maleLabel.bottomAnchor, constant: 15),
            maleSignButton.leadingAnchor.constraint(equalTo: maleContainer.leadingAnchor, constant: 30),
            maleSignButton.trailingAnchor.constraint(equalTo: maleContainer.trailingAnchor, constant: -30),
            maleSignButton.heightAnchor.constraint(equalToConstant: 50),
            
            femaleContainer.topAnchor.constraint(equalTo: maleContainer.bottomAnchor, constant: 20),
            femaleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            femaleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            femaleContainer.heightAnchor.constraint(equalToConstant: 140),
            
            femaleLabel.topAnchor.constraint(equalTo: femaleContainer.topAnchor, constant: 20),
            femaleLabel.centerXAnchor.constraint(equalTo: femaleContainer.centerXAnchor),
            
            femaleSignButton.topAnchor.constraint(equalTo: femaleLabel.bottomAnchor, constant: 15),
            femaleSignButton.leadingAnchor.constraint(equalTo: femaleContainer.leadingAnchor, constant: 30),
            femaleSignButton.trailingAnchor.constraint(equalTo: femaleContainer.trailingAnchor, constant: -30),
            femaleSignButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Empty State
            emptyStateContainer.topAnchor.constraint(equalTo: femaleContainer.bottomAnchor, constant: 30),
            emptyStateContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emptyStateContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emptyStateContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateContainer.topAnchor, constant: 40),
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateContainer.centerXAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 30),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateContainer.leadingAnchor, constant: 30),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateContainer.trailingAnchor, constant: -30),
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateContainer.bottomAnchor, constant: -40),
            
            resultsContainer.topAnchor.constraint(equalTo: femaleContainer.bottomAnchor, constant: 30),
            resultsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            scoreContainerView.topAnchor.constraint(equalTo: resultsContainer.topAnchor, constant: 30),
            scoreContainerView.centerXAnchor.constraint(equalTo: resultsContainer.centerXAnchor),
            scoreContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            maleIconImageView.leadingAnchor.constraint(equalTo: scoreContainerView.leadingAnchor),
            maleIconImageView.centerYAnchor.constraint(equalTo: scoreContainerView.centerYAnchor),
            maleIconImageView.widthAnchor.constraint(equalToConstant: 60),
            maleIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            scoreLabel.centerXAnchor.constraint(equalTo: scoreContainerView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreContainerView.centerYAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: maleIconImageView.trailingAnchor, constant: 15),
            scoreLabel.trailingAnchor.constraint(equalTo: femaleIconImageView.leadingAnchor, constant: -15),
            
            femaleIconImageView.trailingAnchor.constraint(equalTo: scoreContainerView.trailingAnchor),
            femaleIconImageView.centerYAnchor.constraint(equalTo: scoreContainerView.centerYAnchor),
            femaleIconImageView.widthAnchor.constraint(equalToConstant: 60),
            femaleIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            compatibilityLabel.topAnchor.constraint(equalTo: scoreContainerView.bottomAnchor, constant: 5),
            compatibilityLabel.centerXAnchor.constraint(equalTo: resultsContainer.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: compatibilityLabel.bottomAnchor, constant: 25),
            descriptionLabel.leadingAnchor.constraint(equalTo: resultsContainer.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: resultsContainer.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: resultsContainer.bottomAnchor, constant: -30),
            
            resultsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        maleSignButton.addTarget(self, action: #selector(maleSignButtonTapped), for: .touchUpInside)
        femaleSignButton.addTarget(self, action: #selector(femaleSignButtonTapped), for: .touchUpInside)
    }
    
    private func setupContainerGradient(for container: UIView, gradientLayer: inout CAGradientLayer?) {
        let gradient = CAGradientLayer()
        gradient.frame = container.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        gradient.masksToBounds = true
        container.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupButtonGradient(for button: UIButton, gradientLayer: inout CAGradientLayer?) {
        let gradient = CAGradientLayer()
        gradient.frame = button.bounds
        gradient.colors = [
            UIColor(hex: "5D2F77").cgColor,
            UIColor(hex: "6B3F69").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 15
        button.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        button.layer.shadowColor = UIColor(hex: "6B3F69").cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 15
        button.layer.shadowOpacity = 0.6
    }
    
    private func loadZodiacData() {
        guard let url = Bundle.main.url(forResource: "burclar", withExtension: "json") else {
            print("Could not find burclar.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            zodiacData = try decoder.decode([String: ZodiacData].self, from: data)
        } catch {
            print("Error loading zodiac data: \(error)")
        }
    }
    
    private func setupInitialState() {
        // Show empty state, hide results
        emptyStateContainer.alpha = 1.0
        resultsContainer.alpha = 0
        
        // Add pulsing animation to sparkles
        addPulsingAnimation(to: emptyStateImageView)
    }
    
    private func addPulsingAnimation(to view: UIView) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 2.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.15
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        view.layer.add(pulseAnimation, forKey: "pulse")
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func maleSignButtonTapped() {
        showZodiacPicker(for: .male)
    }
    
    @objc private func femaleSignButtonTapped() {
        showZodiacPicker(for: .female)
    }
    
    private func showZodiacPicker(for gender: Gender) {
        currentGender = gender
        
        let pickerVC = ZodiacPickerViewController()
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .overFullScreen
        pickerVC.modalTransitionStyle = .crossDissolve
        
        present(pickerVC, animated: true)
    }
    
    private func selectSign(_ sign: String, for gender: Gender) {
        switch gender {
        case .male:
            selectedMaleSign = sign
            maleSignButton.setTitle(sign, for: .normal)
        case .female:
            selectedFemaleSign = sign
            femaleSignButton.setTitle(sign, for: .normal)
        }
        
        checkAndShowCompatibility()
    }
    
    private func checkAndShowCompatibility() {
        guard let maleSign = selectedMaleSign,
              let femaleSign = selectedFemaleSign,
              let maleData = zodiacData[maleSign],
              let compatibility = maleData.compatibility[femaleSign] else {
            return
        }
        
        showCompatibilityResults(score: compatibility.score, description: compatibility.description)
    }
    
    private func showCompatibilityResults(score: Int, description: String) {
        scoreLabel.text = "\(score)%"
        descriptionLabel.text = description
        
        // Hide empty state and show results
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.emptyStateContainer.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
                self.resultsContainer.alpha = 1.0
            }
        }
        
        // Scroll to show results
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.scrollView.scrollRectToVisible(self.resultsContainer.frame, animated: true)
        }
    }
    
    enum Gender {
        case male, female
    }
}

// MARK: - ZodiacPickerDelegate
extension ZodiacViewController: ZodiacPickerDelegate {
    func didSelectZodiacSign(_ sign: String) {
        guard let gender = currentGender else { return }
        selectSign(sign, for: gender)
    }
}
