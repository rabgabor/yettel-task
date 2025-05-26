import SwiftUI

struct CountySelectionView: View {
    @StateObject var viewModel: CountySelectionViewModel

    var body: some View {
        List {
            mapSection
            countyRowsSection
            if viewModel.hasIsolatedSelection { warningSection }
            totalSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Éves vármegyei")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension CountySelectionView {

    private var mapSection: some View {
        Section {
            HStack {
                Spacer()
                ZStack {
                    ForEach(viewModel.options, id: \.id) { option in
                        Image(option.id)
                            .renderingMode(.template)
                            .foregroundColor(viewModel.isSelected(option.id) ? .accentColor : .secondary)
                            .allowsHitTesting(false)
                    }
                    
                    Image("BP")
                        .renderingMode(.template)
                        .foregroundColor(.secondary)
                        .allowsHitTesting(false)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.vertical, 8)
                
                Spacer()
            }
        }
    }

    private var countyRowsSection: some View {
        Section {
            ForEach(viewModel.options) { option in
                CountyRow(option: option, isSelected: viewModel.isSelected(option.id)) {
                    viewModel.toggle(option.id)
                }
            }
        }
    }

    private var warningSection: some View {
        Section {
            Label("A kijelölt vármegyék nem szomszédosak!",
                  systemImage: "exclamationmark.triangle.fill")
            .foregroundStyle(.orange)
                .font(.footnote)
        }
    }

    private var totalSection: some View {
        Section {
            HStack {
                Text("Fizetendő összeg")
                Spacer()
                Text(viewModel.totalPriceText).bold()
            }
            NavigationLink("Vásárlás") {
                Text("Vásárlás képernyő")
            }
            .disabled(viewModel.selectedIDs.isEmpty)
            .opacity(viewModel.selectedIDs.isEmpty ? 0.4 : 1)
        }
    }
}

#if DEBUG
private let sampleCountyOptions: [CountyVignetteOption] = [
    CountyVignetteOption(id: "YEAR_11", countyName: "Bács-Kiskun", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_12", countyName: "Baranya", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_13", countyName: "Békés", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_14", countyName: "Borsod-Abaúj-Zemplén", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_15", countyName: "Csongrád", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_16", countyName: "Fejér", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_17", countyName: "Győr-Moson-Sopron", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_18", countyName: "Hajdú-Bihar", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_19", countyName: "Heves", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_20", countyName: "Jász-Nagykun-Szolnok", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_21", countyName: "Komárom-Esztergom", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_22", countyName: "Nógrád", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_23", countyName: "Pest", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_24", countyName: "Somogy", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_25", countyName: "Szabolcs-Szatmár-Bereg", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_26", countyName: "Tolna", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_27", countyName: "Vas", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_28", countyName: "Veszprém", price: "9 000 Ft"),
    CountyVignetteOption(id: "YEAR_29", countyName: "Zala", price: "9 000 Ft"),
]

struct CountySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CountySelectionView(viewModel: CountySelectionViewModel(options: sampleCountyOptions))
        }
    }
}
#endif
