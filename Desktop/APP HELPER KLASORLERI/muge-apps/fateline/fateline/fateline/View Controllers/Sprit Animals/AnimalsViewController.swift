//
//  AnimalsViewController.swift
//  fateline
//
//  Created by Müge Deniz on 14.10.2025.
//

import UIKit

// MARK: - Models
struct SpiritAnimal {
    let name: String
    let imageName: String
    let traits: [String]
    let description: String
    let element: String
}

struct Question {
    let text: String
    let answers: [Answer]
}

struct Answer {
    let text: String
    let animalScores: [String: Int] // Animal name: score
}

class AnimalsViewController: UIViewController {

    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    private var currentQuestionIndex = 0
    private var animalScores: [String: Int] = [:]
    
    private let questions: [Question] = [
        Question(
            text: "When faced with a challenge, how do you typically respond?",
            answers: [
                Answer(text: "I face it head-on with courage", animalScores: ["Lion": 3, "Tiger": 2, "Bull": 2]),
                Answer(text: "I think strategically before acting", animalScores: ["Eagle": 3, "Snake": 2, "Shark": 2]),
                Answer(text: "I rely on my strength and patience", animalScores: ["Bear": 3, "Elephant": 2, "Gorilla": 2]),
                Answer(text: "I adapt and find creative solutions", animalScores: ["Snake": 3, "Eagle": 2, "Shark": 1])
            ]
        ),
        Question(
            text: "What environment makes you feel most at peace?",
            answers: [
                Answer(text: "Wide open spaces and freedom", animalScores: ["Eagle": 3, "Lion": 2, "Tiger": 1]),
                Answer(text: "Mountains and forests", animalScores: ["Bear": 3, "Gorilla": 2, "Bull": 2]),
                Answer(text: "Deep waters and mystery", animalScores: ["Shark": 3, "Snake": 2, "Eagle": 1]),
                Answer(text: "Quiet, grounded natural spaces", animalScores: ["Elephant": 3, "Bull": 2, "Gorilla": 1])
            ]
        ),
        Question(
            text: "How would your friends describe you?",
            answers: [
                Answer(text: "Strong, protective leader", animalScores: ["Lion": 3, "Bull": 2, "Elephant": 2]),
                Answer(text: "Wise, observant, and strategic", animalScores: ["Eagle": 3, "Snake": 2, "Elephant": 1]),
                Answer(text: "Loyal, steady, and dependable", animalScores: ["Bear": 3, "Elephant": 2, "Bull": 2]),
                Answer(text: "Fierce, focused, and determined", animalScores: ["Tiger": 3, "Shark": 2, "Lion": 1])
            ]
        ),
        Question(
            text: "What drives you most in life?",
            answers: [
                Answer(text: "Achieving greatness and recognition", animalScores: ["Lion": 3, "Eagle": 2, "Tiger": 2]),
                Answer(text: "Protecting those I love", animalScores: ["Bear": 3, "Gorilla": 2, "Elephant": 2]),
                Answer(text: "Personal transformation and growth", animalScores: ["Snake": 3, "Tiger": 2, "Eagle": 1]),
                Answer(text: "Stability and building foundations", animalScores: ["Bull": 3, "Elephant": 2, "Bear": 1])
            ]
        ),
        Question(
            text: "How do you handle conflict?",
            answers: [
                Answer(text: "I confront it directly and powerfully", animalScores: ["Lion": 3, "Bull": 2, "Shark": 2]),
                Answer(text: "I observe and strike when ready", animalScores: ["Tiger": 3, "Snake": 2, "Shark": 2]),
                Answer(text: "I stay calm and seek peaceful resolution", animalScores: ["Elephant": 3, "Bear": 2, "Gorilla": 2]),
                Answer(text: "I rise above and see the bigger picture", animalScores: ["Eagle": 3, "Gorilla": 1, "Snake": 1])
            ]
        ),
        Question(
            text: "What is your greatest strength?",
            answers: [
                Answer(text: "My courage and leadership", animalScores: ["Lion": 3, "Eagle": 2, "Tiger": 1]),
                Answer(text: "My wisdom and insight", animalScores: ["Eagle": 3, "Snake": 2, "Elephant": 2]),
                Answer(text: "My resilience and endurance", animalScores: ["Bear": 3, "Bull": 2, "Elephant": 2]),
                Answer(text: "My focus and determination", animalScores: ["Shark": 3, "Tiger": 2, "Bull": 1])
            ]
        ),
        Question(
            text: "What role do you naturally take in a group?",
            answers: [
                Answer(text: "The confident leader everyone follows", animalScores: ["Lion": 3, "Gorilla": 2, "Bull": 1]),
                Answer(text: "The wise advisor with clear vision", animalScores: ["Eagle": 3, "Elephant": 2, "Snake": 1]),
                Answer(text: "The loyal protector of the team", animalScores: ["Bear": 3, "Bull": 2, "Gorilla": 2]),
                Answer(text: "The focused achiever who gets results", animalScores: ["Tiger": 3, "Shark": 2, "Lion": 1])
            ]
        )
    ]
    
