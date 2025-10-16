//
//  PremiumViewController.swift
//  fateline
//
//  Created by Müge Deniz on 13.10.2025.
//

import UIKit
import StoreKit

class PremiumViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var selectedPlan: PremiumPlan = .yearly
    
    private let features = [
        "Unlimited Tarot Readings",
        "Advanced Zodiac Compatibility",
        "Life & Soul Card Insights",
        "Spirit Animal Discovery",
        "Deep Numerology Analysis",
        "Exclusive Premium Content"
    ]
    
    // MARK: - UI Components
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.8
        
        return button
    }()
    
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "premium_crown")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtle glow
        imageView.layer.shadowColor = UIColor(hex: "FFD700").cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = 15
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtle glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.4
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Experience the full mystical journey"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Animated Feature Label
    private let animatedFeatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 20
        label.layer.shadowOpacity = 1.0
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private var currentFeatureIndex = 0
    private var featureTimer: Timer?
    
    // Plan Cards
    private let weeklyPlanCard: PlanCard = {
        let card = PlanCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let yearlyPlanCard: PlanCard = {
        let card = PlanCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 28
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Advanced gradient background (matching app background)
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "2d1b3d").cgColor,  // Same as background
            UIColor(hex: "4a1e4f").cgColor,  // Same as background
            UIColor(hex: "1a0a2e").cgColor   // Same as background
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 28
        button.layer.insertSublayer(gradient, at: 0)
        
        // Metallic shine overlay
        let shineLayer = CAGradientLayer()
        shineLayer.colors = [
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        shineLayer.locations = [0, 0.3, 0.6, 1]
        shineLayer.startPoint = CGPoint(x: 0, y: 0)
        shineLayer.endPoint = CGPoint(x: 1, y: 1)
        shineLayer.cornerRadius = 28
        button.layer.insertSublayer(shineLayer, at: 1)
        
        // Border for extra polish
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        
        // Strong white glow
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 25
        button.layer.shadowOpacity = 0.8
        button.layer.masksToBounds = false
        
        return button
    }()
    
    private var subscribeButtonGradient: CAGradientLayer?
    private var subscribeButtonShine: CAGradientLayer?
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms of Service • Privacy Policy"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchases", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupPlans()
        addAnimations()
        startFeatureAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        
        // Update subscribe button gradient layers
        if subscribeButtonGradient == nil {
            if let gradient = subscribeButton.layer.sublayers?.first as? CAGradientLayer {
                subscribeButtonGradient = gradient
            }
        }
        if subscribeButtonShine == nil {
            if let shine = subscribeButton.layer.sublayers?[1] as? CAGradientLayer {
                subscribeButtonShine = shine
            }
        }
        subscribeButtonGradient?.frame = subscribeButton.bounds
        subscribeButtonShine?.frame = subscribeButton.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        featureTimer?.invalidate()
        featureTimer = nil
    }
    
    // MARK: - Setup
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(hex: "1a0a2e").cgColor,
            UIColor(hex: "2d1b3d").cgColor,
            UIColor(hex: "4a1e4f").cgColor,
            UIColor(hex: "1a0a2e").cgColor
        ]
        gradient.locations = [0.0, 0.3, 0.7, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupUI() {
        view.addSubview(closeButton)
        view.addSubview(crownImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(animatedFeatureLabel)
        view.addSubview(weeklyPlanCard)
        view.addSubview(yearlyPlanCard)
        view.addSubview(subscribeButton)
        view.addSubview(restoreButton)
        view.addSubview(termsLabel)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            crownImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            crownImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 110),
            crownImageView.heightAnchor.constraint(equalToConstant: 110),
            
            titleLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            animatedFeatureLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            animatedFeatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            animatedFeatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            animatedFeatureLabel.heightAnchor.constraint(equalToConstant: 100),
            
            yearlyPlanCard.topAnchor.constraint(equalTo: animatedFeatureLabel.bottomAnchor, constant: 40),
            yearlyPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yearlyPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            yearlyPlanCard.heightAnchor.constraint(equalToConstant: 110),
            
            weeklyPlanCard.topAnchor.constraint(equalTo: yearlyPlanCard.bottomAnchor, constant: 12),
            weeklyPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weeklyPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weeklyPlanCard.heightAnchor.constraint(equalToConstant: 100),
            
            subscribeButton.topAnchor.constraint(equalTo: weeklyPlanCard.bottomAnchor, constant: 25),
            subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            subscribeButton.heightAnchor.constraint(equalToConstant: 60),
            
            restoreButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 12),
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            termsLabel.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 10),
            termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTouchDown), for: .touchDown)
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        let weeklyTap = UITapGestureRecognizer(target: self, action: #selector(weeklyPlanTapped))
        weeklyPlanCard.addGestureRecognizer(weeklyTap)
        
        let yearlyTap = UITapGestureRecognizer(target: self, action: #selector(yearlyPlanTapped))
        yearlyPlanCard.addGestureRecognizer(yearlyTap)
        
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        termsLabel.addGestureRecognizer(termsTap)
    }
    
    private func startFeatureAnimation() {
        // Show first feature
        showNextFeature()
        
        // Start timer for cycling features
        featureTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.showNextFeature()
        }
    }
    
    private func showNextFeature() {
        let feature = features[currentFeatureIndex]
        
        // Fade out
        UIView.animate(withDuration: 0.5, animations: {
            self.animatedFeatureLabel.alpha = 0
            self.animatedFeatureLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            // Update text
            self.animatedFeatureLabel.text = feature
            
            // Fade in
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
                self.animatedFeatureLabel.alpha = 1.0
                self.animatedFeatureLabel.transform = .identity
            })
            
            // Move to next feature
            self.currentFeatureIndex = (self.currentFeatureIndex + 1) % self.features.count
        }
    }
    
    private func setupPlans() {
        weeklyPlanCard.configure(
            title: "Weekly",
            price: "",
            period: "per week",
            badge: nil,
            isSelected: selectedPlan == .weekly
        )
        
        yearlyPlanCard.configure(
            title: "Yearly",
            price: "",
            period: "per year",
            badge: "BEST VALUE - Save 50%",
            isSelected: selectedPlan == .yearly
        )
    }
    
    private func addAnimations() {
        // Crown subtle float animation
        let float = CABasicAnimation(keyPath: "transform.translation.y")
        float.fromValue = -3
        float.toValue = 3
        float.duration = 2.5
        float.autoreverses = true
        float.repeatCount = .infinity
        float.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        crownImageView.layer.add(float, forKey: "float")
        
        // Crown subtle glow pulse
        let pulse = CABasicAnimation(keyPath: "shadowRadius")
        pulse.fromValue = 12
        pulse.toValue = 18
        pulse.duration = 2.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        crownImageView.layer.add(pulse, forKey: "pulse")
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func weeklyPlanTapped() {
        selectedPlan = .weekly
        updatePlanSelection()
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    @objc private func yearlyPlanTapped() {
        selectedPlan = .yearly
        updatePlanSelection()
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func updatePlanSelection() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.weeklyPlanCard.setSelected(self.selectedPlan == .weekly)
            self.yearlyPlanCard.setSelected(self.selectedPlan == .yearly)
        }
    }
    
    @objc private func subscribeButtonTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.subscribeButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.subscribeButton.alpha = 0.9
        })
    }
    
    @objc private func subscribeButtonTouchUp() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.subscribeButton.transform = .identity
            self.subscribeButton.alpha = 1.0
        })
    }
    
    @objc private func subscribeButtonTapped() {
        // Show loading
        subscribeButton.isEnabled = false
        subscribeButton.setTitle("Processing...", for: .normal)
        
        // TODO: Implement RevenueCat purchase
        // For now, just simulate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.subscribeButton.isEnabled = true
            self.subscribeButton.setTitle("Continue", for: .normal)
            
            // Show success or handle purchase
            print("Purchase initiated for plan: \(self.selectedPlan)")
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    @objc private func restoreButtonTapped() {
        // TODO: Implement RevenueCat restore purchases
        print("Restore purchases tapped")
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func termsLabelTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Terms of Service", style: .default) { _ in
            if let url = URL(string: "https://yourapp.com/terms") {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Privacy Policy", style: .default) { _ in
            if let url = URL(string: "https://yourapp.com/privacy") {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    deinit {
        featureTimer?.invalidate()
    }
}

// MARK: - PremiumPlan Enum
enum PremiumPlan {
    case weekly
    case yearly
}

// MARK: - PaddedLabel
class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 14)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the background is properly rounded
        layer.cornerRadius = 12
        layer.masksToBounds = false
        // Force badge to be on top of card border
        layer.zPosition = 100
    }
}

