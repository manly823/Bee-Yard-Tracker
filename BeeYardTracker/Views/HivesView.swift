import SwiftUI

struct HivesView: View {
    @EnvironmentObject var manager: BeeManager
    @Environment(\.dismiss) var dismiss
    @State private var showAddHive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(manager.hives) { hive in hiveCard(hive) }
                        if manager.hives.isEmpty { emptyState }
                    }.padding()
                }
            }
            .navigationTitle("My Hives").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Done") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddHive = true }) {
                        Image(systemName: "plus.circle.fill").foregroundColor(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showAddHive) { AddHiveView().environmentObject(manager) }
        }
    }
    
    private func hiveCard(_ hive: Hive) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: hive.type.icon).foregroundColor(Theme.hive)
                Text(hive.name).font(.headline).foregroundColor(Theme.textPrimary)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: hive.queenStatus.icon).font(.caption)
                    Text(hive.queenStatus.rawValue).font(.caption)
                }.foregroundColor(hive.queenStatus.color)
            }
            
            HStack(spacing: 16) {
                infoPill(icon: "mappin", text: hive.location)
                infoPill(icon: "crown.fill", text: "\(hive.queenAgeDays)d old")
                if hive.queenMarkerColor != .unmarked {
                    Circle().fill(hive.queenMarkerColor.color).frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))
                }
            }
            
            if let last = manager.lastInspection(for: hive) {
                HStack(spacing: 12) {
                    healthBadge(last.health)
                    Text("Last: \(last.date, style: .date)").font(.caption).foregroundColor(Theme.textSecondary)
                    Spacer()
                    Text("Mites: \(last.miteCount)").font(.caption).foregroundColor(last.miteCount > 3 ? Theme.danger : Theme.textSecondary)
                }
            }
            
            if !hive.notes.isEmpty {
                Text(hive.notes).font(.caption).foregroundColor(Theme.textSecondary).lineLimit(2)
            }
        }
        .cardStyle()
        .contextMenu { Button(role: .destructive) { manager.deleteHive(hive) } label: { Label("Delete", systemImage: "trash") } }
    }
    
    private func infoPill(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon).font(.caption2)
            Text(text).font(.caption)
        }.foregroundColor(Theme.textSecondary)
    }
    
    private func healthBadge(_ health: HiveHealth) -> some View {
        Text(health.rawValue).font(.caption2.bold()).foregroundColor(.white)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(health.color).cornerRadius(8)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.stack.3d.up").font(.system(size: 40)).foregroundColor(Theme.textSecondary.opacity(0.5))
            Text("No hives yet").foregroundColor(Theme.textSecondary)
            Button("Add First Hive") { showAddHive = true }
                .font(.headline).foregroundColor(.white)
                .padding(.horizontal, 24).padding(.vertical, 10)
                .background(Theme.primaryGradient).cornerRadius(12)
        }.padding(.top, 60)
    }
}
