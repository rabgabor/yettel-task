import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VehicleViewModel()
    @State private var selectedID: String?

    var body: some View {
        NavigationStack {
            List {
                if let vehicleSummary = viewModel.vehicleSummary {
                    Section { VehicleSummaryRow(vehicleSummary: vehicleSummary) }
                }
                
                if !viewModel.nationalVignetteOptions.isEmpty {
                    Section(header: Text("Országos matricák")) {
                        ForEach(viewModel.nationalVignetteOptions, id: \.id) { vignette in
                            VignetteSelectRow(nationalVignetteOption: vignette, isSelected: selectedID == vignette.id)
                                .onTapGesture {
                                    selectedID = vignette.id
                                }
                        }
                        
                        if let sel = selectedID, let selected = viewModel.nationalVignetteOptions.first(where: { $0.id == sel }) {
                            NavigationLink("Vásárlás") {
                                Text("Vásárlás képernyő")
                            }
                        }
                    }
                }
                
                if !viewModel.countyVignetteOptions.isEmpty {
                    Section {
                        NavigationLink("Éves vármegyei matricák") {
                            Text("Megyei matrica képernyő")
                        }
                    }
                }
                
                if let err = viewModel.errorMessage {
                    Section { Text("Hiba: \(err)").foregroundStyle(.red) }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("E-matrica")
            .navigationBarTitleDisplayMode(.large)
            .task {
                guard !viewModel.hasLoaded else { return }
                await load()
            }
            .overlay {
                if !viewModel.hasLoaded {
                    ZStack {
                        Color(.systemBackground).opacity(0.6)
                        ProgressView().scaleEffect(1.4)
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    private func load() async {
        await viewModel.load()
        selectedID = viewModel.defaultOptionID
    }
}

#Preview {
    ContentView()
        .environmentObject(VehicleViewModel(api: MockHighwayService()))
}
