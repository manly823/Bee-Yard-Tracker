import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedSeason: SeasonType = .spring
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                VStack(spacing: 0) {
                    seasonPicker
                    ScrollView {
                        VStack(spacing: 12) {
                            seasonHeader
                            tasksList
                        }.padding()
                    }
                }
            }
            .navigationTitle("Seasonal Calendar").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
    
    private var seasonPicker: some View {
        HStack(spacing: 0) {
            ForEach(SeasonType.allCases) { season in
                seasonTab(season)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func seasonTab(_ season: SeasonType) -> some View {
        let selected = selectedSeason == season
        return Button(action: { withAnimation { selectedSeason = season } }) {
            VStack(spacing: 4) {
                Image(systemName: season.icon).font(.title3)
                Text(season.rawValue).font(.caption.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(selected ? season.color.opacity(0.2) : Color.clear)
            .foregroundColor(selected ? season.color : Theme.textSecondary)
            .cornerRadius(12)
        }
    }
    
    private var seasonHeader: some View {
        HStack {
            Image(systemName: selectedSeason.icon).font(.title).foregroundColor(selectedSeason.color)
            VStack(alignment: .leading, spacing: 2) {
                Text(selectedSeason.rawValue + " Tasks").font(.title2.bold()).foregroundColor(Theme.textPrimary)
                Text(seasonMonths).font(.caption).foregroundColor(Theme.textSecondary)
            }
            Spacer()
        }
        .cardStyle(opacity: 0.4)
    }
    
    private var seasonMonths: String {
        switch selectedSeason {
        case .spring: return "March – May"
        case .summer: return "June – August"
        case .fall: return "September – November"
        case .winter: return "December – February"
        }
    }
    
    private var tasksList: some View {
        let tasks = BeeManager.seasonalTasks.first { $0.season == selectedSeason }?.tasks ?? []
        return ForEach(Array(tasks.enumerated()), id: \.offset) { idx, task in
            taskRow(number: idx + 1, text: task)
        }
    }
    
    private func taskRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle().fill(selectedSeason.color.opacity(0.15)).frame(width: 30, height: 30)
                Text("\(number)").font(.caption.bold()).foregroundColor(selectedSeason.color)
            }
            Text(text).font(.subheadline).foregroundColor(Theme.textPrimary)
            Spacer()
        }
        .cardStyle()
    }
}
