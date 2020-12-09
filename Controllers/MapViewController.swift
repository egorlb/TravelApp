import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    
    var closure: ((CGPoint) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func longTap(sender: UIGestureRecognizer) {
        if sender.state == .began {
            mapView.removeAnnotations(mapView.annotations)
            
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationOnMap
            mapView.addAnnotation(annotation)
            
            let point = locationOnMap.getPoint()
            closure?(point)
        }
    }
    
    // MARK: - Private
    
    private func configureUI() {
        let longTapGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longTap(sender:)))
        mapView.addGestureRecognizer(longTapGesture)
    }
}
