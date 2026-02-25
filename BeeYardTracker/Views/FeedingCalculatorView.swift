import SwiftUI

struct FeedingCalculatorView: View {
    @Environment(\.dismiss) var dismiss
    @State private var feedType: FeedType = .lightSyrup
    @State private var sugarKg: Double = 2.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        feedSelector
                        inputSection
                        resultSection
                        guideSection
                    }.padding()
                }
            }
            .navigationTitle("Feeding Calculator").navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
    
    private var feedSelector: some View {
        VStack(spacing: 10) {
            HStack { Image(systemName: "cup.and.saucer.fill").foregroundColor(.orange); Text("Feed Type").font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
            ForEach(FeedType.allCases) { ft in
                feedOption(ft)
            }
        }.cardStyle()
    }
    
    private func feedOption(_ ft: FeedType) -> some View {
        let selected = feedType == ft
        return Button(action: { feedType = ft }) {
            HStack {
                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(selected ? Theme.primary : Theme.textSecondary.opacity(0.4))
                VStack(alignment: .leading, spacing: 2) {
                    Text(ft.rawValue).font(.subheadline).foregroundColor(Theme.textPrimary)
                    Text(ft.season).font(.caption).foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
        }
    }
    
    private var inputSection: some View {
        VStack(spacing: 10) {
            HStack { Image(systemName: "scalemass.fill").foregroundColor(Theme.primary); Text("Sugar Amount").font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
            Text("\(String(format: "%.1f", sugarKg)) kg sugar").font(.title2.bold()).foregroundColor(Theme.primary)
            Slider(value: $sugarKg, in: 0.5...20, step: 0.5).tint(Theme.honey)
        }.cardStyle()
    }
    
    private var resultSection: some View {
        let waterL: Double
        let totalKg: Double
        switch feedType {
        case .lightSyrup: waterL = sugarKg; totalKg = sugarKg * 2
        case .heavySyrup: waterL = sugarKg / 2; totalKg = sugarKg * 1.5
        case .fondant: waterL = 0; totalKg = sugarKg
        case .pollenPatty: waterL = 0; totalKg = sugarKg
        }
        
        return VStack(spacing: 12) {
            HStack { Image(systemName: "flask.fill").foregroundColor(Theme.honey); Text("Result").font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
            
            HStack(spacing: 20) {
                resultItem(label: "Sugar", value: String(format: "%.1f kg", sugarKg), color: Theme.primary)
                if waterL > 0 {
                    resultItem(label: "Water", value: String(format: "%.1f L", waterL), color: .blue)
                }
                resultItem(label: "Total", value: String(format: "%.1f kg", totalKg), color: Theme.honey)
            }
            
            Text(feedType.ratio).font(.caption).foregroundColor(Theme.textSecondary)
        }.cardStyle()
    }
    
    private func resultItem(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title3.bold()).foregroundColor(color)
            Text(label).font(.caption).foregroundColor(Theme.textSecondary)
        }.frame(maxWidth: .infinity)
    }
    
    private var guideSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack { Image(systemName: "book.fill").foregroundColor(Theme.hive); Text("Feeding Guide").font(.headline).foregroundColor(Theme.textPrimary); Spacer() }
            guideRow(icon: "leaf.fill", text: "Spring: 1:1 syrup stimulates brood rearing and comb building", color: .green)
            guideRow(icon: "sun.max.fill", text: "Summer: generally no feeding needed during nectar flow", color: .yellow)
            guideRow(icon: "wind", text: "Fall: 2:1 syrup builds winter stores. Target 18-27 kg total", color: .orange)
            guideRow(icon: "snowflake", text: "Winter: fondant only for emergency. Minimal disturbance", color: .blue)
        }.cardStyle()
    }
    
    private func guideRow(icon: String, text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).foregroundColor(color).frame(width: 20)
            Text(text).font(.caption).foregroundColor(Theme.textSecondary)
        }
    }
}