    private let spiritAnimals: [String: SpiritAnimal] = [
        "Lion": SpiritAnimal(
            name: "Lion",
            imageName: "aslan",
            traits: ["Courage", "Leadership", "Confidence"],
            description: "You embody the spirit of the Lion — a natural-born leader with unwavering courage and regal confidence. You face challenges head-on and inspire others with your strength. Your presence commands respect, and you protect those you love fiercely.",
            element: "Fire"
        ),
        "Bear": SpiritAnimal(
            name: "Bear",
            imageName: "ayi",
            traits: ["Strength", "Protection", "Wisdom"],
            description: "Your spirit animal is the Bear — powerful, protective, and deeply connected to nature. You possess great inner strength and resilience. People feel safe around you, and you have a natural ability to heal and nurture those in need.",
            element: "Earth"
        ),
        "Bull": SpiritAnimal(
            name: "Bull",
            imageName: "boga",
            traits: ["Determination", "Stability", "Power"],
            description: "You carry the spirit of the Bull — grounded, determined, and incredibly powerful. Once you set your mind on something, nothing can stop you. You value stability and are a pillar of strength for others. Your patience is matched only by your power.",
            element: "Earth"
        ),
        "Elephant": SpiritAnimal(
            name: "Elephant",
            imageName: "fil",
            traits: ["Wisdom", "Loyalty", "Memory"],
            description: "The Elephant is your spiritual guide — wise, loyal, and deeply intuitive. You carry ancient wisdom and never forget those who matter to you. Your gentle strength and emotional intelligence make you a trusted confidant and powerful ally.",
            element: "Earth"
        ),
        "Gorilla": SpiritAnimal(
            name: "Gorilla",
            imageName: "goril",
            traits: ["Intelligence", "Community", "Strength"],
            description: "Your spirit resonates with the Gorilla — intelligent, social, and protective of your tribe. You balance great physical strength with emotional depth. Family and community are everything to you, and you lead with both power and compassion.",
            element: "Earth"
        ),
        "Tiger": SpiritAnimal(
            name: "Tiger",
            imageName: "kaplan",
            traits: ["Focus", "Passion", "Independence"],
            description: "The Tiger is your spiritual essence — fierce, focused, and unstoppable when pursuing your goals. You move with grace and strike with precision. Your independence is your power, and your passion fuels everything you do.",
            element: "Fire"
        ),
        "Eagle": SpiritAnimal(
            name: "Eagle",
            imageName: "kartal",
            traits: ["Vision", "Freedom", "Perspective"],
            description: "You soar with the spirit of the Eagle — visionary, free, and able to see what others cannot. You rise above challenges and view life from higher perspectives. Your clarity of vision and connection to spirit make you a natural guide for others.",
            element: "Air"
        ),
        "Shark": SpiritAnimal(
            name: "Shark",
            imageName: "kopek baligi",
            traits: ["Focus", "Survival", "Efficiency"],
            description: "The Shark guides your spirit — efficient, focused, and constantly moving forward. You thrive in competitive environments and trust your instincts completely. Your determination and survival instincts make you a powerful force in any situation.",
            element: "Water"
        ),
        "Snake": SpiritAnimal(
            name: "Snake",
            imageName: "yilan",
            traits: ["Transformation", "Healing", "Intuition"],
            description: "Your soul connects with the Snake — transformative, intuitive, and deeply mystical. You continuously shed old versions of yourself and emerge renewed. Your healing abilities and connection to hidden wisdom make you a powerful spiritual guide.",
            element: "Water"
        )
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
        label.text = "Spirit Animal".translate
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
        label.text = "Answer 7 questions to reveal your guide".translate
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
    
    private let progressContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let progressBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "6B3F69")
        view.layer.cornerRadius = 5
        return view
    }()
    
    private var progressBarWidthConstraint: NSLayoutConstraint?
    
    private let questionContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let questionNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.6
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let answersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private let revealButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Discover Your Spirit Animal".translate, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        button.titleLabel?.layer.shadowColor = UIColor.white.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowRadius = 10
        button.titleLabel?.layer.shadowOpacity = 0.8
        button.titleLabel?.layer.masksToBounds = false
        
        return button
    }()
    
    // Result Container
    private let resultContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        view.alpha = 0
        view.isHidden = true  // Başta gizli
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var questionGradientLayer: CAGradientLayer?
    private var buttonGradientLayer: CAGradientLayer?
    private var resultGradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        displayQuestion()
        initializeAnimalScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        questionGradientLayer?.frame = questionContainer.bounds
        buttonGradientLayer?.frame = revealButton.bounds
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
        contentView.addSubview(progressContainer)
        progressContainer.addSubview(progressBar)
        contentView.addSubview(questionContainer)
        questionContainer.addSubview(questionNumberLabel)
        questionContainer.addSubview(questionLabel)
        questionContainer.addSubview(answersStackView)
        contentView.addSubview(revealButton)
        contentView.addSubview(resultContainer)
        
        setupQuestionGradient()
        setupButtonGradient()
        
        progressBarWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressBarWidthConstraint?.isActive = true
        
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
            
            progressContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            progressContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            progressContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            progressContainer.heightAnchor.constraint(equalToConstant: 10),
            
            progressBar.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            
            questionContainer.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 30),
            questionContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            questionContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            questionNumberLabel.topAnchor.constraint(equalTo: questionContainer.topAnchor, constant: 20),
            questionNumberLabel.centerXAnchor.constraint(equalTo: questionContainer.centerXAnchor),
            
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 15),
            questionLabel.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor, constant: 25),
            questionLabel.trailingAnchor.constraint(equalTo: questionContainer.trailingAnchor, constant: -25),
            
            answersStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 25),
            answersStackView.leadingAnchor.constraint(equalTo: questionContainer.leadingAnchor, constant: 20),
            answersStackView.trailingAnchor.constraint(equalTo: questionContainer.trailingAnchor, constant: -20),
            answersStackView.bottomAnchor.constraint(equalTo: questionContainer.bottomAnchor, constant: -25),
            
            revealButton.topAnchor.constraint(equalTo: questionContainer.bottomAnchor, constant: 30),
            revealButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            revealButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            revealButton.heightAnchor.constraint(equalToConstant: 60),
            revealButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -30),
            
            resultContainer.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 30),
            resultContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Initially set contentView bottom to questionContainer (since resultContainer is hidden)
        let questionBottomConstraint = contentView.bottomAnchor.constraint(equalTo: questionContainer.bottomAnchor, constant: 30)
        questionBottomConstraint.priority = .defaultHigh
        questionBottomConstraint.isActive = true
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        revealButton.addTarget(self, action: #selector(revealButtonTapped), for: .touchUpInside)
    }
    
    private func setupQuestionGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = questionContainer.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        gradient.zPosition = -1  // Send to back
        questionContainer.layer.insertSublayer(gradient, at: 0)
        questionGradientLayer = gradient
    }
    
    private func setupButtonGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = revealButton.bounds
        gradient.colors = [
            UIColor(hex: "5D2F77").cgColor,
            UIColor(hex: "6B3F69").cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 25
        revealButton.layer.insertSublayer(gradient, at: 0)
        buttonGradientLayer = gradient
        
        revealButton.layer.shadowColor = UIColor(hex: "6B3F69").cgColor
        revealButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        revealButton.layer.shadowRadius = 20
        revealButton.layer.shadowOpacity = 0.8
    }
    
    private func initializeAnimalScores() {
        spiritAnimals.keys.forEach { animalScores[$0] = 0 }
    }
    
    // MARK: - Question Display
    private func displayQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        
        let question = questions[currentQuestionIndex]
        questionNumberLabel.text = "\("Question".translate) \(currentQuestionIndex + 1) \("of".translate) \(questions.count)"
        questionLabel.text = question.text.translate
        
        // Clear previous answers
        answersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add answer buttons
        for (index, answer) in question.answers.enumerated() {
            let answerButton = createAnswerButton(answer: answer, index: index)
            answersStackView.addArrangedSubview(answerButton)
        }
        
        updateProgressBar()
    }
    
    private func createAnswerButton(answer: Answer, index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(answer.text.translate, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        button.tag = index
        button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func updateProgressBar() {
        let progress = CGFloat(currentQuestionIndex) / CGFloat(questions.count)
        let containerWidth = view.bounds.width - 80
        
        UIView.animate(withDuration: 0.3) {
            self.progressBarWidthConstraint?.constant = progress * containerWidth
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Answer Handling
    @objc private func answerButtonTapped(_ sender: UIButton) {
        guard currentQuestionIndex < questions.count else { return }
        
        let answer = questions[currentQuestionIndex].answers[sender.tag]
        
        // Update scores
        for (animal, score) in answer.animalScores {
            animalScores[animal, default: 0] += score
        }
        
        // Animate selection
        UIView.animate(withDuration: 0.2) {
            sender.backgroundColor = UIColor(hex: "6B3F69").withAlphaComponent(0.5)
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Move to next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.currentQuestionIndex += 1
            
            if self.currentQuestionIndex < self.questions.count {
                self.displayQuestion()
            } else {
                self.showRevealButton()
            }
        }
    }
    
    private func showRevealButton() {
        UIView.animate(withDuration: 0.3) {
            self.questionContainer.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.revealButton.alpha = 1.0
            }
        }
        
        updateProgressBar()
    }
    
    // MARK: - Result Display
    @objc private func revealButtonTapped() {
        // Check if user is premium
        if !GlobalHelper.isPremiumActive() {
            // Show premium screen
            let premiumVC = PremiumViewController()
            premiumVC.modalPresentationStyle = .fullScreen
            present(premiumVC, animated: true)
            return
        }
        
        guard let topAnimal = animalScores.max(by: { $0.value < $1.value })?.key,
              let animal = spiritAnimals[topAnimal] else { return }
        
        displayResult(animal: animal)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    private func displayResult(animal: SpiritAnimal) {
        // Setup result container as black
        resultContainer.backgroundColor = .black
        
        resultContainer.layer.shadowColor = UIColor.white.cgColor
        resultContainer.layer.shadowOffset = CGSize(width: 0, height: 8)
        resultContainer.layer.shadowRadius = 25
        resultContainer.layer.shadowOpacity = 0.5
        resultContainer.layer.masksToBounds = false
        
        // Create content
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Your Spirit Animal".translate
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .white.withAlphaComponent(0.7)
        titleLabel.textAlignment = .center
        
        // Animal Image
        let animalImageView = UIImageView()
        animalImageView.image = UIImage(named: animal.imageName)
        animalImageView.contentMode = .scaleAspectFit
        animalImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Animal Name
        let nameLabel = UILabel()
        nameLabel.text = animal.name.translate
        nameLabel.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        nameLabel.layer.shadowColor = UIColor.white.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowRadius = 20
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.masksToBounds = false
        
        // Element
        let elementLabel = UILabel()
        elementLabel.text = "✦ \(animal.element.translate) \("Element".translate) ✦"
        elementLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        elementLabel.textColor = UIColor(hex: "d4a5ff")
        elementLabel.textAlignment = .center
        
        // Traits
        let traitsLabel = UILabel()
        traitsLabel.text = animal.traits.map { $0.translate }.joined(separator: " • ")
        traitsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        traitsLabel.textColor = UIColor(hex: "d4a5ff")
        traitsLabel.textAlignment = .center
        traitsLabel.numberOfLines = 0
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = .white.withAlphaComponent(0.3)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = animal.description.translate
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .white.withAlphaComponent(0.95)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        // Add to stack
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(animalImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(elementLabel)
        stackView.addArrangedSubview(traitsLabel)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(descriptionLabel)
        
        resultContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            animalImageView.widthAnchor.constraint(equalToConstant: 200),
            animalImageView.heightAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: resultContainer.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: resultContainer.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: resultContainer.trailingAnchor, constant: -25),
            stackView.bottomAnchor.constraint(equalTo: resultContainer.bottomAnchor, constant: -30)
        ])
        
        // Hide button and show result
        UIView.animate(withDuration: 0.3) {
            self.revealButton.alpha = 0
        } completion: { _ in
            self.resultContainer.isHidden = false  // Unhide
            self.resultContainer.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
                self.resultContainer.alpha = 1.0
            }
            
            // Scroll to show result
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scrollView.scrollRectToVisible(self.resultContainer.frame, animated: true)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
