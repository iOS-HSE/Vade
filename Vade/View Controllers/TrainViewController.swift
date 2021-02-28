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

    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    private var run: Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var isRunStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }

    override func viewDidLayoutSubviews() {
        leftButton.roundSpecificCorners(corners: [.topLeft, .bottomLeft], value: Int(leftButton.frame.height * 0.3))
        rightButton.roundSpecificCorners(corners: [.topRight, .bottomRight], value: Int(rightButton.frame.height * 0.3))
        middleButton.layer.cornerRadius = middleButton.frame.width / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      locationManager.stopUpdatingLocation()
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        switch isRunStarted {
        case true:
            stopRun()
        case false:
            startRun()
        }
    }
    
    @IBAction func middleButtonAction(_ sender: Any) {
        switch isRunStarted {
        case true:
            print("Pause/Stop buttons unlocked")
        case false:
            print("Settings opened")
        }
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        switch isRunStarted {
        case true:
            print("Pause button pressed")
        case false:
            print("Load button pressed")
        }
    }

    func stopRun() {
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
          self.locationManager.stopUpdatingLocation()
          self.seconds = 0
          self.distance = Measurement(value: 0, unit: UnitLength.meters)
          self.timer?.invalidate()
          self.updateDisplay()
          _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    private func startRun() {
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
    
    func configureDefaultButtonsState() {
        rightButton.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.7803921569, blue: 0.3960784314, alpha: 1)
        rightButton.setTitle("START", for: .normal)
        leftButton.backgroundColor = #colorLiteral(red: 0.5342861414, green: 0.5927858353, blue: 0.850332737, alpha: 1)
        leftButton.setTitle("LOAD", for: .normal)
        middleButton.setImage(UIImage(named: "settings"), for: .normal)
    }
    
    func configureRunningButtonsState() {
        
        rightButton.isEnabled = false
        rightButton.setTitle("STOP", for: .normal)
        
        leftButton.isEnabled = false
        leftButton.setTitle("PAUSE", for: .normal)
        middleButton.setImage(UIImage(named: "lock"), for: .normal)
        
        changeButtonsState(isLocked: true)
    }
    
    func changeButtonsState(isLocked: Bool) {
        rightButton.isEnabled = isLocked
        leftButton.isEnabled = isLocked
        
        switch isLocked {
        case true:
            rightButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            leftButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case false:
            rightButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            leftButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
    }
    
    func changeButtonsState() {
        switch isRunStarted {
        case true:
            configureDefaultButtonsState()
        case false:
            configureRunningButtonsState()
        }
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
      
      distanceLabel.text = "\(formattedDistance)"
      timeLabel.text = "\(formattedTime)"
      speedLabel.text = "\(formattedPace)"
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

extension UIButton {
    func roundSpecificCorners(corners: UIRectCorner, value: Int) {
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: value, height: value))
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