// MARK: - PlanCard
class PlanCard: UIView {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let periodLabel = UILabel()
    private let badgeLabel = PaddedLabel()
    private let checkmarkImageView = UIImageView()
    private var gradientLayer: CAGradientLayer?
    private var borderLayer: CAShapeLayer?  // Custom border layer that goes behind badge
    private var isSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        
        // Update custom border layer
        if let borderLayer = borderLayer {
            borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 22).cgPath
        }
        
        // Ensure badge stays on top after layout
        bringSubviewToFront(badgeLabel)
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 22
        clipsToBounds = false
        layer.masksToBounds = false
        
        // Remove native border, use custom border layer instead
        // This allows badge to sit on top of the border
        let border = CAShapeLayer()
        border.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        border.fillColor = UIColor.clear.cgColor
        border.lineWidth = 2
        border.zPosition = 1  // Below badge (badge is zPosition 100)
        layer.insertSublayer(border, at: 1)  // Above gradient, below content
        borderLayer = border
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.5).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.4).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 22
        gradient.zPosition = -1
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Price
        priceLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        priceLabel.textColor = .white
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Period
        periodLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        periodLabel.textColor = .white.withAlphaComponent(0.7)
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Badge (must be fully opaque to cover card border)
        badgeLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = UIColor.mysticalPurple  // Fully opaque
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 12
        badgeLabel.clipsToBounds = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.isHidden = true
        badgeLabel.layer.borderWidth = 2
        badgeLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
        badgeLabel.layer.zPosition = 100
        
        // Shadow for depth
        badgeLabel.layer.shadowColor = UIColor.black.cgColor
        badgeLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        badgeLabel.layer.shadowRadius = 8
        badgeLabel.layer.shadowOpacity = 0.6
        badgeLabel.layer.masksToBounds = false
        
        // Checkmark
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        checkmarkImageView.tintColor = .white
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.alpha = 0
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(periodLabel)
        addSubview(checkmarkImageView)
        addSubview(badgeLabel)  // Badge must be added LAST to be on top
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            periodLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            periodLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            
            badgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -15),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            checkmarkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 28),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(title: String, price: String, period: String, badge: String?, isSelected: Bool) {
        titleLabel.text = title
        priceLabel.text = price
        periodLabel.text = period
        
        if let badge = badge {
            badgeLabel.text = badge
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }
        
        setSelected(isSelected)
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        
        if selected {
            // Update custom border layer
            borderLayer?.strokeColor = UIColor.white.cgColor
            borderLayer?.lineWidth = 2.5
            checkmarkImageView.alpha = 1
            
            // White-purple glow
            layer.shadowColor = UIColor.mysticalPurple.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 15
            layer.shadowOpacity = 0.8
            layer.masksToBounds = false
        } else {
            // Update custom border layer
            borderLayer?.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
            borderLayer?.lineWidth = 2
            checkmarkImageView.alpha = 0
            
            // Subtle purple shadow
            layer.shadowColor = UIColor.mysticalPurple.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 8
            layer.shadowOpacity = 0.3
            layer.masksToBounds = false
        }
        
        // Force badge to front to cover card border
        badgeLabel.layer.zPosition = 100
        bringSubviewToFront(badgeLabel)
    }
}
