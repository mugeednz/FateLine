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
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold)
        imageView.image = UIImage(systemName: "crown.fill", withConfiguration: config)
        imageView.tintColor = UIColor(hex: "FFD700")
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
        label.text = "Unlock Premium"
        label.font = UIFont.QuintessentialRegular(size: 38)
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
    
    // Features Container
    private let featuresContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        return view
    }()
    
    private let featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.QuintessentialRegular(size: 28)
        button.layer.cornerRadius = 28
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = UIColor(hex: "FFD700")
        
        // Subtle shadow
        button.layer.shadowColor = UIColor(hex: "FFD700").cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 15
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        
        return button
    }()
    
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
    
    private var featuresGradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        setupFeatures()
        setupPlans()
        addAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        featuresGradientLayer?.frame = featuresContainer.bounds
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
        view.addSubview(featuresContainer)
        featuresContainer.addSubview(featuresStackView)
        view.addSubview(weeklyPlanCard)
        view.addSubview(yearlyPlanCard)
        view.addSubview(subscribeButton)
        view.addSubview(restoreButton)
        view.addSubview(termsLabel)
        
        setupFeaturesGradient()
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            crownImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            crownImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: 70),
            crownImageView.heightAnchor.constraint(equalToConstant: 70),
            
            titleLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            featuresContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            featuresContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            featuresContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            featuresStackView.topAnchor.constraint(equalTo: featuresContainer.topAnchor, constant: 20),
            featuresStackView.leadingAnchor.constraint(equalTo: featuresContainer.leadingAnchor, constant: 20),
            featuresStackView.trailingAnchor.constraint(equalTo: featuresContainer.trailingAnchor, constant: -20),
            featuresStackView.bottomAnchor.constraint(equalTo: featuresContainer.bottomAnchor, constant: -20),
            
            weeklyPlanCard.topAnchor.constraint(equalTo: featuresContainer.bottomAnchor, constant: 25),
            weeklyPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weeklyPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weeklyPlanCard.heightAnchor.constraint(equalToConstant: 90),
            
            yearlyPlanCard.topAnchor.constraint(equalTo: weeklyPlanCard.bottomAnchor, constant: 12),
            yearlyPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yearlyPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            yearlyPlanCard.heightAnchor.constraint(equalToConstant: 100),
            
            subscribeButton.topAnchor.constraint(equalTo: yearlyPlanCard.bottomAnchor, constant: 25),
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
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        let weeklyTap = UITapGestureRecognizer(target: self, action: #selector(weeklyPlanTapped))
        weeklyPlanCard.addGestureRecognizer(weeklyTap)
        
        let yearlyTap = UITapGestureRecognizer(target: self, action: #selector(yearlyPlanTapped))
        yearlyPlanCard.addGestureRecognizer(yearlyTap)
        
        let termsTap = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        termsLabel.addGestureRecognizer(termsTap)
    }
    
    private func setupFeaturesGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = featuresContainer.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.3).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.2).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 25
        gradient.zPosition = -1
        featuresContainer.layer.insertSublayer(gradient, at: 0)
        featuresGradientLayer = gradient
        
        // Subtle shadow
        featuresContainer.layer.shadowColor = UIColor.black.cgColor
        featuresContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        featuresContainer.layer.shadowRadius = 12
        featuresContainer.layer.shadowOpacity = 0.3
        featuresContainer.layer.masksToBounds = false
    }
    
    private func setupFeatures() {
        for feature in features {
            let featureView = createFeatureView(text: feature)
            featuresStackView.addArrangedSubview(featureView)
        }
    }
    
    private func createFeatureView(text: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let bullet = UIView()
        bullet.translatesAutoresizingMaskIntoConstraints = false
        bullet.backgroundColor = UIColor(hex: "FFD700")
        bullet.layer.cornerRadius = 3
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(bullet)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            bullet.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            bullet.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            bullet.widthAnchor.constraint(equalToConstant: 6),
            bullet.heightAnchor.constraint(equalToConstant: 6),
            
            label.leadingAnchor.constraint(equalTo: bullet.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func setupPlans() {
        weeklyPlanCard.configure(
            title: "Weekly",
            price: "$4.99",
            period: "per week",
            badge: nil,
            isSelected: selectedPlan == .weekly
        )
        
        yearlyPlanCard.configure(
            title: "Yearly",
            price: "$29.99",
            period: "per year",
            badge: "BEST VALUE - Save 88%",
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
}

// MARK: - PremiumPlan Enum
enum PremiumPlan {
    case weekly
    case yearly
}

// MARK: - PlanCard
class PlanCard: UIView {
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let periodLabel = UILabel()
    private let badgeLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private var gradientLayer: CAGradientLayer?
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
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 22
        clipsToBounds = false
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.5).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.4).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 22
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Title
        titleLabel.font = UIFont.QuintessentialRegular(size: 22)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Price
        priceLabel.font = UIFont.QuintessentialRegular(size: 28)
        priceLabel.textColor = UIColor(hex: "FFD700")
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Period
        periodLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        periodLabel.textColor = .white.withAlphaComponent(0.7)
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Badge
        badgeLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textColor = .black
        badgeLabel.backgroundColor = UIColor(hex: "FFD700")
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.isHidden = true
        
        // Checkmark
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        checkmarkImageView.tintColor = UIColor(hex: "FFD700")
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.alpha = 0
        
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(periodLabel)
        addSubview(badgeLabel)
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            periodLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            periodLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            
            badgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            badgeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            badgeLabel.heightAnchor.constraint(equalToConstant: 22),
            
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
            layer.borderColor = UIColor(hex: "FFD700").cgColor
            layer.borderWidth = 2.5
            checkmarkImageView.alpha = 1
            
            // Subtle golden shadow
            layer.shadowColor = UIColor(hex: "FFD700").cgColor
            layer.shadowOffset = CGSize(width: 0, height: 4)
            layer.shadowRadius = 12
            layer.shadowOpacity = 0.4
            layer.masksToBounds = false
        } else {
            layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            layer.borderWidth = 2
            checkmarkImageView.alpha = 0
            
            layer.shadowOpacity = 0
        }
    }
}
