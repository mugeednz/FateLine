//
//  ZodiacPickerViewController.swift
//  fateline
//
//  Created by Müge Deniz on 16.10.2025.
//

import UIKit

protocol ZodiacPickerDelegate: AnyObject {
    func didSelectZodiacSign(_ sign: String)
}

class ZodiacPickerViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ZodiacPickerDelegate?
    private var gradientLayer: CAGradientLayer?
    
    private let zodiacSigns: [(name: String, emoji: String)] = [
        ("Aries", "♈️"),
        ("Taurus", "♉️"),
        ("Gemini", "♊️"),
        ("Cancer", "♋️"),
        ("Leo", "♌️"),
        ("Virgo", "♍️"),
        ("Libra", "♎️"),
        ("Scorpio", "♏️"),
        ("Sagittarius", "♐️"),
        ("Capricorn", "♑️"),
        ("Aquarius", "♒️"),
        ("Pisces", "♓️")
    ]
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Zodiac Sign"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 15
        
        // Add glow
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        
        return button
    }()
    
    private var containerGradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundGradient()
        setupUI()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
        containerGradientLayer?.frame = containerView.bounds
    }
    
    // MARK: - Setup
    private func setupBackgroundGradient() {
        // Semi-transparent dark background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(tableView)
        containerView.addSubview(cancelButton)
        
        // Setup container gradient
        let gradient = CAGradientLayer()
        gradient.frame = containerView.bounds
        gradient.colors = [
            UIColor(hex: "2d1b3d").cgColor,
            UIColor(hex: "4a1e4f").cgColor,
            UIColor(hex: "1a0a2e").cgColor
        ]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.cornerRadius = 30
        containerView.layer.insertSublayer(gradient, at: 0)
        containerGradientLayer = gradient
        
        // Add border
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        // Add shadow
        containerView.layer.shadowColor = UIColor(hex: "5d2f77").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView.layer.shadowRadius = 30
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.masksToBounds = false
        containerView.clipsToBounds = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -15),
            
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZodiacSignCell.self, forCellReuseIdentifier: "ZodiacSignCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ZodiacPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zodiacSigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZodiacSignCell", for: indexPath) as! ZodiacSignCell
        let zodiac = zodiacSigns[indexPath.row]
        cell.configure(name: zodiac.name, emoji: zodiac.emoji)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ZodiacPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSign = zodiacSigns[indexPath.row].name
        delegate?.didSelectZodiacSign(selectedSign)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss(animated: true)
    }
}

// MARK: - ZodiacSignCell
class ZodiacSignCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.4
        label.layer.masksToBounds = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(name: String, emoji: String) {
        nameLabel.text = name
        emojiLabel.text = emoji
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = highlighted ?
                UIColor.white.withAlphaComponent(0.15) :
                UIColor.white.withAlphaComponent(0.05)
            self.containerView.transform = highlighted ?
                CGAffineTransform(scaleX: 0.98, y: 0.98) :
                CGAffineTransform.identity
        }
    }
}

