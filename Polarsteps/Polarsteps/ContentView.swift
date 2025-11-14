import SwiftUI
import MapKit

struct ContentView: View {
    // Our shared “brain”
    @StateObject private var viewModel = TripViewModel()

    // The visible region of the map
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), // Paris area
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // MARK: - MAP
            Map(coordinateRegion: $region, annotationItems: viewModel.entries) { entry in
                MapAnnotation(coordinate: entry.coordinate) {
                    Button {
                        viewModel.selectEntry(entry)
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                            Text(entry.title)
                                .font(.caption2)
                                .padding(2)
                                .background(.thinMaterial)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // MARK: - ADD ENTRY BUTTON
            Button {
                viewModel.isShowingAddEntry = true
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .padding()
                    .background(Circle().fill(Color.accentColor))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
            }
            .padding()
            .sheet(isPresented: $viewModel.isShowingAddEntry) {
                AddEntryView(viewModel: viewModel)
            }

            // MARK: - BOTTOM SHEET
            if let selected = viewModel.selectedEntry {
                EntryDetailSheetView(entry: selected) {
                    viewModel.selectEntry(nil)
                }
                .transition(.move(edge: .bottom))
            }
        }
        // MARK: - RECENTER MAP ON NEW ENTRIES
        .onChange(of: viewModel.entries.count) { _ in
            if let last = viewModel.entries.last {
                region.center = last.coordinate
                viewModel.selectEntry(last)
            }
        }
    }
}

// MARK: - BOTTOM SHEET VIEW
struct EntryDetailSheetView: View {
    let entry: TripEntry
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.title)
                    .font(.headline)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.headline)
                }
            }

            Text(entry.note)
                .font(.subheadline)

            Text("Category: \(entry.category)")
                .font(.caption)
                .padding(4)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)

            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding()
    }
}

