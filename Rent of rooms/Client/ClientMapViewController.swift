//
//  ClientMapViewController.swift
//  Rent of rooms
//
//  Created by Administrator on 06.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit
import MapKit

class ClientMapViewController: UIViewController {

    var client: Client!
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
        
        mapView.delegate = self

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(client.adress!) { (plasemarks, error) in
            
            guard error == nil else { return }
            guard let plasemarks = plasemarks else { return }
            
            let plasemark = plasemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.client.name
            annotation.subtitle = self.client.phone
            
            guard let location = plasemark?.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
        title = NSLocalizedString("Map", comment: "")
    }
}

extension ClientMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "restAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let ringhtImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        ringhtImageView.image = UIImage(data: client.image! as Data)
        annotationView?.rightCalloutAccessoryView = ringhtImageView
        
        annotationView?.pinTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        return annotationView
    }
}
