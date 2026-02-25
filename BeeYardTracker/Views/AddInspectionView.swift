import SwiftUI

struct AddInspectionView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedHive: UUID?
    @State private var queenSeen = false
    @State private var eggsPresent = false
    @State private var larvaePresent = false
    @State private var queenCells = false
    @State private var brood: BroodPattern = .good
    @State private var honeyStores = 3
    @State private var pollenStores = 3
    @State private var mood: BeeMood = .calm
    @State private var miteCount = 0
    @State private var health: HiveHealth = .good
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        hivePickerSection
                        checklistSection
                        broodSection
                        storesSection
                        healthSection
                        notesSection
                    }.padding()
                }
            }
            .navigationTitle("New Inspection").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }.font(.headline).foregroundColor(Theme.primary).disabled(selectedHive == nil)
                }
            }
            .onAppear { selectedHive = manager.hives.first?.id }
        }
    }
    
    private var hivePickerSection: some View {
        VStack(spacing: 10) {
            header(icon: "square.stack.3d.up.fill", title: "Select Hive")
            Picker("Hive", selection: $selectedHive) {
                ForEach(manager.hives) { h in Text(h.name).tag(Optional(h.id)) }
            }.pickerStyle(.segmented)
        }.cardStyle()
    }
    
    private var checklistSection: some View {
        VStack(spacing: 12) {
            header(icon: "checklist", title: "Quick Check")
            toggleRow(label: "Queen Seen", icon: "crown.fill", value: $queenSeen)
            toggleRow(label: "Eggs Present", icon: "circle.grid.2x2.fill", value: $eggsPresent)
            toggleRow(label: "Larvae Present", icon: "oval.fill", value: $larvaePresent)
            toggleRow(label: "Queen Cells", icon: "exclamationmark.triangle.fill", value: $queenCells)
        }.cardStyle()
    }
    
    private func toggleRow(label: String, icon: String, value: Binding<Bool>) -> some View {
        Toggle(isOn: value) {
            HStack(spacing: 8) {
                Image(systemName: icon).foregroundColor(Theme.primary).frame(width: 20)
                Text(label).foregroundColor(Theme.textPrimary)
            }
        }.tint(Theme.primary)
    }
    
    private var broodSection: some View {
        VStack(spacing: 10) {
            header(icon: "circle.hexagongrid.fill", title: "Brood Pattern")
            Picker("Brood", selection: $brood) { ForEach(BroodPattern.allCases) { b in Text(b.rawValue).tag(b) } }.pickerStyle(.segmented)
            HStack(spacing: 8) {
                header(icon: "ladybug.fill", title: "Mite Count")
                Spacer()
                Stepper("\(miteCount)", value: $miteCount, in: 0...100).frame(width: 150)
            }
        }.cardStyle()
    }
    
    private var storesSection: some View {
        VStack(spacing: 12) {
            header(icon: "drop.fill", title: "Stores (1-5)")
            HStack {
                Text("Honey").foregroundColor(Theme.textSecondary)
                Spacer()
                Stepper("\(honeyStores)", value: $honeyStores, in: 1...5).frame(width: 150)
            }
            HStack {
                Text("Pollen").foregroundColor(Theme.textSecondary)
                Spacer()
                Stepper("\(pollenStores)", value: $pollenStores, in: 1...5).frame(width: 150)
            }
        }.cardStyle()
    }
    
    private var healthSection: some View {
        VStack(spacing: 10) {
            header(icon: "heart.fill", title: "Mood & Health")
            HStack {
                Text("Mood").foregroundColor(Theme.textSecondary); Spacer()
                Picker("", selection: $mood) { ForEach(BeeMood.allCases) { m in Text(m.rawValue).tag(m) } }.pickerStyle(.segmented)
            }
            HStack {
                Text("Health").foregroundColor(Theme.textSecondary); Spacer()
                Picker("", selection: $health) { ForEach(HiveHealth.allCases) { h in Text(h.rawValue).tag(h) } }.pickerStyle(.menu)
            }
        }.cardStyle()
    }
    
    private var notesSection: some View {
        VStack(spacing: 10) {
            header(icon: "note.text", title: "Notes")
            TextField("Observations...", text: $notes, axis: .vertical).lineLimit(3...6).textFieldStyle(.roundedBorder)
        }.cardStyle()
    }
    
    private func header(icon: String, title: String) -> some View {
        HStack { Image(systemName: icon).foregroundColor(Theme.primary); Text(title).font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
    }
    
    private func save() {
        guard let hiveId = selectedHive else { return }
        let entry = InspectionEntry(hiveId: hiveId, queenSeen: queenSeen, eggsPresent: eggsPresent, larvaePresent: larvaePresent,
                                    queenCellsSeen: queenCells, broodPattern: brood, honeyStores: honeyStores,
                                    pollenStores: pollenStores, mood: mood, miteCount: miteCount, health: health, notes: notes)
        manager.addInspection(entry); dismiss()
    }
}
