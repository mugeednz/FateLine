//
//  MainViewController.swift
//  fateline
//
//  Created by Müge Deniz on 13.10.2025.
//

import UIKit

// MARK: - Feature Model
struct Feature {
    let title: String
    let imageName: String?
    let gradientColors: [String]
    let size: FeatureSize
}

enum FeatureSize {
    case banner  // Full width banner
    case feature // Equal sized feature cards (2 columns)
}

class MainViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var collectionView: UICollectionView!
    
    private let features: [Feature] = [
        // Tarot Reading as banner (top, full width)
        Feature(title: "Tarot Reading".translate, imageName: "tarot", gradientColors: ["3d1f4f", "5d2f77"], size: .banner),
        // Other feature cards (all equal size - 4 remaining features)
        Feature(title: "Zodiac Compatibility".translate, imageName: "zodiac_cell", gradientColors: ["2d1b3d", "4a1e4f"], size: .feature),
        Feature(title: "Life & Soul Card".translate, imageName: "", gradientColors: ["2d1530", "4a1e4f"], size: .feature),
        Feature(title: "Spirit Animal".translate, imageName: "sprit_animal", gradientColors: ["1f0f2e", "3d1f4f"], size: .feature),
        Feature(title: "Numerology".translate, imageName: "numerology", gradientColors: ["150a1e", "2d1530"], size: .feature)
    ]
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FateLine".translate
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 0.8
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        let image = UIImage(systemName: "gearshape.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.6
        
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
        // Remove existing gradient if any
        gradientLayer?.removeFromSuperlayer()
        
        // Create gradient layer
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
        
        // Insert gradient at the bottom
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupUI() {
        // Add title
        view.addSubview(titleLabel)
        
        // Add settings button
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        // Setup collection view
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FeatureCell.self, forCellWithReuseIdentifier: "FeatureCell")
        
        // Prevent any visual selection behavior
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delaysContentTouches = false
        
        // Disable selection highlighting
        if #available(iOS 14.0, *) {
            collectionView.allowsFocus = false
        }
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Settings button constraints
            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCell", for: indexPath) as! FeatureCell
        let feature = features[indexPath.item]
        cell.configure(with: feature)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Immediately deselect to prevent any visual change
        collectionView.deselectItem(at: indexPath, animated: false)
        
        // Force cell to reset its visual state
        if let cell = collectionView.cellForItem(at: indexPath) as? FeatureCell {
            cell.resetVisualState()
        }
        
        let feature = features[indexPath.item]
        
        // Feature cards - navigate to respective screens
        switch feature.title {
        case "Tarot Reading".translate:
            let tarotVC = TarotReadingViewController()
            navigationController?.pushViewController(tarotVC, animated: true)
        case "Zodiac Compatibility".translate:
            let zodiacVC = ZodiacViewController()
            navigationController?.pushViewController(zodiacVC, animated: true)
        case "Life & Soul Card".translate:
            let lifeSoulVC = LifeandSoulViewController()
            navigationController?.pushViewController(lifeSoulVC, animated: true)
        case "Spirit Animal".translate:
            let animalVC = AnimalsViewController()
            navigationController?.pushViewController(animalVC, animated: true)
        case "Numerology".translate:
            let numerologyVC = NumerologyViewController()
            navigationController?.pushViewController(numerologyVC, animated: true)
        default:
            print("Selected: \(feature.title)")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feature = features[indexPath.item]
        let width = collectionView.bounds.width
        let spacing: CGFloat = 15
        
        switch feature.size {
        case .banner:
            // Full width banner (taller and more prominent)
            return CGSize(width: width, height: 220)
        case .feature:
            // Equal sized feature cards (2 columns)
            let cellWidth = (width - spacing) / 2
            return CGSize(width: cellWidth, height: 200)
        }
    }
}

// MARK: - FeatureCell
class FeatureCell: UICollectionViewCell {
    
