//
//  TrainViewController.swift
//  Vade
//
//  Created by Egor on 16.12.2020.
//

import UIKit
import MapKit
import HealthKit
import CoreLocation

class TrainViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activationButton: UIButton!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    private var run: Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      locationManager.stopUpdatingLocation()
    }
    
    @IBAction func activationButtonAction(_ sender: Any) {
        if activationButton.currentTitle == "Start" {
            startRun()
        }
        else {
            let alertController = UIAlertController(title: "End run?",
                                                    message: "Do you wish to end your run?",
                                                    preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
              self.stopRun()
              self.saveRun()
              self.seconds = 0
              self.distance = Measurement(value: 0, unit: UnitLength.meters)
              self.timer?.invalidate()
              self.updateDisplay()
              let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.runDetailsVC) as RunDetailsViewController
              detailsVC.run = self.run
              self.navigationController?.pushViewController(detailsVC, animated: true)
            })
            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
              self.stopRun()
              self.seconds = 0
              self.distance = Measurement(value: 0, unit: UnitLength.meters)
              self.timer?.invalidate()
              self.updateDisplay()
              _ = self.navigationController?.popToRootViewController(animated: true)
            })
            
            present(alertController, animated: true)
        }
    }
    
    private func startRun() {
      self.activationButton.setTitle("Stop", for: .normal)
      mapView.removeOverlays(mapView.overlays)
      
      seconds = 0
      distance = Measurement(value: 0, unit: UnitLength.meters)
      locationList.removeAll()
      updateDisplay()
      timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
        self.eachSecond()
      }
      startLocationUpdates()
    }
    
    private func stopRun() {
      activationButton.setTitle("Start", for: .normal)
      locationManager.stopUpdatingLocation()
    }
    
    func eachSecond() {
      seconds += 1
      updateDisplay()
    }
    
    private func updateDisplay() {
      let formattedDistance = FormatDisplay.distance(distance)
      let formattedTime = FormatDisplay.time(seconds)
      let formattedPace = FormatDisplay.pace(distance: distance,
                                             seconds: seconds,
                                             outputUnit: UnitSpeed.minutesPerMile)
      
      distanceLabel.text = "Distance:  \(formattedDistance)"
      timeLabel.text = "Time:  \(formattedTime)"
      paceLabel.text = "Pace:  \(formattedPace)"
    }
    
    private func startLocationUpdates() {
      locationManager.delegate = self
      locationManager.activityType = .fitness
      locationManager.distanceFilter = 10
      locationManager.startUpdatingLocation()
    }
    
    private func saveRun() {
      let newRun = Run(context: CoreDataStack.context)
      newRun.distance = distance.value
      newRun.duration = Int16(seconds)
      newRun.timestamp = Date()
      
      for location in locationList {
        let locationObject = Location(context: CoreDataStack.context)
        locationObject.timestamp = location.timestamp
        locationObject.latitude = location.coordinate.latitude
        locationObject.longitude = location.coordinate.longitude
        newRun.addToLocations(locationObject)
      }
      
      CoreDataStack.saveContext()
      
      run = newRun
    }
}

extension TrainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

            if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            let coordinates = [lastLocation.coordinate, newLocation.coordinate]
            mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            }

            locationList.append(newLocation)
        }
    }
}


extension TrainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
