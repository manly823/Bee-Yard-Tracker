import SwiftUI

enum HiveType: String, Codable, CaseIterable, Identifiable {
    case langstroth = "Langstroth"
    case topBar = "Top Bar"
    case warre = "Warre"
    case flow = "Flow Hive"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .langstroth: return "square.stack.3d.up.fill"
        case .topBar: return "rectangle.split.3x1.fill"
        case .warre: return "square.stack.fill"
        case .flow: return "arrow.down.to.line.compact"
        }
    }
}

enum QueenStatus: String, Codable, CaseIterable, Identifiable {
    case present = "Present"
    case absent = "Absent"
    case virgin = "Virgin"
    case laying = "Laying"
    case supersedure = "Supersedure"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .present: return "crown.fill"
        case .absent: return "questionmark.circle"
        case .virgin: return "sparkle"
        case .laying: return "crown.fill"
        case .supersedure: return "arrow.triangle.2.circlepath"
        }
    }
    var color: Color {
        switch self {
        case .present, .laying: return Color(red: 0.3, green: 0.7, blue: 0.3)
        case .virgin: return Color(red: 0.85, green: 0.65, blue: 0.1)
        case .absent: return Color(red: 0.85, green: 0.25, blue: 0.2)
        case .supersedure: return .orange
        }
    }
}

enum QueenMarkerColor: String, Codable, CaseIterable, Identifiable {
    case white = "White (1,6)"
    case yellow = "Yellow (2,7)"
    case red = "Red (3,8)"
    case green = "Green (4,9)"
    case blue = "Blue (5,0)"
    case unmarked = "Unmarked"
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .white: return .white
        case .yellow: return .yellow
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .unmarked: return .gray
        }
    }
}

enum BroodPattern: String, Codable, CaseIterable, Identifiable {
    case excellent = "Excellent"
    case good = "Good"
    case spotty = "Spotty"
    case droneLaying = "Drone Laying"
    case empty = "Empty"
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return Color(red: 0.2, green: 0.6, blue: 0.8)
        case .spotty: return .orange
        case .droneLaying: return Color(red: 0.85, green: 0.5, blue: 0.1)
        case .empty: return .red
        }
    }
    var icon: String {
        switch self {
        case .excellent: return "star.fill"
        case .good: return "hand.thumbsup.fill"
        case .spotty: return "circle.dotted"
        case .droneLaying: return "exclamationmark.triangle.fill"
        case .empty: return "xmark.circle.fill"
        }
    }
}

enum BeeMood: String, Codable, CaseIterable, Identifiable {
    case calm = "Calm"
    case nervous = "Nervous"
    case defensive = "Defensive"
    case aggressive = "Aggressive"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .calm: return "face.smiling"
        case .nervous: return "face.dashed"
        case .defensive: return "exclamationmark.shield.fill"
        case .aggressive: return "bolt.shield.fill"
        }
    }
    var color: Color {
        switch self {
        case .calm: return .green
        case .nervous: return .yellow
        case .defensive: return .orange
        case .aggressive: return .red
        }
    }
}

enum HiveHealth: String, Codable, CaseIterable, Identifiable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case critical = "Critical"
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return Color(red: 0.2, green: 0.6, blue: 0.8)
        case .fair: return .orange
        case .poor: return Color(red: 0.85, green: 0.4, blue: 0.1)
        case .critical: return .red
        }
    }
}

enum HoneyType: String, Codable, CaseIterable, Identifiable {
    case wildflower = "Wildflower"
    case clover = "Clover"
    case acacia = "Acacia"
    case linden = "Linden"
    case buckwheat = "Buckwheat"
    case manuka = "Manuka"
    case mixed = "Mixed"
    var id: String { rawValue }
    var color: Color {
        switch self {
        case .wildflower: return Color(red: 0.85, green: 0.6, blue: 0.1)
        case .clover: return Color(red: 0.95, green: 0.85, blue: 0.5)
        case .acacia: return Color(red: 0.95, green: 0.9, blue: 0.6)
        case .linden: return Color(red: 0.9, green: 0.75, blue: 0.3)
        case .buckwheat: return Color(red: 0.5, green: 0.3, blue: 0.1)
        case .manuka: return Color(red: 0.7, green: 0.5, blue: 0.2)
        case .mixed: return Color(red: 0.8, green: 0.6, blue: 0.2)
        }
    }
}

enum SeasonType: String, Codable, CaseIterable, Identifiable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .fall: return "wind"
        case .winter: return "snowflake"
        }
    }
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .fall: return .orange
        case .winter: return .blue
        }
    }
}

enum FeedType: String, Codable, CaseIterable, Identifiable {
    case lightSyrup = "1:1 Light Syrup"
    case heavySyrup = "2:1 Heavy Syrup"
    case fondant = "Fondant"
    case pollenPatty = "Pollen Patty"
    var id: String { rawValue }
    var ratio: String {
        switch self {
        case .lightSyrup: return "1 kg sugar : 1 L water"
        case .heavySyrup: return "2 kg sugar : 1 L water"
        case .fondant: return "Solid sugar block"
        case .pollenPatty: return "Pollen substitute + sugar"
        }
    }
    var season: String {
        switch self {
        case .lightSyrup: return "Spring stimulation"
        case .heavySyrup: return "Fall winter prep"
        case .fondant: return "Emergency winter feed"
        case .pollenPatty: return "Early spring protein"
        }
    }
}

struct Hive: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String = ""
    var type: HiveType = .langstroth
    var location: String = ""
    var queenStatus: QueenStatus = .present
    var queenMarkerColor: QueenMarkerColor = .unmarked
    var queenInstalledDate: Date = Date()
    var dateCreated: Date = Date()
    var notes: String = ""
    var queenAgeDays: Int {
        Calendar.current.dateComponents([.day], from: queenInstalledDate, to: Date()).day ?? 0
    }
}

struct InspectionEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var hiveId: UUID
    var date: Date = Date()
    var queenSeen: Bool = false
    var eggsPresent: Bool = false
    var larvaePresent: Bool = false
    var queenCellsSeen: Bool = false
    var broodPattern: BroodPattern = .good
    var honeyStores: Int = 3
    var pollenStores: Int = 3
    var mood: BeeMood = .calm
    var miteCount: Int = 0
    var health: HiveHealth = .good
    var notes: String = ""
}

struct HarvestEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var hiveId: UUID
    var date: Date = Date()
    var weightKg: Double = 0
    var honeyType: HoneyType = .wildflower
    var tasteRating: Int = 3
    var clarityRating: Int = 3
    var aromaRating: Int = 3
    var notes: String = ""
    var overallRating: Double {
        Double(tasteRating + clarityRating + aromaRating) / 3.0
    }
}

struct BeeSettings: Codable {
    var hasCompletedOnboarding: Bool = false
    var defaultHiveType: HiveType = .langstroth
    var weightUnit: WeightUnit = .kg
}

enum WeightUnit: String, Codable, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}
