//
//  PremiumViewController.swift
//  fateline
//
//  Created by Müge Deniz on 13.10.2025.
//

import UIKit
import StoreKit

class PremiumViewController: UIViewController {

    // MARK: - Subscription Properties
    private let subscription = Subscription.instance
    
    enum ChoosenPremium: String {
        case weekly = "fatelineweekly"
        case yearly = "fatelineyearly"
    }
    
    var selectedProduct = ChoosenPremium.yearly
    var purchasingProducts: [PurchasingProduct] = []
    private var yearlyPrice = ""
    private var weeklyPrice = ""
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var selectedPlan: PremiumPlan = .yearly
    
    // Check if device is iPhone SE or similar small screen
    private var isSmallScreen: Bool {
        return UIScreen.main.bounds.height <= 667
    }
    
    private let features = [
        "Unlimited Tarot Readings".translate,
        "Advanced Zodiac Compatibility".translate,
        "Life & Soul Card Insights".translate,
        "Spirit Animal Discovery".translate,
        "Deep Numerology Analysis".translate,
        "Exclusive Premium Content".translate
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
    
    private lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "premium_crown")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtle glow
        imageView.layer.shadowColor = UIColor(hex: "FFD700").cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowRadius = isSmallScreen ? 10 : 15
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.masksToBounds = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium".translate
        label.font = UIFont.systemFont(ofSize: isSmallScreen ? 30 : 38, weight: .bold)
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
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Experience the full mystical journey".translate
        label.font = UIFont.systemFont(ofSize: isSmallScreen ? 14 : 17, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Animated Feature Label
    private lazy var animatedFeatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: isSmallScreen ? 20 : 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow effect
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = isSmallScreen ? 15 : 20
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
    
    private lazy var subscribeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Continue".translate, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isSmallScreen ? 20 : 24, weight: .bold)
        let cornerRadius: CGFloat = isSmallScreen ? 24 : 28
        button.layer.cornerRadius = cornerRadius
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
        gradient.cornerRadius = cornerRadius
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
        shineLayer.cornerRadius = cornerRadius
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
    
    private let termsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Terms".translate, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Privacy".translate, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restore Purchases".translate, for: .normal)
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
        
        // Setup subscription and fetch products
        subscription.setOperator(self)
        subscription.fetchAvailableProducts()
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
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        
        // Small screen adjustments
        let crownTop: CGFloat = isSmallScreen ? 20 : 50
        let crownSize: CGFloat = isSmallScreen ? 80 : 110
        let titleTop: CGFloat = isSmallScreen ? 12 : 20
        let subtitleTop: CGFloat = isSmallScreen ? 5 : 8
        let featureTop: CGFloat = isSmallScreen ? 20 : 40
        let featureHeight: CGFloat = isSmallScreen ? 70 : 100
        let yearlyTop: CGFloat = isSmallScreen ? 20 : 40
        let yearlyHeight: CGFloat = isSmallScreen ? 90 : 110
        let weeklyHeight: CGFloat = isSmallScreen ? 85 : 100
        let buttonTop: CGFloat = isSmallScreen ? 15 : 25
        let buttonHeight: CGFloat = isSmallScreen ? 50 : 60
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            
            crownImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: crownTop),
            crownImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crownImageView.widthAnchor.constraint(equalToConstant: crownSize),
            crownImageView.heightAnchor.constraint(equalToConstant: crownSize),
            
            titleLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: titleTop),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: subtitleTop),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            animatedFeatureLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: featureTop),
            animatedFeatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            animatedFeatureLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            animatedFeatureLabel.heightAnchor.constraint(equalToConstant: featureHeight),
            
            yearlyPlanCard.topAnchor.constraint(equalTo: animatedFeatureLabel.bottomAnchor, constant: yearlyTop),
            yearlyPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yearlyPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            yearlyPlanCard.heightAnchor.constraint(equalToConstant: yearlyHeight),
            
            weeklyPlanCard.topAnchor.constraint(equalTo: yearlyPlanCard.bottomAnchor, constant: 12),
            weeklyPlanCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weeklyPlanCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weeklyPlanCard.heightAnchor.constraint(equalToConstant: weeklyHeight),
            
            subscribeButton.topAnchor.constraint(equalTo: weeklyPlanCard.bottomAnchor, constant: buttonTop),
            subscribeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subscribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            subscribeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            restoreButton.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 12),
            restoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            termsButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 10),
            termsButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            termsButton.heightAnchor.constraint(equalToConstant: 30),
            
            privacyButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 10),
            privacyButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            privacyButton.heightAnchor.constraint(equalToConstant: 30)
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
        
        termsButton.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
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
            title: "Weekly".translate,
            price: "",
            period: "per week".translate,
            badge: nil,
            isSelected: selectedPlan == .weekly
        )
        
        // Yıllık plan için x2 hesaplama
        let yearlyPrice = ""
        let doublePrice = calculateDoublePrice(from: yearlyPrice)
        
        yearlyPlanCard.configure(
            title: "Yearly".translate,
            price: yearlyPrice,
            period: "per year".translate,
            badge: "BEST VALUE - Save 50%".translate + " - \(doublePrice)",
            isSelected: selectedPlan == .yearly,
            originalPrice: doublePrice  // Üstü çizili orijinal fiyat
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
        selectedProduct = .weekly
        updatePlanSelection()
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    @objc private func yearlyPlanTapped() {
        selectedPlan = .yearly
        selectedProduct = .yearly
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
        guard let product = getProduct() else {
            showAlert(title: "Error".translate, message: "Product not available".translate)
            return
        }
        GlobalHelper.hudShow(self)
        subscription.purchaseProduct(product)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    @objc private func restoreButtonTapped() {
        GlobalHelper.hudShow(self)
        subscription.restore()
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func getProduct() -> PurchasingProduct? {
        return purchasingProducts.first { $0.productIdentifier == selectedProduct.rawValue }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".translate, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func termsButtonTapped() {
        GlobalHelper.openTerms(self)
    }
    
    @objc private func privacyButtonTapped() {
        GlobalHelper.openPrivacy(self)
    }
    
    deinit {
        featureTimer?.invalidate()
    }
}

// MARK: - SubscriptionOperator Conformance
extension PremiumViewController: SubscriptionOperator {
    func premiumVersionRestored() {
        GlobalHelper.hudDismiss()
        showAlert(title: "Success".translate, message: "Your purchases have been restored".translate)
        dismiss(animated: true)
    }
    
    func purchasesDisabledOnDevice() {
        GlobalHelper.hudDismiss()
        showAlert(title: "Error".translate, message: "Purchases are disabled on this device.".translate)
    }
    
    func setPurchasingProducts(_ purchasingProducts: [PurchasingProduct]) {
        print("🔵 setPurchasingProducts called with \(purchasingProducts.count) products")
        self.purchasingProducts = purchasingProducts
        setPrice()
    }
    
    func premiumProductPurchased() {
        GlobalHelper.hudDismiss()
        showAlert(title: "Success".translate, message: "Welcome to Premium!".translate)
        dismiss(animated: true)
    }
    
    func purchaseStarted() {
        // HUD already shown
    }
    
    func purchaseFinished() {
        GlobalHelper.hudDismiss()
    }
    
    func fetchingProductFailure() {
        GlobalHelper.hudDismiss()
        showAlert(title: "Error".translate, message: "Failed to fetch products.".translate)
    }
    
    func setPrice() {
        print("🔵 setPrice called with \(purchasingProducts.count) products")
        for product in purchasingProducts {
            print("🔵 Product ID: \(product.productIdentifier), Price: \(product.productPrice)")
            if product.productIdentifier == ChoosenPremium.yearly.rawValue {
                yearlyPrice = product.productPrice
                
                // Calculate double price (x2)
                let doublePrice = calculateDoublePrice(from: yearlyPrice)
                
                yearlyPlanCard.configure(
                    title: "Yearly".translate,
                    price: yearlyPrice.isEmpty ? "" : yearlyPrice,
                    period: "per year".translate,
                    badge: "BEST VALUE - Save 50%".translate + " - \(doublePrice)",
                    isSelected: selectedPlan == .yearly,
                    originalPrice: doublePrice  // Üstü çizili orijinal fiyat
                )
                print("🔵 Yearly price set: \(yearlyPrice), Double: \(doublePrice)")
            } else if product.productIdentifier == ChoosenPremium.weekly.rawValue {
                weeklyPrice = product.productPrice
                weeklyPlanCard.configure(
                    title: "Weekly".translate,
                    price: weeklyPrice.isEmpty ? "" : weeklyPrice,
                    period: "per week".translate,
                    badge: nil,
                    isSelected: selectedPlan == .weekly
                )
                print("🔵 Weekly price set: \(weeklyPrice)")
            }
        }
    }
    
    // Calculate double price for yearly plan
    private func calculateDoublePrice(from priceString: String) -> String {
        // Extract numbers from price string
        let numbers = priceString.filter { "0123456789.,".contains($0) }
        
        // Handle comma vs dot decimal separator
        let normalizedNumbers = numbers.replacingOccurrences(of: ",", with: ".")
        
        if let priceValue = Double(normalizedNumbers), priceValue > 0 {
            let doubleValue = (priceValue * 2.0).rounded(to: 2)
            
            // Preserve original format (comma or dot)
            if numbers.contains(",") {
                let doubleString = String(doubleValue).replacingOccurrences(of: ".", with: ",")
                return priceString.replacingOccurrences(of: numbers, with: doubleString)
            } else {
                return priceString.replacingOccurrences(of: numbers, with: String(doubleValue))
            }
        }
        
        return priceString // Return original if calculation fails
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
    private let originalPriceLabel = UILabel()  // Üstü çizili orijinal fiyat
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
        
        // Original Price (üstü çizili)
        originalPriceLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        originalPriceLabel.textColor = .white.withAlphaComponent(0.6)
        originalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        originalPriceLabel.isHidden = true
        
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
        addSubview(originalPriceLabel)
        addSubview(periodLabel)
        addSubview(checkmarkImageView)
        addSubview(badgeLabel)  // Badge must be added LAST to be on top
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            // Checkmark üstte
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            checkmarkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 28),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 28),
            
            // Fiyatlar checkmark'ın altında, yan yana
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            priceLabel.topAnchor.constraint(equalTo: checkmarkImageView.bottomAnchor, constant: 8),
            
            originalPriceLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            originalPriceLabel.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            
            periodLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            periodLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            
            badgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -15)
        ])
    }
    
    func configure(title: String, price: String, period: String, badge: String?, isSelected: Bool, originalPrice: String? = nil) {
        titleLabel.text = title
        priceLabel.text = price
        periodLabel.text = period
        
        // Üstü çizili orijinal fiyat (sadece yıllık plan için)
        if let originalPrice = originalPrice {
            originalPriceLabel.text = originalPrice
            originalPriceLabel.isHidden = false
            
            // Üstü çizili stil
            let attributedString = NSAttributedString(
                string: originalPrice,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: UIColor.white.withAlphaComponent(0.6)
                ]
            )
            originalPriceLabel.attributedText = attributedString
        } else {
            originalPriceLabel.isHidden = true
        }
        
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

// MARK: - Double Extension
extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
