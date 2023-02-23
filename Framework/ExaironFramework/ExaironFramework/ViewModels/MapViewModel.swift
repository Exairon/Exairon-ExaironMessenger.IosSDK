//
//  MapViewModel.swift
//  ExaironFramework
//
//  Created by Exairon on 14.02.2023.
//

import Foundation
import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.159363, longitude: 28.895810), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert letting them know this is off and to go turn it on")
        }
    }
    
    func locationManager( _ _manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let latestLocation = locations.first else {
            // show an error
            return
        }
        DispatchQueue.main.async{
            self.region = MKCoordinateRegion(
                center: latestLocation.coordinate,
                span:MKCoordinateSpan(latitudeDelta:0.05, longitudeDelta:0.05))
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return }
        
        /*switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            break
        }*/
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
