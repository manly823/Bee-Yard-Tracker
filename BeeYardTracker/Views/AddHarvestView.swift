import SwiftUI

struct AddHarvestView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedHive: UUID?
    @State private var weightKg: Double = 5.0
    @State private var honeyType: HoneyType = .wildflower
    @State private var taste = 3
    @State private var clarity = 3
    @State private var aroma = 3
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        hiveSection
                        harvestSection
                        ratingsSection
                        notesSection
                    }.padding()
                }
            }
            .navigationTitle("Log Harvest").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }.font(.headline).foregroundColor(Theme.primary).disabled(selectedHive == nil)
                }
            }
            .onAppear { selectedHive = manager.hives.first?.id }
        }
    }
    
    private var hiveSection: some View {
        VStack(spacing: 10) {
            header(icon: "square.stack.3d.up.fill", title: "From Hive")
            Picker("Hive", selection: $selectedHive) {
                ForEach(manager.hives) { h in Text(h.name).tag(Optional(h.id)) }
            }.pickerStyle(.segmented)
        }.cardStyle()
    }
    
    private var harvestSection: some View {
        VStack(spacing: 12) {
            header(icon: "drop.fill", title: "Harvest Details")
            HStack {
                Text("Type").foregroundColor(Theme.textSecondary); Spacer()
                Picker("", selection: $honeyType) { ForEach(HoneyType.allCases) { t in Text(t.rawValue).tag(t) } }.pickerStyle(.menu)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Weight: \(String(format: "%.1f", weightKg)) kg").foregroundColor(Theme.textSecondary)
                Slider(value: $weightKg, in: 0.5...100, step: 0.5).tint(Theme.honey)
            }
        }.cardStyle()
    }
    
    private var ratingsSection: some View {
        VStack(spacing: 12) {
            header(icon: "star.fill", title: "Quality Ratings")
            starRow(label: "Taste", value: $taste)
            starRow(label: "Clarity", value: $clarity)
            starRow(label: "Aroma", value: $aroma)
        }.cardStyle()
    }
    
    private func starRow(label: String, value: Binding<Int>) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(Theme.textSecondary).frame(width: 70, alignment: .leading)
            Spacer()
            ForEach(1...5, id: \.self) { i in
                Button(action: { value.wrappedValue = i }) {
                    Image(systemName: i <= value.wrappedValue ? "star.fill" : "star")
                        .foregroundColor(i <= value.wrappedValue ? Theme.primary : Theme.textSecondary.opacity(0.3)).font(.title3)
                }
            }
        }
    }
    
    private var notesSection: some View {
        VStack(spacing: 10) {
            header(icon: "note.text", title: "Notes")
            TextField("Tasting notes...", text: $notes, axis: .vertical).lineLimit(3...5).textFieldStyle(.roundedBorder)
        }.cardStyle()
    }
    
    private func header(icon: String, title: String) -> some View {
        HStack { Image(systemName: icon).foregroundColor(Theme.primary); Text(title).font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
    }
    
    private func save() {
        guard let hiveId = selectedHive else { return }
        let entry = HarvestEntry(hiveId: hiveId, weightKg: weightKg, honeyType: honeyType,
                                 tasteRating: taste, clarityRating: clarity, aromaRating: aroma, notes: notes)
        manager.addHarvest(entry); dismiss()
    }
}
