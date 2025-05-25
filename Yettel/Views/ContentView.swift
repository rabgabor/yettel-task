import SwiftUI

struct ContentView: View {
    
    @State private var response: VehicleInfoResponse?
    @State private var errorMessage: String?
    
    private let api = HighwayAPIClient()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            if let response = response {
                Text(response.name)
                Text(response.plate)
            } else if let errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundStyle(.red)
            } else {
                ProgressView("Loading…")
            }
        }
        .padding()
        .task {
            await fetchVehicleInfo()
        }
    }
    
    private func fetchVehicleInfo() async {
        do {
            let info = try await api.fetchVehicleInfo()
            response = info
        } catch {
            print("Error: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    ContentView()
}
