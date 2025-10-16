//
//  TarotReadingViewController.swift
//  fateline
//
//  Created by Müge Deniz on 14.10.2025.
//

import UIKit
import QuartzCore

// MARK: - TarotCard Model
struct TarotCard: Codable {
    let id: Int
    let name: String
    let arcana: String
    let suit: String?
    let upright: String
    let reversed: String
    let keywords: [String]
}

class TarotReadingViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var collectionView: UICollectionView!
    private var selectedCards: Set<Int> = []
    private var tarotCards: [TarotCard] = []
    private let maxSelections = 5
    private var hasPerformedAutoScroll = false
    
    // MARK: - UI Components
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
        label.text = "Choose Your Cards"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
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
        label.text = "Select 5 cards that call to you"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subtle glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.5
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
    
    private let questionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "What guidance do you seek from the cards?"
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .white.withAlphaComponent(0.7)
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        return textView
    }()
    
    private let readCardsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read My Cards", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5
        
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowRadius = 10
        button.titleLabel?.layer.shadowOpacity = 0.8
        button.titleLabel?.layer.masksToBounds = false
        
        return button
    }()
    
    private var buttonGradientLayer: CAGradientLayer?
    private var questionGradientLayer: CAGradientLayer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        loadTarotCards()
        setupUI()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Reset selected cards and question when returning from results
        if hasPerformedAutoScroll {
            selectedCards.removeAll()
            collectionView.reloadData()
            updateButtonState()
            
            // Reset question text to placeholder
            questionTextView.text = "What guidance do you seek from the cards?"
            questionTextView.textColor = .white.withAlphaComponent(0.7)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Perform auto-scroll animation only once to show scrollability
        if !hasPerformedAutoScroll {
            performAutoScrollAnimation()
            hasPerformedAutoScroll = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        buttonGradientLayer?.frame = readCardsButton.bounds
        questionGradientLayer?.frame = questionContainer.bounds
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
        // Create gradient background
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
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(questionContainer)
        questionContainer.addSubview(questionTextView)
        view.addSubview(readCardsButton)
        
        // Setup collection view
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.indicatorStyle = .white
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.decelerationRate = .fast
        collectionView.register(TarotCardCell.self, forCellWithReuseIdentifier: "TarotCardCell")
        
        view.addSubview(collectionView)
        
        // Setup question container gradient
        let questionGradient = CAGradientLayer()
        questionGradient.frame = questionContainer.bounds
        questionGradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.3).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.2).cgColor
        ]
        questionGradient.startPoint = CGPoint(x: 0, y: 0)
        questionGradient.endPoint = CGPoint(x: 1, y: 1)
        questionGradient.cornerRadius = 20
        
        questionContainer.layer.insertSublayer(questionGradient, at: 0)
        questionGradientLayer = questionGradient
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Back button and title at same height
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Increased collection view height
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: questionContainer.topAnchor, constant: -15),
            
            // Question container moved down
            questionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionContainer.bottomAnchor.constraint(equalTo: readCardsButton.topAnchor, constant: -15),
            questionContainer.heightAnchor.constraint(equalToConstant: 80),
            
            questionTextView.topAnchor.constraint(equalTo: questionContainer.topAnchor),
            questionTextView.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor),
            questionTextView.trailingAnchor.constraint(equalTo: questionContainer.trailingAnchor),
            questionTextView.bottomAnchor.constraint(equalTo: questionContainer.bottomAnchor),
            
            // Button at bottom
            readCardsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            readCardsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            readCardsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            readCardsButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        readCardsButton.addTarget(self, action: #selector(readCardsButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        setupButtonGradient()
    }
    
    private func setupDelegates() {
        questionTextView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        // Calculate item size for 6 columns
        let screenWidth = UIScreen.main.bounds.width - 40 // 20 padding on each side
        let totalSpacing = 5 * 8 // 5 spaces between 6 items
        let itemWidth = (screenWidth - CGFloat(totalSpacing)) / 6
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        
        return layout
    }
    
    private func setupButtonGradient() {
        // Remove existing gradient
        buttonGradientLayer?.removeFromSuperlayer()
        
        // Create gradient
        let gradient = CAGradientLayer()
        gradient.frame = readCardsButton.bounds
        gradient.colors = [
            UIColor(hex: "5D2F77").cgColor,
            UIColor(hex: "6B3F69").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 25
        
        readCardsButton.layer.insertSublayer(gradient, at: 0)
        buttonGradientLayer = gradient
        
        // Add glow effect
        readCardsButton.layer.shadowColor = UIColor(hex: "6B3F69").cgColor
        readCardsButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        readCardsButton.layer.shadowRadius = 20
        readCardsButton.layer.shadowOpacity = 0.8
    }
    
    private func loadTarotCards() {
        guard let url = Bundle.main.url(forResource: "tarot_meanings", withExtension: "json") else {
            print("Could not find tarot_meanings.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            tarotCards = try decoder.decode([TarotCard].self, from: data)
            collectionView?.reloadData()
        } catch {
            print("Error loading/decoding tarot cards: \(error)")
        }
    }
    
    private func updateButtonState() {
        let isEnabled = selectedCards.count == maxSelections
        readCardsButton.isEnabled = isEnabled
        
        UIView.animate(withDuration: 0.3) {
            self.readCardsButton.alpha = isEnabled ? 1.0 : 0.5
        }
        
        // Update subtitle
        let remainingSelections = maxSelections - selectedCards.count
        if remainingSelections > 0 {
            subtitleLabel.text = "Select \(remainingSelections) more card\(remainingSelections == 1 ? "" : "s")"
        } else {
            subtitleLabel.text = "Perfect! Now ask your question"
        }
    }
    
    private func performAutoScrollAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Ensure we have content
            let itemCount = self.collectionView.numberOfItems(inSection: 0)
            guard itemCount > 30 else { return }
            
            // Scroll to last item instantly
            let lastItem = itemCount - 1
            self.collectionView.scrollToItem(at: IndexPath(item: lastItem, section: 0), at: .bottom, animated: false)
            
            // Small pause, then scroll back to top
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.collectionView.flashScrollIndicators()
                
                // Scroll to first item with smooth animation
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                
                // Flash when complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.collectionView.flashScrollIndicators()
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func readCardsButtonTapped() {
        guard selectedCards.count == maxSelections else { return }
        
        // Get selected card meanings
        let selectedCardMeanings = selectedCards.compactMap { cardId in
            tarotCards.first { $0.id == cardId }
        }
        
        // Navigate to results screen (you'll need to create this)
        let question = questionTextView.text == "What guidance do you seek from the cards?" ? "" : questionTextView.text
        showReadingResults(cards: selectedCardMeanings, question: question ?? "")
    }
    
    private func showReadingResults(cards: [TarotCard], question: String) {
        // Navigate to results view controller
        let resultsVC = TarotResultsViewController(cards: cards, question: question)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension TarotReadingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(tarotCards.count, 78) // Show max 78 cards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TarotCardCell", for: indexPath) as! TarotCardCell
        
        let cardId = indexPath.item
        let isSelected = selectedCards.contains(cardId)
        
        cell.configure(cardId: cardId, isSelected: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TarotReadingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardId = indexPath.item
        
        if selectedCards.contains(cardId) {
            // Deselect card
            selectedCards.remove(cardId)
        } else if selectedCards.count < maxSelections {
            // Select card
            selectedCards.insert(cardId)
        }
        
        // Reload the cell to update selection state
        collectionView.reloadItems(at: [indexPath])
        updateButtonState()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

// MARK: - UITextViewDelegate
extension TarotReadingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What guidance do you seek from the cards?" {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What guidance do you seek from the cards?"
            textView.textColor = .white.withAlphaComponent(0.7)
        }
    }
}

// MARK: - TarotCardCell
class TarotCardCell: UICollectionViewCell {
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let selectionOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "6B3F69").withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        imageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        // Add glow effect
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 1.0
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cardImageView)
        contentView.addSubview(selectionOverlay)
        contentView.addSubview(checkmarkImageView)
        
        // Add subtle shadow to card
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectionOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(cardId: Int, isSelected: Bool) {
        // Load card image (assuming you have tarot_card_0, tarot_card_1, etc.)
        let imageName = "tarot_card_\(cardId)"
        cardImageView.image = UIImage(named: imageName) ?? UIImage(named: "tarot_card")
        
        // Update selection state
        selectionOverlay.isHidden = !isSelected
        checkmarkImageView.isHidden = !isSelected
        
        // Add selection animation
        if isSelected {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
