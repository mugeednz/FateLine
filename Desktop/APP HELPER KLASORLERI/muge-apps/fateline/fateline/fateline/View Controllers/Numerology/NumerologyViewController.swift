//
//  NumerologyViewController.swift
//  fateline
//
//  Created by Müge Deniz on 14.10.2025.
//

import UIKit

class NumerologyViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var calculatedNumber: Int?
    
    // Pythagorean Numerology System
    private let numerologyMap: [Character: Int] = [
        "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9,
        "J": 1, "K": 2, "L": 3, "M": 4, "N": 5, "O": 6, "P": 7, "Q": 8, "R": 9,
        "S": 1, "T": 2, "U": 3, "V": 4, "W": 5, "X": 6, "Y": 7, "Z": 8
    ]
    
    private let numberMeanings: [Int: (title: String, description: String, keywords: [String])] = [
        1: ("The Leader".translate, "You are independent, pioneering, and ambitious. Natural-born leader with strong willpower and determination. You create your own path and inspire others to follow.".translate, ["Leadership".translate, "Independence".translate, "Ambition".translate]),
        2: ("The Peacemaker".translate, "You are diplomatic, cooperative, and intuitive. You bring harmony to relationships and have a gift for understanding others. Your sensitivity is your strength.".translate, ["Harmony".translate, "Cooperation".translate, "Intuition".translate]),
        3: ("The Creative".translate, "You are expressive, optimistic, and creative. Communication and self-expression come naturally to you. You bring joy and inspiration wherever you go.".translate, ["Creativity".translate, "Expression".translate, "Joy".translate]),
        4: ("The Builder".translate, "You are practical, organized, and hardworking. You build strong foundations and value stability. Your dedication and reliability make dreams reality.".translate, ["Stability".translate, "Organization".translate, "Dedication".translate]),
        5: ("The Adventurer".translate, "You are freedom-loving, adaptable, and curious. You thrive on change and new experiences. Your energy and versatility inspire exploration.".translate, ["Freedom".translate, "Adventure".translate, "Versatility".translate]),
        6: ("The Nurturer".translate, "You are caring, responsible, and compassionate. Family and community are important to you. Your love and support heal and uplift others.".translate, ["Love".translate, "Responsibility".translate, "Compassion".translate]),
        7: ("The Seeker".translate, "You are analytical, spiritual, and introspective. You seek truth and understanding. Your wisdom comes from deep inner knowing.".translate, ["Wisdom".translate, "Spirituality".translate, "Analysis".translate]),
        8: ("The Achiever".translate, "You are powerful, ambitious, and successful. Material and professional success come naturally. Your strength lies in manifesting abundance.".translate, ["Success".translate, "Power".translate, "Abundance".translate]),
        9: ("The Humanitarian".translate, "You are compassionate, generous, and idealistic. You care deeply about the world and serve others. Your wisdom and empathy inspire change.".translate, ["Compassion".translate, "Service".translate, "Wisdom".translate]),
        11: ("The Master Intuitive".translate, "You are highly intuitive, spiritual, and inspirational. As a master number, you have great potential for enlightenment and spiritual leadership. Trust your inner vision.".translate, ["Intuition".translate, "Inspiration".translate, "Enlightenment".translate]),
        22: ("The Master Builder".translate, "You are a practical visionary with the ability to turn dreams into reality on a grand scale. As a master number, you can create lasting legacies that benefit humanity.".translate, ["Mastery".translate, "Vision".translate, "Legacy".translate]),
        33: ("The Master Teacher".translate, "You are the master teacher and spiritual guide. Your purpose is to uplift humanity through love, compassion, and selfless service. You embody unconditional love.".translate, ["Teaching".translate, "Service".translate, "Unconditional Love".translate])
    ]
    
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
        label.text = "Numerology".translate
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
        label.text = "Discover your life path number".translate
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
    
    // Input Container
    private let inputContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name".translate
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "First Name".translate,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name".translate
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Last Name".translate,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calculate My Number".translate, for: .normal)
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
        imageView.image = UIImage.numerology
        imageView.tintColor = .white.withAlphaComponent(0.6)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your full name and tap Calculate to discover your life path number".translate
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
    
    // Result Container
    private let resultContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = false
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    private var inputGradientLayer: CAGradientLayer?
    private var buttonGradientLayer: CAGradientLayer?
    private var emptyStateGradientLayer: CAGradientLayer?
    private var resultGradientLayer: CAGradientLayer?
    
    // Store empty state constraints to deactivate later
    private var emptyStateConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupKeyboardHandling()
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        inputGradientLayer?.frame = inputContainer.bounds
        buttonGradientLayer?.frame = calculateButton.bounds
        
        // Only update empty state gradient if it exists and is in hierarchy
        if emptyStateGradientLayer != nil && emptyStateContainer.superview != nil {
            emptyStateGradientLayer?.frame = emptyStateContainer.bounds
        }
        
        resultGradientLayer?.frame = resultContainer.bounds
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
        contentView.addSubview(inputContainer)
        inputContainer.addSubview(firstNameTextField)
        inputContainer.addSubview(lastNameTextField)
        contentView.addSubview(calculateButton)
        contentView.addSubview(emptyStateContainer)
        contentView.addSubview(resultContainer)
        
        emptyStateContainer.addSubview(emptyStateImageView)
        emptyStateContainer.addSubview(emptyStateLabel)
        
        setupInputGradient()
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
            
            inputContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            inputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            inputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            firstNameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 25),
            firstNameTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            lastNameTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 20),
            lastNameTextField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -20),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            lastNameTextField.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -25),
            
            calculateButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 30),
            calculateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            calculateButton.heightAnchor.constraint(equalToConstant: 60),
            
            resultContainer.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 40),
            resultContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupInputGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = inputContainer.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        gradient.zPosition = -1
        inputContainer.layer.insertSublayer(gradient, at: 0)
        inputGradientLayer = gradient
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
        resultContainer.alpha = 0
        resultContainer.isHidden = true
        
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
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Numerology Calculation
    private func calculateNumerologyNumber(from name: String) -> Int {
        let cleanName = name.uppercased().filter { $0.isLetter }
        var sum = 0
        
        for char in cleanName {
            if let value = numerologyMap[char] {
                sum += value
            }
        }
        
        // Reduce to single digit unless it's a master number (11, 22, 33)
        return reduceToSingleDigit(sum)
    }
    
    private func reduceToSingleDigit(_ number: Int) -> Int {
        var num = number
        
        // Keep reducing until single digit or master number
        while num > 9 {
            // Check for master numbers
            if num == 11 || num == 22 || num == 33 {
                return num
            }
            
            // Reduce: sum of digits
            var sum = 0
            while num > 0 {
                sum += num % 10
                num /= 10
            }
            num = sum
        }
        
        return num
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func calculateButtonTapped() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(title: "Missing Information".translate, message: "Please enter both your first and last name.".translate)
            return
        }
        
        dismissKeyboard()
        
        let fullName = firstName + lastName
        let number = calculateNumerologyNumber(from: fullName)
        calculatedNumber = number
        
        displayResult(number: number)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".translate, style: .default))
        present(alert, animated: true)
    }
    
    private func displayResult(number: Int) {
        guard let meaning = numberMeanings[number] else { return }
        
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
        
        // Clear previous content
        resultContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // Setup result gradient (only if not already set)
        if resultGradientLayer == nil {
            let gradient = CAGradientLayer()
            gradient.frame = resultContainer.bounds
            gradient.colors = [
                UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
                UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
            ]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.cornerRadius = 25
            gradient.zPosition = -1
            resultContainer.layer.insertSublayer(gradient, at: 0)
            resultGradientLayer = gradient
            
            resultContainer.layer.shadowColor = UIColor.white.cgColor
            resultContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
            resultContainer.layer.shadowRadius = 25
            resultContainer.layer.shadowOpacity = 0.5
            resultContainer.layer.masksToBounds = false
        }
        
        // Create content
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Your Life Path Number".translate
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .white.withAlphaComponent(0.7)
        titleLabel.textAlignment = .center
        
        // Number
        let numberLabel = UILabel()
        numberLabel.text = "\(number)"
        numberLabel.font = UIFont.systemFont(ofSize: 80, weight: .semibold)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        
        numberLabel.layer.shadowColor = UIColor.white.cgColor
        numberLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        numberLabel.layer.shadowRadius = 25
        numberLabel.layer.shadowOpacity = 1.0
        numberLabel.layer.masksToBounds = false
        
        // Meaning Title
        let meaningTitleLabel = UILabel()
        meaningTitleLabel.text = meaning.title.translate
        meaningTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        meaningTitleLabel.textColor = .white
        meaningTitleLabel.textAlignment = .center
        meaningTitleLabel.numberOfLines = 0
        
        meaningTitleLabel.layer.shadowColor = UIColor.white.cgColor
        meaningTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        meaningTitleLabel.layer.shadowRadius = 15
        meaningTitleLabel.layer.shadowOpacity = 0.8
        meaningTitleLabel.layer.masksToBounds = false
        
        // Keywords
        let keywordsLabel = UILabel()
        keywordsLabel.text = meaning.keywords.map { $0.translate }.joined(separator: " • ")
        keywordsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        keywordsLabel.textColor = UIColor(hex: "d4a5ff")
        keywordsLabel.textAlignment = .center
        keywordsLabel.numberOfLines = 0
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = .white.withAlphaComponent(0.3)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = meaning.description.translate
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .white.withAlphaComponent(0.95)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        // Add to stack
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(meaningTitleLabel)
        stackView.addArrangedSubview(keywordsLabel)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(descriptionLabel)
        
        resultContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: resultContainer.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: resultContainer.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: resultContainer.trailingAnchor, constant: -25),
            stackView.bottomAnchor.constraint(equalTo: resultContainer.bottomAnchor, constant: -30)
        ])
        
        // Show result with animation
        resultContainer.isHidden = false
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.resultContainer.alpha = 1.0
        }
        
        // Scroll to show result
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollView.scrollRectToVisible(self.resultContainer.frame, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