    private var gradientLayer: CAGradientLayer?
    private var borderGradientLayer: CAGradientLayer?
    private var glassLayer: CALayer?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.8
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        // Add subtle glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.5
        label.layer.masksToBounds = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Ensure no visual changes persist
        contentView.backgroundColor = .clear
        containerView.alpha = 1.0
        containerView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    func resetVisualState() {
        // Force reset all visual properties
        contentView.backgroundColor = .clear
        containerView.alpha = 1.0
        containerView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = containerView.bounds
        borderGradientLayer?.frame = contentView.bounds
        // glassLayer frame is set in configure method based on banner/feature type
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Prevent any visual changes
        contentView.backgroundColor = .clear
        containerView.alpha = 1.0
        backgroundColor = .clear
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // Ensure state remains unchanged
        contentView.backgroundColor = .clear
        containerView.alpha = 1.0
        backgroundColor = .clear
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Ensure state remains unchanged
        contentView.backgroundColor = .clear
        containerView.alpha = 1.0
        backgroundColor = .clear
    }
    
    override var isSelected: Bool {
        get {
            return false // Always return false
        }
        set {
            // Prevent selection and maintain visual state
            super.isSelected = false
            DispatchQueue.main.async {
                self.contentView.backgroundColor = .clear
                self.containerView.alpha = 1.0
                self.containerView.backgroundColor = .clear
                self.backgroundColor = .clear
            }
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return false // Always return false
        }
        set {
            // Prevent highlight and maintain visual state
            super.isHighlighted = false
            DispatchQueue.main.async {
                self.contentView.backgroundColor = .clear
                self.containerView.alpha = 1.0
                self.containerView.backgroundColor = .clear
                self.backgroundColor = .clear
            }
        }
    }
    
    
    private func setupUI() {
        // Setup main content view
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 22
        contentView.clipsToBounds = false
        
        // Prevent selection visual changes completely
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .clear
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -25),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        // Glassmorphism will be added dynamically in configure method
        let glass = CALayer()
        containerView.layer.addSublayer(glass)
        glassLayer = glass
        
