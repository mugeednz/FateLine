//
//  TarotResultsViewController.swift
//  fateline
//
//  Created by Müge Deniz on 14.10.2025.
//

import UIKit

class TarotResultsViewController: UIViewController {
    
    // MARK: - Properties
    private var cards: [TarotCard]
    private var question: String
    private var gradientLayer: CAGradientLayer?
    
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
        
        // Add glow
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.8
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Reading"
        label.font = UIFont.QuintessentialRegular(size: 36)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 0.8
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let questionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.QuintessentialRegular(size: 18)
        label.textColor = .white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var questionGradientLayer: CAGradientLayer?
    
    // MARK: - Initialization
    init(cards: [TarotCard], question: String) {
        self.cards = cards
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        displayResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        questionGradientLayer?.frame = questionContainer.bounds
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
        contentView.addSubview(questionContainer)
        questionContainer.addSubview(questionLabel)
        contentView.addSubview(cardsStackView)
        
        // Setup question container gradient
        let questionGradient = CAGradientLayer()
        questionGradient.frame = questionContainer.bounds
        questionGradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        questionGradient.startPoint = CGPoint(x: 0, y: 0)
        questionGradient.endPoint = CGPoint(x: 1, y: 1)
        questionGradient.cornerRadius = 20
        questionContainer.layer.insertSublayer(questionGradient, at: 0)
        questionGradientLayer = questionGradient
        
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
            
            questionContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            questionContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            questionContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            questionLabel.topAnchor.constraint(equalTo: questionContainer.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: questionContainer.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: questionContainer.bottomAnchor, constant: -20),
            
            cardsStackView.topAnchor.constraint(equalTo: questionContainer.bottomAnchor, constant: 30),
            cardsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func displayResults() {
        // Set question text
        if question.isEmpty {
            questionLabel.text = "The cards have spoken..."
        } else {
            questionLabel.text = "\"" + question + "\""
        }
        
        // Display each card
        for (index, card) in cards.enumerated() {
            let cardView = createCardView(card: card, position: index + 1)
            cardsStackView.addArrangedSubview(cardView)
        }
    }
    
    private func createCardView(card: TarotCard, position: Int) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        // Gradient background
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "3d1f4f").cgColor,
            UIColor(hex: "5d2f77").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        containerView.layer.insertSublayer(gradient, at: 0)
        
        // Border
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        
        // Shadow
        containerView.layer.shadowColor = UIColor(hex: "5d2f77").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 15
        containerView.layer.shadowOpacity = 0.5
        
        // Content stack
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Position label
        let positionLabel = UILabel()
        positionLabel.text = "Card \(position)"
        positionLabel.font = UIFont.QuintessentialRegular(size: 16)
        positionLabel.textColor = .white.withAlphaComponent(0.7)
        positionLabel.textAlignment = .center
        
        // Card name
        let nameLabel = UILabel()
        nameLabel.text = card.name
        nameLabel.font = UIFont.QuintessentialRegular(size: 24)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        // Add glow to name
        nameLabel.layer.shadowColor = UIColor.white.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowRadius = 10
        nameLabel.layer.shadowOpacity = 0.6
        nameLabel.layer.masksToBounds = false
        
        // Arcana type
        let arcanaLabel = UILabel()
        arcanaLabel.text = card.arcana
        arcanaLabel.font = UIFont.QuintessentialRegular(size: 14)
        arcanaLabel.textColor = .white.withAlphaComponent(0.6)
        arcanaLabel.textAlignment = .center
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = .white.withAlphaComponent(0.2)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Meaning label
        let meaningLabel = UILabel()
        meaningLabel.text = card.upright
        meaningLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        meaningLabel.textColor = .white.withAlphaComponent(0.9)
        meaningLabel.textAlignment = .left
        meaningLabel.numberOfLines = 0
        
        // Keywords
        let keywordsLabel = UILabel()
        let keywordsText = card.keywords.prefix(5).joined(separator: " • ")
        keywordsLabel.text = "✨ " + keywordsText
        keywordsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        keywordsLabel.textColor = UIColor(hex: "d4a5ff")
        keywordsLabel.textAlignment = .center
        keywordsLabel.numberOfLines = 0
        
        // Add to stack
        contentStack.addArrangedSubview(positionLabel)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(arcanaLabel)
        contentStack.addArrangedSubview(divider)
        contentStack.addArrangedSubview(meaningLabel)
        contentStack.addArrangedSubview(keywordsLabel)
        
        containerView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Animate gradient
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            gradient.frame = containerView.bounds
        }
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
