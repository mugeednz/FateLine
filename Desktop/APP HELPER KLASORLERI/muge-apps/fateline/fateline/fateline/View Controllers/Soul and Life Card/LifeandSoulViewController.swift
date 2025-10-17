//
//  LifeandSoulViewController.swift
//  fateline
//
//  Created by Müge Deniz on 14.10.2025.
//

import UIKit

// MARK: - Models
struct SoulLifeCard: Codable {
    let id: Int
    let name: String
    let element: String
    let keywords: [String]
    let life_message: String
    let soul_message: String
}

struct SoulLifeData: Codable {
    let cards: [SoulLifeCard]
}

class LifeandSoulViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var cardsData: [SoulLifeCard] = []
    private var lifeCardNumber: Int?
    private var soulCardNumber: Int?
    
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
        label.text = "Life & Soul Card"
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .white
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
        label.text = "Discover your spiritual essence"
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
    
    // Date Selection Container
    private let dateContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Birth Date"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.6
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        // Set maximum date to 10 years ago from today
        let calendar = Calendar.current
        if let maxDate = calendar.date(byAdding: .year, value: -10, to: Date()) {
            picker.maximumDate = maxDate
        }
        
        // Set default date to 25 years ago
        if let defaultDate = calendar.date(byAdding: .year, value: -25, to: Date()) {
            picker.date = defaultDate
        }
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        // Style the date picker for dark theme
        picker.setValue(UIColor.white, forKey: "textColor")
        picker.overrideUserInterfaceStyle = .dark
        
        return picker
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate My Cards", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowRadius = 10
        button.titleLabel?.layer.shadowOpacity = 0.8
        button.titleLabel?.layer.masksToBounds = false
        
        return button
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
        imageView.image = UIImage.tarotCard
        imageView.tintColor = .white.withAlphaComponent(0.6)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 0
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select your birth date and tap Calculate to discover your spiritual cards"
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
    
    // Results Containers
    private let lifeCardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        view.alpha = 0
        return view
    }()
    
    private let soulCardContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        view.alpha = 0
        return view
    }()
    
    private var dateGradientLayer: CAGradientLayer?
    private var buttonGradientLayer: CAGradientLayer?
    private var emptyStateGradientLayer: CAGradientLayer?
    private var lifeCardGradientLayer: CAGradientLayer?
    private var soulCardGradientLayer: CAGradientLayer?
    
    // Store empty state constraints to deactivate later
    private var emptyStateConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        loadCardsData()
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
        dateGradientLayer?.frame = dateContainer.bounds
        buttonGradientLayer?.frame = calculateButton.bounds
        
        // Only update empty state gradient if it exists and is in hierarchy
        if emptyStateGradientLayer != nil && emptyStateContainer.superview != nil {
            emptyStateGradientLayer?.frame = emptyStateContainer.bounds
        }
        
        lifeCardGradientLayer?.frame = lifeCardContainer.bounds
        soulCardGradientLayer?.frame = soulCardContainer.bounds
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
        contentView.addSubview(dateContainer)
        contentView.addSubview(calculateButton)
        contentView.addSubview(emptyStateContainer)
        contentView.addSubview(lifeCardContainer)
        contentView.addSubview(soulCardContainer)
        
        dateContainer.addSubview(dateLabel)
        dateContainer.addSubview(datePicker)
        
        emptyStateContainer.addSubview(emptyStateImageView)
        emptyStateContainer.addSubview(emptyStateLabel)
        
        setupDateContainerGradient()
        setupButtonGradient()
        setupEmptyStateGradient()
        
        // Store empty state constraints
        emptyStateConstraints = [
            emptyStateContainer.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 30),
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
            emptyStateLabel.bottomAnchor.constraint(equalTo: emptyStateContainer.bottomAnchor, constant: -40)
        ]
        
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            dateContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            dateContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 20),
            dateLabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor),
            
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            datePicker.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor),
            datePicker.bottomAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: -20),
            
            calculateButton.topAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: 30),
            calculateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            calculateButton.heightAnchor.constraint(equalToConstant: 60),
            
            lifeCardContainer.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 40),
            lifeCardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lifeCardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            soulCardContainer.topAnchor.constraint(equalTo: lifeCardContainer.bottomAnchor, constant: 25),
            soulCardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            soulCardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            soulCardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
    }
    
    private func setupDateContainerGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = dateContainer.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        dateContainer.layer.insertSublayer(gradient, at: 0)
        dateGradientLayer = gradient
    }
    
    private func setupButtonGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = calculateButton.bounds
        gradient.colors = [
            UIColor(hex: "5D2F77").cgColor,
            UIColor(hex: "6B3F69").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 25
        calculateButton.layer.insertSublayer(gradient, at: 0)
        buttonGradientLayer = gradient
        
        calculateButton.layer.shadowColor = UIColor(hex: "6B3F69").cgColor
        calculateButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        calculateButton.layer.shadowRadius = 20
        calculateButton.layer.shadowOpacity = 0.8
    }
    
    private func setupEmptyStateGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = emptyStateContainer.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        gradient.masksToBounds = true
        emptyStateContainer.layer.insertSublayer(gradient, at: 0)
        emptyStateGradientLayer = gradient
    }
    
    private func setupInitialState() {
        // Show empty state, hide results
        emptyStateContainer.alpha = 1.0
        lifeCardContainer.alpha = 0
        soulCardContainer.alpha = 0
        
        // Activate empty state constraints
        NSLayoutConstraint.activate(emptyStateConstraints)
        
        // Add pulsing animation to icon
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
    
    private func loadCardsData() {
        guard let url = Bundle.main.url(forResource: "soulandlife", withExtension: "json") else {
            print("Could not find soulandlife.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let soulLifeData = try decoder.decode(SoulLifeData.self, from: data)
            cardsData = soulLifeData.cards
        } catch {
            print("Error loading soul and life cards: \(error)")
        }
    }
    
    // MARK: - Card Calculation
    private func calculateCards(from date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        
        guard let day = components.day,
              let month = components.month,
              let year = components.year else { return }
        
        // Calculate Life Card Number
        let dayDigits = String(day).compactMap { Int(String($0)) }
        let monthDigits = String(month).compactMap { Int(String($0)) }
        let yearDigits = String(year).compactMap { Int(String($0)) }
        
        let allDigits = dayDigits + monthDigits + yearDigits
        var sum = allDigits.reduce(0, +)
        
        // Reduce to single digit or Major Arcana (0-21)
        while sum > 21 {
            let digits = String(sum).compactMap { Int(String($0)) }
            sum = digits.reduce(0, +)
        }
        
        lifeCardNumber = sum
        
        // Calculate Soul Card Number (sum of life card digits if > 9)
        if sum > 9 {
            let lifeDigits = String(sum).compactMap { Int(String($0)) }
            soulCardNumber = lifeDigits.reduce(0, +)
        } else {
            soulCardNumber = sum
        }
        
        displayResults()
    }
    
    private func displayResults() {
        guard let lifeNum = lifeCardNumber,
              let soulNum = soulCardNumber,
              let lifeCard = cardsData.first(where: { $0.id == lifeNum }),
              let soulCard = cardsData.first(where: { $0.id == soulNum }) else {
            return
        }
        
        // IMMEDIATE HIDE - before any removal
        emptyStateContainer.alpha = 0
        emptyStateContainer.isHidden = true
        
        // Force layout update
        view.layoutIfNeeded()
        
        // Completely remove empty state
        NSLayoutConstraint.deactivate(emptyStateConstraints)
        emptyStateConstraints.removeAll()
        
        // Remove all sublayers
        emptyStateContainer.layer.sublayers?.removeAll()
        emptyStateImageView.layer.sublayers?.removeAll()
        emptyStateLabel.layer.sublayers?.removeAll()
        
        // Stop all animations
        emptyStateImageView.layer.removeAllAnimations()
        emptyStateContainer.layer.removeAllAnimations()
        emptyStateLabel.layer.removeAllAnimations()
        
        // Clear all layer properties
        emptyStateContainer.layer.borderWidth = 0
        emptyStateContainer.layer.borderColor = nil
        emptyStateContainer.layer.shadowOpacity = 0
        emptyStateContainer.layer.masksToBounds = true
        
        // Clear gradient reference
        emptyStateGradientLayer = nil
        
        // Remove from hierarchy
        emptyStateImageView.removeFromSuperview()
        emptyStateLabel.removeFromSuperview()
        emptyStateContainer.removeFromSuperview()
        
        // Force another layout update
        view.layoutIfNeeded()
        
        // Clear previous results
        lifeCardContainer.subviews.forEach { $0.removeFromSuperview() }
        soulCardContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // Setup gradients
        setupCardGradient(for: lifeCardContainer, gradientLayer: &lifeCardGradientLayer, color1: "3d1f4f", color2: "5d2f77")
        setupCardGradient(for: soulCardContainer, gradientLayer: &soulCardGradientLayer, color1: "2d1530", color2: "4a1e4f")
        
        // Create Life Card View
        createCardView(in: lifeCardContainer, card: lifeCard, type: "Life Card", number: lifeNum)
        
        // Create Soul Card View
        createCardView(in: soulCardContainer, card: soulCard, type: "Soul Card", number: soulNum)
        
        // Animate appearance
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.lifeCardContainer.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.soulCardContainer.alpha = 1.0
        }
        
        // Scroll to show results
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.scrollView.scrollRectToVisible(self.lifeCardContainer.frame, animated: true)
        }
    }
    
    private func setupCardGradient(for container: UIView, gradientLayer: inout CAGradientLayer?, color1: String, color2: String) {
        let gradient = CAGradientLayer()
        gradient.frame = container.bounds
        gradient.colors = [
            UIColor(hex: color1).cgColor,
            UIColor(hex: color2).cgColor,
            UIColor(hex: color1).cgColor
        ]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 25
        container.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Add glow
        container.layer.shadowColor = UIColor(hex: color2).cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 8)
        container.layer.shadowRadius = 25
        container.layer.shadowOpacity = 0.7
        container.layer.masksToBounds = false
    }
    
    private func createCardView(in container: UIView, card: SoulLifeCard, type: String, number: Int) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Type Label
        let typeLabel = UILabel()
        typeLabel.text = type
        typeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        typeLabel.textColor = .white.withAlphaComponent(0.7)
        typeLabel.textAlignment = .center
        
        // Card Number
        let numberLabel = UILabel()
        numberLabel.text = "Card \(number)"
        numberLabel.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        
        numberLabel.layer.shadowColor = UIColor.white.cgColor
        numberLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        numberLabel.layer.shadowRadius = 20
        numberLabel.layer.shadowOpacity = 1.0
        numberLabel.layer.masksToBounds = false
        
        // Card Name
        let nameLabel = UILabel()
        nameLabel.text = card.name
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        nameLabel.layer.shadowColor = UIColor.white.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowRadius = 15
        nameLabel.layer.shadowOpacity = 0.8
        nameLabel.layer.masksToBounds = false
        
        // Element
        let elementLabel = UILabel()
        elementLabel.text = "✦ \(card.element) ✦"
        elementLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        elementLabel.textColor = UIColor(hex: "d4a5ff")
        elementLabel.textAlignment = .center
        
        // Keywords
        let keywordsLabel = UILabel()
        keywordsLabel.text = card.keywords.joined(separator: " • ")
        keywordsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        keywordsLabel.textColor = UIColor(hex: "d4a5ff")
        keywordsLabel.textAlignment = .center
        keywordsLabel.numberOfLines = 0
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = .white.withAlphaComponent(0.3)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        // Message
        let messageLabel = UILabel()
        messageLabel.text = type == "Life Card" ? card.life_message : card.soul_message
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = .white.withAlphaComponent(0.95)
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        
        // Add to stack
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(elementLabel)
        stackView.addArrangedSubview(keywordsLabel)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(messageLabel)
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -25),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func calculateButtonTapped() {
        let selectedDate = datePicker.date
        calculateCards(from: selectedDate)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}
