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
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
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
        label.text = "Your Reading".translate
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
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
        contentView.addSubview(shareButton)
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
            
            shareButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            shareButton.widthAnchor.constraint(equalToConstant: 25),
            shareButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
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
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    private func displayResults() {
        // Set question text
        if question.isEmpty {
            questionLabel.text = "The cards have spoken...".translate
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
        
        // Card image
        let cardImageView = UIImageView()
        cardImageView.contentMode = .scaleAspectFit
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        cardImageView.layer.cornerRadius = 12
        cardImageView.clipsToBounds = true
        
        // Load card image using same mapping as TarotReadingViewController
        cardImageView.image = getCardImage(for: card.id)
        
        // Content stack
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Position label
        let positionLabel = UILabel()
        positionLabel.text = "\("Card".translate) \(position)"
        positionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        positionLabel.textColor = .white.withAlphaComponent(0.7)
        positionLabel.textAlignment = .center
        
        // Card name
        let nameLabel = UILabel()
        nameLabel.text = card.name.translate
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
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
        arcanaLabel.text = card.arcana.translate
        arcanaLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        arcanaLabel.textColor = .white.withAlphaComponent(0.6)
        arcanaLabel.textAlignment = .center
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = .white.withAlphaComponent(0.2)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Meaning label
        let meaningLabel = UILabel()
        meaningLabel.text = card.upright.translate
        meaningLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        meaningLabel.textColor = .white.withAlphaComponent(0.9)
        meaningLabel.textAlignment = .left
        meaningLabel.numberOfLines = 0
        
        // Keywords
        let keywordsLabel = UILabel()
        let keywordsText = card.keywords.prefix(5).map { $0.translate }.joined(separator: " • ")
        keywordsLabel.text = "✨ " + keywordsText
        keywordsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        keywordsLabel.textColor = UIColor(hex: "d4a5ff")
        keywordsLabel.textAlignment = .center
        keywordsLabel.numberOfLines = 0
        
        // Add to stack
        contentStack.addArrangedSubview(cardImageView)
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
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            // Card image constraints
            cardImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Animate gradient
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            gradient.frame = containerView.bounds
        }
        
        return containerView
    }
    
    // MARK: - Helper Methods
    private func getCardImage(for cardId: Int) -> UIImage? {
        // Convert card name to asset format using card id
        // Format: "00_Fool", "01_Magician", etc.
        let assetName = String(format: "%02d", cardId)
        
        // Try to load image with number prefix
        // The asset names are: 00_Fool, 01_Magician, 02_High_Priestess, etc.
        // We'll try to match by number first
        let cardNames = [
            "00_Fool", "01_Magician", "02_High_Priestess", "03_Empress", "04_Emperor",
            "05_Hierophant", "06_Lovers", "07_Chariot", "08_Strength", "09_Hermit",
            "10_Wheel_of_Fortune", "11_Justice", "12_Hanged_Man", "13_Death", "14_Temperance",
            "15_Devil", "16_Tower", "17_Star", "18_Moon", "19_Sun",
            "20_Judgement", "21_World",
            "22_Ace_of_Wands", "23_Two_of_Wands", "24_Three_of_Wands", "25_Four_of_Wands",
            "26_Five_of_Wands", "27_Six_of_Wands", "28_Seven_of_Wands", "29_Eight_of_Wands",
            "30_Nine_of_Wands", "31_Ten_of_Wands", "32_Page_of_Wands", "33_Knight_of_Wands",
            "34_Queen_of_Wands", "35_King_of_Wands",
            "36_Ace_of_Pentacles", "37_Two_of_Pentacles", "38_Three_of_Pentacles", "39_Four_of_Pentacles",
            "40_Five_of_Pentacles", "41_Six_of_Pentacles", "42_Seven_of_Pentacles", "43_Eight_of_Pentacles",
            "44_Nine_of_Pentacles", "45_Ten_of_Pentacles", "46_Page_of_Pentacles", "47_Knight_of_Pentacles",
            "48_Queen_of_Pentacles", "49_King_of_Pentacles",
            "50_Ace_of_Cups", "51_Two_of_Cups", "52_Three_of_Cups", "53_Four_of_Cups",
            "54_Five_of_Cups", "55_Six_of_Cups", "56_Seven_of_Cups", "57_Eight_of_Cups",
            "58_Nine_of_Cups", "59_Ten_of_Cups", "60_Page_of_Cups", "61_Knight_of_Cups",
            "62_Queen_of_Cups", "63_King_of_Cups",
            "64_Ace_of_Swords", "65_Two_of_Swords", "66_Three_of_Swords", "67_Four_of_Swords",
            "68_Five_of_Swords", "69_Six_of_Swords", "70_Seven_of_Swords", "71_Eight_of_Swords",
            "72_Nine_of_Swords", "73_Ten_of_Swords", "74_Page_of_Swords", "75_Knight_of_Swords",
            "76_Queen_of_Swords", "77_King_of_Swords"
        ]
        
        // Map JSON id to asset name using direct lookup
        var finalAssetName = "tarot_card"
        
        // Map based on card suit from JSON
        if cardId < 22 {
            // Major Arcana (0-21) - direct match
            if cardId < cardNames.count {
                finalAssetName = cardNames[cardId]
            }
        } else if cardId >= 22 && cardId <= 35 {
            // Wands (22-35) - direct match
            finalAssetName = cardNames[cardId]
        } else if cardId >= 36 && cardId <= 49 {
            // Cups in JSON (36-49) → Assets (50-63)
            let assetIndex = 50 + (cardId - 36)
            if assetIndex < cardNames.count {
                finalAssetName = cardNames[assetIndex]
            }
        } else if cardId >= 50 && cardId <= 63 {
            // Swords in JSON (50-63) → Assets (64-77)
            let assetIndex = 64 + (cardId - 50)
            if assetIndex < cardNames.count {
                finalAssetName = cardNames[assetIndex]
            }
        } else if cardId >= 64 && cardId <= 77 {
            // Pentacles in JSON (64-77) → Assets (36-49)
            let assetIndex = 36 + (cardId - 64)
            if assetIndex < cardNames.count {
                finalAssetName = cardNames[assetIndex]
            }
        }
        
        return UIImage(named: finalAssetName)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        // Create share text
        var shareText = "🔮 My Tarot Reading 🔮\n\n"
        
        if !question.isEmpty {
            shareText += "Question: \(question)\n\n"
        }
        
        shareText += "Cards:\n"
        for (index, card) in cards.enumerated() {
            shareText += "\(index + 1). \(card.name.translate)\n"
            shareText += "   \(card.upright.translate)\n\n"
        }
        
        shareText += "✨ Read with FateLine ✨"
        
        // Create activity view controller
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // For iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = shareButton
            popoverController.sourceRect = shareButton.bounds
        }
        
        present(activityViewController, animated: true)
    }
}
