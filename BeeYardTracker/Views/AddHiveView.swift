import SwiftUI

struct AddHiveView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type: HiveType = .langstroth
    @State private var location = ""
    @State private var queenStatus: QueenStatus = .present
    @State private var markerColor: QueenMarkerColor = .unmarked
    @State private var queenDate = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        detailsSection
                        queenSection
                        notesSection
                    }.padding()
                }
            }
            .navigationTitle("New Hive").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveHive() }.font(.headline).foregroundColor(Theme.primary).disabled(name.isEmpty)
                }
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(spacing: 12) {
            header(icon: "square.stack.3d.up.fill", title: "Hive Details")
            TextField("Hive name", text: $name).textFieldStyle(.roundedBorder)
            TextField("Location", text: $location).textFieldStyle(.roundedBorder)
            Picker("Type", selection: $type) { ForEach(HiveType.allCases) { t in Text(t.rawValue).tag(t) } }.pickerStyle(.segmented)
        }.cardStyle()
    }
    
    private var queenSection: some View {
        VStack(spacing: 12) {
            header(icon: "crown.fill", title: "Queen Info")
            HStack {
                Text("Status").foregroundColor(Theme.textSecondary)
                Spacer()
                Picker("", selection: $queenStatus) { ForEach(QueenStatus.allCases) { s in Text(s.rawValue).tag(s) } }.pickerStyle(.menu)
            }
            HStack {
                Text("Marker Color").foregroundColor(Theme.textSecondary)
                Spacer()
                Picker("", selection: $markerColor) { ForEach(QueenMarkerColor.allCases) { c in Text(c.rawValue).tag(c) } }.pickerStyle(.menu)
            }
            DatePicker("Queen Installed", selection: $queenDate, displayedComponents: .date)
                .foregroundColor(Theme.textSecondary)
        }.cardStyle()
    }
    
    private var notesSection: some View {
        VStack(spacing: 10) {
            header(icon: "note.text", title: "Notes")
            TextField("Notes...", text: $notes, axis: .vertical).lineLimit(3...5).textFieldStyle(.roundedBorder)
        }.cardStyle()
    }
    
    private func header(icon: String, title: String) -> some View {
        HStack { Image(systemName: icon).foregroundColor(Theme.primary); Text(title).font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
    }
    
    private func saveHive() {
        let hive = Hive(name: name, type: type, location: location, queenStatus: queenStatus,
                        queenMarkerColor: markerColor, queenInstalledDate: queenDate, notes: notes)
        manager.addHive(hive); dismiss()
    }
}
