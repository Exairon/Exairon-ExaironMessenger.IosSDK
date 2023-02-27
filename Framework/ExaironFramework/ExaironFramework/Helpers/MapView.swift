import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {

    typealias UIViewType = MKMapView
    @State private var myMapView: MKMapView?
    let chatViewModel: ChatViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView

        let sfCoord = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

        init(_ control: MapView) {
            self.control = control
        }

        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if let annotationView = views.first {
                if let annotation = annotationView.annotation {
                    if annotation is MKUserLocation {
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                        mapView.setRegion(region, animated: true)
                    }
                }
            }
        }//did add

        @objc func addAnnotationOnTapGesture(sender: UITapGestureRecognizer) {
            if sender.state == .ended {
                let point = sender.location(in: control.myMapView)
                let coordinate = control.myMapView?.convert(point, toCoordinateFrom: control.myMapView)
                let annotation = MKPointAnnotation()
                //control.selectedLocation = Double(coordinate?.longitude ?? 0)
                control.chatViewModel.selectedLocationLatitude = Double(coordinate?.latitude ?? 0)
                control.chatViewModel.selectedLocationLongitude = Double(coordinate?.longitude ?? 0)
                annotation.coordinate = coordinate ?? sfCoord
                annotation.title = "Selected Location"
                let previousAnnotions = control.myMapView?.annotations ?? []
                control.myMapView?.removeAnnotations(previousAnnotions)
                control.myMapView?.addAnnotation(annotation)
            }
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
    
        DispatchQueue.main.async {
            self.myMapView = map
        }
    
        let gRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addAnnotationOnTapGesture(sender:)))
        map.addGestureRecognizer(gRecognizer)

        return map
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
}

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
    
        self.location = location
    }
}
