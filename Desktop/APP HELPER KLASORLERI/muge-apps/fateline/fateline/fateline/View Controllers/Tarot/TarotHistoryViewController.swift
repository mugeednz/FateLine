//
//  TarotHistoryViewController.swift
//  fateline
//
//  Created by Müge Deniz on 16.10.2025.
//

import UIKit

class TarotHistoryViewController: UIViewController {
    
    // MARK: - Properties
    private var readings: [TarotReading] = []
    private var gradientLayer: CAGradientLayer?
    private var tableView: UITableView!
    
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
        label.text = "Reading History"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
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
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No readings yet\n✨ Start your first reading ✨"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        
        // Add glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.5
        label.layer.masksToBounds = false
        
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupUI()
        loadReadings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadReadings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
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
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(emptyStateLabel)
        
        // Setup table view
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TarotHistoryCell.self, forCellReuseIdentifier: "TarotHistoryCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func loadReadings() {
        readings = TarotReadingManager.shared.getReadings()
        emptyStateLabel.isHidden = !readings.isEmpty
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TarotHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TarotHistoryCell", for: indexPath) as! TarotHistoryCell
        let reading = readings[indexPath.row]
        cell.configure(with: reading)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TarotHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reading = readings[indexPath.row]
        
        // Load full tarot cards from JSON
        guard let url = Bundle.main.url(forResource: "tarot_meanings", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let allCards = try? JSONDecoder().decode([TarotCard].self, from: data) else {
            return
        }
        
        // Get the actual cards
        let cards = reading.cardIds.compactMap { id in
            allCards.first { $0.id == id }
        }
        
        // Navigate to results
        let resultsVC = TarotResultsViewController(cards: cards, question: reading.question)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let reading = self.readings[indexPath.row]
            TarotReadingManager.shared.deleteReading(id: reading.id)
            self.loadReadings()
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(hex: "5D2F77")
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - TarotHistoryCell
class TarotHistoryCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add glow
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.5
        label.layer.masksToBounds = false
        
        return label
    }()
    
    private let cardsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?
    
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
        containerView.addSubview(dateLabel)
        containerView.addSubview(questionLabel)
        containerView.addSubview(cardsLabel)
        
        // Setup gradient
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(hex: "2d1b3d").withAlphaComponent(0.4).cgColor,
            UIColor(hex: "4a1e4f").withAlphaComponent(0.3).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.cornerRadius = 20
        containerView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Add shadow
        containerView.layer.shadowColor = UIColor(hex: "5d2f77").cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.masksToBounds = false
        containerView.clipsToBounds = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            questionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cardsLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            cardsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cardsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cardsLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -15)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = containerView.bounds
    }
    
    func configure(with reading: TarotReading) {
        // Format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: reading.date)
        
        // Set question
        questionLabel.text = reading.question.isEmpty ? "General Reading" : reading.question
        
        // Set cards (first 3)
        let cardText = reading.cardNames.prefix(3).joined(separator: " • ")
        cardsLabel.text = "🔮 " + cardText + (reading.cardNames.count > 3 ? "..." : "")
    }
}
