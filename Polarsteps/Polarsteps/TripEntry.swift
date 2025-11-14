import Foundation
import CoreLocation

struct TripEntry: Identifiable {
    let id = UUID()
    var title: String
    var note: String
    var date: Date
    var coordinate: CLLocationCoordinate2D
    var imageName: String       // for now, just a placeholder
    var category: String        // from ML later, e.g. "Nature"
}

