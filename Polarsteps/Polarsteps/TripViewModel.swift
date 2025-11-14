import Foundation
import CoreLocation
import Combine

class TripViewModel: ObservableObject {
    @Published var entries: [TripEntry] = []
    @Published var selectedEntry: TripEntry? = nil
    @Published var isShowingAddEntry: Bool = false

    init() {
        // Temporary demo data so you see something on the map later
        let demoEntry = TripEntry(
            title: "Paris Stop",
            note: "Visited Eiffel Tower",
            date: Date(),
            coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
            imageName: "paris_demo",
            category: "City"
        )

        let demoEntry2 = TripEntry(
            title: "Beach Day",
            note: "Relaxed at the beach",
            date: Date(),
            coordinate: CLLocationCoordinate2D(latitude: 41.3851, longitude: 2.1734), // Barcelona
            imageName: "beach_demo",
            category: "Nature"
        )

        entries = [demoEntry, demoEntry2]
    }

    func addEntry(_ entry: TripEntry) {
        entries.append(entry)
    }

    func selectEntry(_ entry: TripEntry?) {
        selectedEntry = entry
    }
}

