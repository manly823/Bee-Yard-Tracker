import SwiftUI

@MainActor
final class BeeManager: ObservableObject {
    @Published var hives: [Hive] { didSet { Storage.shared.save(hives, forKey: "hives") } }
    @Published var inspections: [InspectionEntry] { didSet { Storage.shared.save(inspections, forKey: "inspections") } }
    @Published var harvests: [HarvestEntry] { didSet { Storage.shared.save(harvests, forKey: "harvests") } }
    @Published var settings: BeeSettings { didSet { Storage.shared.save(settings, forKey: "settings") } }
    
    init() {
        self.hives = Storage.shared.load(forKey: "hives", default: [])
        self.inspections = Storage.shared.load(forKey: "inspections", default: [])
        self.harvests = Storage.shared.load(forKey: "harvests", default: [])
        self.settings = Storage.shared.load(forKey: "settings", default: BeeSettings())
        if hives.isEmpty { hives = BeeManager.sampleHives() }
        if inspections.isEmpty { inspections = BeeManager.sampleInspections(hiveId: hives.first?.id ?? UUID()) }
        if harvests.isEmpty { harvests = BeeManager.sampleHarvests(hiveId: hives.first?.id ?? UUID()) }
    }
    
    // MARK: - Hive CRUD
    func addHive(_ hive: Hive) { hives.insert(hive, at: 0) }
    func deleteHive(_ hive: Hive) {
        hives.removeAll { $0.id == hive.id }
        inspections.removeAll { $0.hiveId == hive.id }
        harvests.removeAll { $0.hiveId == hive.id }
    }
    
    // MARK: - Inspection CRUD
    func addInspection(_ entry: InspectionEntry) { inspections.insert(entry, at: 0) }
    func deleteInspection(_ entry: InspectionEntry) { inspections.removeAll { $0.id == entry.id } }
    func inspections(for hive: Hive) -> [InspectionEntry] { inspections.filter { $0.hiveId == hive.id } }
    func lastInspection(for hive: Hive) -> InspectionEntry? { inspections(for: hive).first }
    
    // MARK: - Harvest CRUD
    func addHarvest(_ entry: HarvestEntry) { harvests.insert(entry, at: 0) }
    func deleteHarvest(_ entry: HarvestEntry) { harvests.removeAll { $0.id == entry.id } }
    func harvests(for hive: Hive) -> [HarvestEntry] { harvests.filter { $0.hiveId == hive.id } }
    
    // MARK: - Feeding Calculator
    func syrupAmount(sugarKg: Double, feedType: FeedType) -> (waterL: Double, totalKg: Double) {
        switch feedType {
        case .lightSyrup: return (sugarKg, sugarKg * 2)
        case .heavySyrup: return (sugarKg / 2, sugarKg * 1.5)
        case .fondant: return (0, sugarKg)
        case .pollenPatty: return (0, sugarKg)
        }
    }
    
    // MARK: - Statistics
    var totalHives: Int { hives.count }
    var totalInspections: Int { inspections.count }
    var totalHarvestKg: Double { harvests.reduce(0) { $0 + $1.weightKg } }
    var averageHarvestRating: Double {
        guard !harvests.isEmpty else { return 0 }
        return harvests.reduce(0) { $0 + $1.overallRating } / Double(harvests.count)
    }
    var healthyHivePercent: Double {
        guard !hives.isEmpty else { return 0 }
        let healthy = hives.filter { h in
            let last = lastInspection(for: h)
            return last?.health == .excellent || last?.health == .good
        }.count
        return Double(healthy) / Double(hives.count) * 100
    }
    
    func hiveName(for id: UUID) -> String {
        hives.first { $0.id == id }?.name ?? "Unknown"
    }
    
    // MARK: - Seasonal Calendar
    static let seasonalTasks: [(season: SeasonType, tasks: [String])] = [
        (.spring, [
            "First inspection when temps reach 15°C / 60°F",
            "Check queen presence and brood pattern",
            "Reverse brood boxes if needed",
            "Feed 1:1 syrup to stimulate buildup",
            "Add pollen patties if natural pollen scarce",
            "Monitor for swarm signs (queen cells)",
            "Split strong colonies to prevent swarming",
            "Clean bottom boards and replace old comb"
        ]),
        (.summer, [
            "Add honey supers before nectar flow",
            "Monitor queen excluder placement",
            "Check for adequate ventilation",
            "Harvest honey when frames 80%+ capped",
            "Watch for signs of robbing behavior",
            "Conduct varroa mite sugar roll test",
            "Ensure adequate water source nearby",
            "Inspect every 7-10 days during peak"
        ]),
        (.fall, [
            "Remove honey supers after last harvest",
            "Treat for varroa mites (critical timing)",
            "Feed 2:1 heavy syrup for winter stores",
            "Verify minimum 18-27 kg winter stores",
            "Reduce entrance to prevent robbing",
            "Combine weak colonies with strong ones",
            "Install mouse guards before cold weather",
            "Final inspection: queen present, good brood"
        ]),
        (.winter, [
            "Minimize hive disturbance",
            "Heft hive to check weight (stores)",
            "Add fondant if stores running low",
            "Ensure upper entrance for ventilation",
            "Check for ice blocking entrances",
            "Wrap hives in cold climates if needed",
            "Order equipment for next season",
            "Plan spring management strategy"
        ])
    ]
    
    // MARK: - Sample Data
    private static func sampleHives() -> [Hive] {
        [
            Hive(name: "Sunflower", type: .langstroth, location: "South Garden",
                 queenStatus: .laying, queenMarkerColor: .blue,
                 queenInstalledDate: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date(),
                 notes: "Strong colony, good honey producer"),
            Hive(name: "Meadow", type: .flow, location: "East Field",
                 queenStatus: .present, queenMarkerColor: .yellow,
                 queenInstalledDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
                 notes: "New queen installed in fall, building up well")
        ]
    }
    
    private static func sampleInspections(hiveId: UUID) -> [InspectionEntry] {
        [InspectionEntry(hiveId: hiveId, queenSeen: true, eggsPresent: true, larvaePresent: true,
                         broodPattern: .excellent, honeyStores: 4, pollenStores: 3, mood: .calm,
                         miteCount: 2, health: .excellent, notes: "Very strong colony, 8 frames of brood")]
    }
    
    private static func sampleHarvests(hiveId: UUID) -> [HarvestEntry] {
        [HarvestEntry(hiveId: hiveId, weightKg: 12.5, honeyType: .wildflower,
                      tasteRating: 5, clarityRating: 4, aromaRating: 5, notes: "Beautiful golden honey, floral aroma")]
    }
}
