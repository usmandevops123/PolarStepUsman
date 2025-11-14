import SwiftUI
import CoreLocation

struct AddEntryView: View {
    @ObservedObject var viewModel: TripViewModel
    @Environment(\.dismiss) private var dismiss

    @StateObject private var locationManager = LocationManager()

    @State private var title: String = ""
    @State private var note: String = ""
    @State private var category: String = "Unknown"

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Basic Info
                Section(header: Text("Basic Info")) {
                    TextField("Title", text: $title)
                    TextField("Note", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                // MARK: - Location Status
                Section(header: Text("Location")) {
                    if let loc = locationManager.currentLocation {
                        Text("📍 Location ready: \(String(format: "%.4f", loc.latitude)), \(String(format: "%.4f", loc.longitude))")
                            .foregroundColor(.green)
                    } else {
                        Text("Fetching location…")
                            .foregroundColor(.secondary)
                    }
                }

                // MARK: - Category
                Section(header: Text("Category")) {
                    TextField("Category (for now, manual)", text: $category)
                }
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEntry() }
                        .disabled(!canSave)
                }
            }
            // Request location automatically
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }

    private var canSave: Bool {
        return !title.isEmpty && locationManager.currentLocation != nil
    }

    private func saveEntry() {
        guard let loc = locationManager.currentLocation else {
            print("⚠️ No location available yet.")
            return
        }

        let newEntry = TripEntry(
            title: title,
            note: note,
            date: Date(),
            coordinate: loc,
            imageName: "placeholder",
            category: category
        )

        viewModel.addEntry(newEntry)
        dismiss()
    }
}

