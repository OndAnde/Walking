//
//  ViewController.swift
//  Walking
//
//  Created by Pavel Manulik on 13.05.21.
//

import UIKit
import MapboxMaps
import MapboxCoreMaps
import MapboxCommon

 
class ViewController: UIViewController {
    
    @IBOutlet weak var Controls: UIView!
    internal var mapView: MapView!
    internal var cameraLocationConsumer: CameraLocationConsumer!
    internal var custompoint1: PointAnnotation!
 
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let url : String?
 
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1Ijoib25kYW5kZSIsImEiOiJja29nNzg0ZnkwdGJnMm90cm10eDZyNHNsIn0.YyirnZeCZd1Dn5F08uVjbw")
        // Create a URL for a custom style created in Mapbox Studio.
        guard let customStyleURL = URL(string: "mapbox://styles/ondande/ckom368j5239g19o18o7djqzg") else {
            fatalError("Style URL is invalid")
        }

        self.mapView = MapView(with: view.bounds, resourceOptions: myResourceOptions, styleURL: .custom(url: customStyleURL))
 
        self.view.addSubview(mapView)
        
        cameraLocationConsumer = CameraLocationConsumer(shouldTrackLocation: true, mapView: mapView)

        // Add user position icon to the map with location indicator layer
        mapView.update { (mapOptions) in
            mapOptions.location.showUserLocation = true
        }
        
        self.view.sendSubviewToBack(mapView)
        
        self.view.bringSubviewToFront(Controls)
        
        

        // Set initial camera settings
        mapView.cameraManager.setCamera(zoom: 20.0)

        // Allows the delegate to receive information about map events.
        mapView.on(.mapLoadingFinished) { [weak self] _ in
            guard let self = self else { return }

            // Register the location consumer with the map
            // Note that the location manager holds weak references to consumers, which should be retained
            self.mapView.locationManager.addLocationConsumer(newConsumer: self.cameraLocationConsumer)
            
            self.scanningAction()

        }
    }

    public func scanningAction(){
        
        self.custompoint1 = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 53.927751, longitude: 27.416519),
                                                    image: UIImage(named: "marker.svg"))

        
        // Add the annotation to the map.
        mapView.annotationManager.addAnnotation(self.custompoint1)
        
        
    }
    
}

// Create class which conforms to LocationConsumer, update the camera's centerCoordinate when a locationUpdate is received
public class CameraLocationConsumer: LocationConsumer {
    public var shouldTrackLocation: Bool

    weak var mapView: MapView?

    init(shouldTrackLocation: Bool, mapView: MapView) {
        self.shouldTrackLocation = shouldTrackLocation
        self.mapView = mapView
    }

    public func locationUpdate(newLocation: Location) {
        mapView?.cameraManager.setCamera(centerCoordinate: newLocation.coordinate, zoom: 16, animated: true, duration: 1.3)
    }
}

