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
    let emoji: String?
    let imageName: String?
    let gradientColors: [String]
    let size: FeatureSize
}

enum FeatureSize {
    case small  // 1 column
    case medium // 1 column, taller
    case large  // 2 columns
}

class MainViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var collectionView: UICollectionView!
    
    private let features: [Feature] = [
        Feature(title: "Tarot Reading", emoji: nil, imageName: "tarot", gradientColors: ["3d1f4f", "5d2f77"], size: .large),
        Feature(title: "Zodiac Compatibility", emoji: nil, imageName: "zodiac_cell", gradientColors: ["2d1b3d", "4a1e4f"], size: .medium),
        Feature(title: "Life & Soul Card", emoji: "🃏", imageName: nil, gradientColors: ["2d1530", "4a1e4f"], size: .small),
        Feature(title: "Spirit Animal", emoji: nil, imageName: "sprit_animal", gradientColors: ["1f0f2e", "3d1f4f"], size: .medium),
        Feature(title: "Numerology", emoji: nil, imageName: "numerology", gradientColors: ["150a1e", "2d1530"], size: .small)
    ]
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FateLine"
        label.font = UIFont.QuintessentialRegular(size: 36)
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        print("Settings button tapped")
        // TODO: Navigate to settings
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
        let feature = features[indexPath.item]
        print("Selected: \(feature.title)")
        // TODO: Navigate to feature
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feature = features[indexPath.item]
        let width = collectionView.bounds.width
        let spacing: CGFloat = 15
        
        switch feature.size {
        case .small:
            let cellWidth = (width - spacing) / 2
            return CGSize(width: cellWidth, height: 200)
        case .medium:
            let cellWidth = (width - spacing) / 2
            return CGSize(width: cellWidth, height: 240)
        case .large:
            return CGSize(width: width, height: 220)
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
        
        // Add subtle glow to icon
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.4
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.QuintessentialRegular(size: 23)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = containerView.bounds
        borderGradientLayer?.frame = contentView.bounds
        glassLayer?.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height * 0.5)
    }
    
    private func setupUI() {
        // Setup main content view
        contentView.layer.cornerRadius = 22
        contentView.clipsToBounds = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -35),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
        // Add glassmorphism effect (more subtle for dark theme)
        let glass = CALayer()
        glass.backgroundColor = UIColor.white.withAlphaComponent(0.05).cgColor
        glass.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height * 0.5)
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
        
        // Show emoji or image
        if let imageName = feature.imageName {
            emojiLabel.isHidden = true
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: imageName)
        } else {
            emojiLabel.isHidden = false
            iconImageView.isHidden = true
            emojiLabel.text = feature.emoji
        }
        
        // Remove existing gradients
        gradientLayer?.removeFromSuperlayer()
        borderGradientLayer?.removeFromSuperlayer()
        
        // Create main gradient (much darker)
        let gradient = CAGradientLayer()
        gradient.frame = containerView.bounds
        let color1 = UIColor(hex: feature.gradientColors[0])
        let color2 = UIColor(hex: feature.gradientColors[1])
        
        // Darken colors by mixing with black
        let darkerColor1 = color1.withAlphaComponent(1.0)
        let darkerColor2 = color2.withAlphaComponent(0.95)
        
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
        
        // Create border gradient effect (darker)
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
        
        // Enhanced glow effect
        layer.shadowColor = color2.cgColor
        layer.shadowOpacity = 0.6
        
        // Add subtle shine animation
        addShineEffect()
    }
    
    private func addShineEffect() {
        // Create a very subtle shine that moves across
        let shineLayer = CAGradientLayer()
        shineLayer.frame = containerView.bounds
        shineLayer.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(0.08).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        shineLayer.locations = [0.0, 0.5, 1.0]
        shineLayer.startPoint = CGPoint(x: -1, y: -1)
        shineLayer.endPoint = CGPoint(x: 0, y: 0)
        
        containerView.layer.addSublayer(shineLayer)
        
        // Animate shine (slower for darker theme)
        let animation = CABasicAnimation(keyPath: "startPoint")
        animation.fromValue = CGPoint(x: -1, y: -1)
        animation.toValue = CGPoint(x: 1, y: 1)
        animation.duration = 4.0
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endAnimation = CABasicAnimation(keyPath: "endPoint")
        endAnimation.fromValue = CGPoint(x: 0, y: 0)
        endAnimation.toValue = CGPoint(x: 2, y: 2)
        endAnimation.duration = 4.0
        endAnimation.repeatCount = .infinity
        endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        shineLayer.add(animation, forKey: "shine")
        shineLayer.add(endAnimation, forKey: "shineEnd")
    }
}