        // Multi-layer shadows for depth
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        
        // Inner border effect (subtle for dark theme)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
    }
    
    func configure(with feature: Feature) {
        titleLabel.text = feature.title
        
        // Check if this is a banner card
        let isBanner = feature.size == .banner
        
        // Configure subtitle and styling for banner
        if isBanner {
            subtitleLabel.isHidden = false
            subtitleLabel.text = "Unlock the secrets of your destiny through ancient wisdom".translate
            
            // Keep icon size consistent but slightly bigger for banner
            iconImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            // Make title larger and more prominent for banner
            titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            
            // Consistent glow for banner text
            titleLabel.layer.shadowRadius = 15
            titleLabel.layer.shadowOpacity = 1.0
            subtitleLabel.layer.shadowRadius = 10
            subtitleLabel.layer.shadowOpacity = 0.7
            
            // Enhanced glassmorphism for banner
            glassLayer?.backgroundColor = UIColor.white.withAlphaComponent(0.0).cgColor
            glassLayer?.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height * 0.4)
        } else {
            subtitleLabel.isHidden = true
            // Keep icon size consistent for feature cards
            iconImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            // Normal font for feature cards
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            titleLabel.layer.shadowRadius = 10
            titleLabel.layer.shadowOpacity = 0.8
            
            // Subtle glassmorphism for feature cards
            glassLayer?.backgroundColor = UIColor.white.withAlphaComponent(0.05).cgColor
            glassLayer?.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height * 0.5)
        }
        
        
        // Show image or emoji
        if let imageName = feature.imageName, !imageName.isEmpty {
            emojiLabel.isHidden = true
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: imageName)
        } else {
            emojiLabel.isHidden = false
            iconImageView.isHidden = true
            emojiLabel.text = "🃏"
        }
        
        // Remove existing gradients
        gradientLayer?.removeFromSuperlayer()
        borderGradientLayer?.removeFromSuperlayer()
        
        let color1 = UIColor(hex: feature.gradientColors[0])
        let color2 = UIColor(hex: feature.gradientColors[1])
        
        if isBanner {
            // BANNER STYLE - Advanced and premium look
            
            // Create rich gradient with app's main colors
            let gradient = CAGradientLayer()
            gradient.frame = containerView.bounds
            gradient.colors = [
                UIColor.mainBackgroundTop.cgColor,
                UIColor.mysticalPurple.cgColor,
                UIColor.mainBackgroundBottom.cgColor,
                UIColor.mysticalPurple.cgColor
            ]
            gradient.locations = [0.0, 0.3, 0.7, 1.0]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            containerView.layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
            
            // Create premium border gradient
            let borderGradient = CAGradientLayer()
            borderGradient.frame = contentView.bounds
            borderGradient.colors = [
                UIColor.white.withAlphaComponent(0.4).cgColor,
                UIColor.mysticalPurple.withAlphaComponent(0.8).cgColor,
                UIColor.white.withAlphaComponent(0.4).cgColor
            ]
            borderGradient.startPoint = CGPoint(x: 0, y: 0)
            borderGradient.endPoint = CGPoint(x: 1, y: 1)
            borderGradient.cornerRadius = 22
            
            contentView.layer.insertSublayer(borderGradient, at: 0)
            borderGradientLayer = borderGradient
            
            // Enhanced white glow for banner
            layer.shadowColor = UIColor.white.cgColor
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 25
            layer.shadowOffset = CGSize(width: 0, height: 0)
            
            // Add stronger border for banner
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            
        } else {
            // FEATURE CARD STYLE - Original darker style
            
            let darkerColor1 = color1.withAlphaComponent(1.0)
            let darkerColor2 = color2.withAlphaComponent(0.95)
            
            let gradient = CAGradientLayer()
            gradient.frame = containerView.bounds
            gradient.colors = [
                darkerColor1.cgColor,
                darkerColor2.cgColor,
                darkerColor1.cgColor
            ]
            gradient.locations = [0.0, 0.5, 1.0]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            containerView.layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
            
            let borderGradient = CAGradientLayer()
            borderGradient.frame = contentView.bounds
            borderGradient.colors = [
                UIColor.white.withAlphaComponent(0.15).cgColor,
                color2.withAlphaComponent(0.8).cgColor,
                UIColor.white.withAlphaComponent(0.05).cgColor
            ]
            borderGradient.startPoint = CGPoint(x: 0, y: 0)
            borderGradient.endPoint = CGPoint(x: 1, y: 1)
            borderGradient.cornerRadius = 22
            
            contentView.layer.insertSublayer(borderGradient, at: 0)
            borderGradientLayer = borderGradient
            
            layer.shadowColor = color2.cgColor
            layer.shadowOpacity = 0.6
            
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        }
        
        // Add subtle shine animation (stronger for banner)
        addShineEffect(isBanner: isBanner)
    }
    
    private func addShineEffect(isBanner: Bool) {
        // Create shine effect (stronger for banner)
        let shineLayer = CAGradientLayer()
        shineLayer.frame = containerView.bounds
        
        if isBanner {
            // Stronger shine for banner
            shineLayer.colors = [
                UIColor.white.withAlphaComponent(0.0).cgColor,
                UIColor.white.withAlphaComponent(0.2).cgColor,
                UIColor.white.withAlphaComponent(0.0).cgColor
            ]
        } else {
            // Subtle shine for feature cards
            shineLayer.colors = [
                UIColor.white.withAlphaComponent(0.0).cgColor,
                UIColor.white.withAlphaComponent(0.08).cgColor,
                UIColor.white.withAlphaComponent(0.0).cgColor
            ]
        }
        
        shineLayer.locations = [0.0, 0.5, 1.0]
        shineLayer.startPoint = CGPoint(x: -1, y: -1)
        shineLayer.endPoint = CGPoint(x: 0, y: 0)
        
        containerView.layer.addSublayer(shineLayer)
        
        // Animate shine (faster for banner)
        let duration: Double = isBanner ? 3.0 : 4.0
        
        let animation = CABasicAnimation(keyPath: "startPoint")
        animation.fromValue = CGPoint(x: -1, y: -1)
        animation.toValue = CGPoint(x: 1, y: 1)
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endAnimation = CABasicAnimation(keyPath: "endPoint")
        endAnimation.fromValue = CGPoint(x: 0, y: 0)
        endAnimation.toValue = CGPoint(x: 2, y: 2)
        endAnimation.duration = duration
        endAnimation.repeatCount = .infinity
        endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        shineLayer.add(animation, forKey: "shine")
        shineLayer.add(endAnimation, forKey: "shineEnd")
    }
}
