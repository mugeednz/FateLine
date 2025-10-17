//
//  TarotReading.swift
//  fateline
//
//  Created by Müge Deniz on 16.10.2025.
//

import Foundation

struct TarotReading: Codable {
    let id: String
    let date: Date
    let question: String
    let cardIds: [Int]
    let cardNames: [String]
    let cardMeanings: [String]
    
    init(question: String, cards: [TarotCard]) {
        self.id = UUID().uuidString
        self.date = Date()
        self.question = question.isEmpty ? "General Reading".translate : question
        self.cardIds = cards.map { $0.id }
        self.cardNames = cards.map { $0.name }
        self.cardMeanings = cards.map { $0.upright }
    }
}

class TarotReadingManager {
    static let shared = TarotReadingManager()
    private let userDefaults = UserDefaults.standard
    private let readingsKey = "SavedTarotReadings"
    
    private init() {}
    
    func saveReading(_ reading: TarotReading) {
        var readings = getReadings()
        readings.insert(reading, at: 0) // Most recent first
        
        // Keep only last 50 readings
        if readings.count > 50 {
            readings = Array(readings.prefix(50))
        }
        
        if let encoded = try? JSONEncoder().encode(readings) {
            userDefaults.set(encoded, forKey: readingsKey)
        }
    }
    
    func getReadings() -> [TarotReading] {
        guard let data = userDefaults.data(forKey: readingsKey),
              let readings = try? JSONDecoder().decode([TarotReading].self, from: data) else {
            return []
        }
        return readings
    }
    
    func deleteReading(id: String) {
        var readings = getReadings()
        readings.removeAll { $0.id == id }
        
        if let encoded = try? JSONEncoder().encode(readings) {
            userDefaults.set(encoded, forKey: readingsKey)
        }
    }
}

