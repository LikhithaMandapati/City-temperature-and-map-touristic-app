//
//  ViewController.swift
//  Exercise6_Mandapati_Likhitha
//
//  Created by student on 10/13/22.
//

import UIKit
import MapKit
import UserNotifications
class ViewController: UIViewController {

    var n = 1
    @IBOutlet weak var map: MKMapView!
    
    var selectedCity = City()
    override func viewDidLoad() {
        super.viewDidLoad()
        showMap()
        setUpLongPressGestureRecognizer()
    }

    func showMap() {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let cityLocation = CLLocationCoordinate2DMake(selectedCity.cap_lat, selectedCity.cap_long)
        let region = MKCoordinateRegion(center: cityLocation, span: span)
        
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        let loc = CLLocation(latitude: selectedCity.cap_lat, longitude: selectedCity.cap_long)
        CLGeocoder().reverseGeocodeLocation(loc) {(placemark,error)
            in
            if error != nil {
                print("error in map reverse doc location")
                return
            }
            if let place = placemark?[0] {
                let annotation = MKPointAnnotation()
                annotation.coordinate = cityLocation
                annotation.title = "\(self.selectedCity.country)"
                annotation.subtitle = "\(place.locality!), \(place.administrativeArea!), \(place.isoCountryCode!)"
                
                DispatchQueue.main.async {
                    self.map.addAnnotation(annotation)
                }
            }
        }
    }
    func setUpLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        longPressGestureRecognizer.minimumPressDuration = 2.0
        map.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer){
        if press.state == .began {
            let location = press.location(in: map)
            let coordinates = map.convert(location, toCoordinateFrom: map)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "Pin #\(n)"
            n += 1
            annotation.subtitle = "you planned to visit this place"
            map.addAnnotation(annotation)        }
    }
}

