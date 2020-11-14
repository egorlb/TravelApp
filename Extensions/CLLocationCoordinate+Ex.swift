import Foundation
import MapKit

extension CLLocationCoordinate2D {
    func getPoint() -> CGPoint {
        return CGPoint(x: self.latitude.rounded(2), y: self.longitude.rounded(2))
    }
}

