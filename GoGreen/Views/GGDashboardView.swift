import UIKit
import MapKit
import CoreLocation

final class GGDashboardView: UIView, CLLocationManagerDelegate {
    private var tripCoordinates: [CLLocationCoordinate2D] = []
    private var tripSpeeds: [CLLocationSpeed] = []
    private var tripTransitStops: [Bool] = []
    private var tripLine: MKPolylineRenderer?
    private var totalDistance: CLLocationDistance = 0.0
    private var tripDetailsView: UIView?
    private var submitButton: UIButton?
    private var modeOfTransportLabel: UILabel?
    private var totalDistanceLabel: UILabel?
    private var emissionsSavedLabel: UILabel?
    private var xpAwardedLabel: UILabel?
    
    private let viewModel = GGDashboardViewViewModel()
    
    private let locationManager = CLLocationManager()
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    private let tripButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Trip!", for: .normal)
        button.setTitleColor(.white, for: .normal) // Set text color to white
        button.backgroundColor = UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    private var tripInProgress = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 20
                
        addSubviews(mapView, tripButton)
        addConstraints()
        
        tripButton.addTarget(self, action: #selector(tripButtonTapped), for: .touchUpInside)
        mapView.delegate = self
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        if tripInProgress {
            tripCoordinates.append(location.coordinate)
            tripSpeeds.append(location.speed)
            let polyline = MKPolyline(coordinates: tripCoordinates, count: tripCoordinates.count)
            mapView.addOverlay(polyline)
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "Public Transit"
            searchRequest.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            let localSearch = MKLocalSearch(request: searchRequest)
            localSearch.start { (response, error) in
                guard error == nil else {
                    print("Error searching for public transit stops: \(error!.localizedDescription)")
                    self.tripTransitStops.append(false)
                    return
                }
                guard let mapItems = response?.mapItems else {
                    print("No results found for public transit stops.")
                    self.tripTransitStops.append(false)
                    return
                }
                var shortestDistance = Double.infinity
                for mapItem in mapItems {
                    let stopLocation = mapItem.placemark.coordinate
                    let distance = location.distance(from: CLLocation(latitude: stopLocation.latitude, longitude: stopLocation.longitude))
                    if distance < shortestDistance {
                        shortestDistance = distance
                    }
                }
                if shortestDistance < 100 {
                    self.tripTransitStops.append(true)
                } else {
                    self.tripTransitStops.append(false)
                }
            }
            
            if let previousLocation = tripCoordinates.dropLast().last {
                let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
                totalDistance += distance
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tripButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tripButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func showTripDetails(trip_results: GGDashboardResult) {
        let tripDetailsView = UIView()
        tripDetailsView.backgroundColor = .white
        tripDetailsView.layer.cornerRadius = 10
        tripDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        let modeOfTransportLabel = UILabel()
        modeOfTransportLabel.text = "Mode of Transport: \(trip_results.mode_of_transport)"
        modeOfTransportLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let totalDistanceLabel = UILabel()
        totalDistanceLabel.text = "Total Distance: \(trip_results.total_distance)"
        totalDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let emissionsSavedLabel = UILabel()
        emissionsSavedLabel.text = "Emissions Saved: \(trip_results.emissions_saved)"
        emissionsSavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let xpAwardedLabel = UILabel()
        xpAwardedLabel.text = "XP Awarded: \(trip_results.xp_awarded)"
        xpAwardedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Got it!", for: .normal)
        submitButton.backgroundColor = .systemGreen
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        
        tripDetailsView.addSubview(modeOfTransportLabel)
        tripDetailsView.addSubview(totalDistanceLabel)
        tripDetailsView.addSubview(emissionsSavedLabel)
        tripDetailsView.addSubview(xpAwardedLabel)
        tripDetailsView.addSubview(submitButton)
        
        addSubview(tripDetailsView)
        NSLayoutConstraint.activate([
            tripDetailsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tripDetailsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tripDetailsView.widthAnchor.constraint(equalToConstant: 300),
            tripDetailsView.heightAnchor.constraint(equalToConstant: 200),
            
            modeOfTransportLabel.topAnchor.constraint(equalTo: tripDetailsView.topAnchor, constant: 16),
            modeOfTransportLabel.leadingAnchor.constraint(equalTo: tripDetailsView.leadingAnchor, constant: 16),
            modeOfTransportLabel.trailingAnchor.constraint(equalTo: tripDetailsView.trailingAnchor, constant: -16),
            
            totalDistanceLabel.topAnchor.constraint(equalTo: modeOfTransportLabel.bottomAnchor, constant: 8),
            totalDistanceLabel.leadingAnchor.constraint(equalTo: tripDetailsView.leadingAnchor, constant: 16),
            totalDistanceLabel.trailingAnchor.constraint(equalTo: tripDetailsView.trailingAnchor, constant: -16),
            
            emissionsSavedLabel.topAnchor.constraint(equalTo: totalDistanceLabel.bottomAnchor, constant: 8),
            emissionsSavedLabel.leadingAnchor.constraint(equalTo: tripDetailsView.leadingAnchor, constant: 16),
            emissionsSavedLabel.trailingAnchor.constraint(equalTo: tripDetailsView.trailingAnchor, constant: -16),
            
            xpAwardedLabel.topAnchor.constraint(equalTo: emissionsSavedLabel.bottomAnchor, constant: 8),
            xpAwardedLabel.leadingAnchor.constraint(equalTo: tripDetailsView.leadingAnchor, constant: 16),
            xpAwardedLabel.trailingAnchor.constraint(equalTo: tripDetailsView.trailingAnchor, constant: -16),
            
            submitButton.bottomAnchor.constraint(equalTo: tripDetailsView.bottomAnchor, constant: -16),
            submitButton.leadingAnchor.constraint(equalTo: tripDetailsView.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: tripDetailsView.trailingAnchor, constant: -16),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        self.tripDetailsView = tripDetailsView
        self.submitButton = submitButton
        self.modeOfTransportLabel = modeOfTransportLabel
        self.totalDistanceLabel = totalDistanceLabel
        self.emissionsSavedLabel = emissionsSavedLabel
        self.xpAwardedLabel = xpAwardedLabel
    }
    
    @objc private func submitButtonTapped(_ sender: UIButton) {
        tripDetailsView?.removeFromSuperview()
        submitButton = nil
        modeOfTransportLabel = nil
        totalDistanceLabel = nil
        emissionsSavedLabel = nil
        xpAwardedLabel = nil
    }
    
    @objc private func tripButtonTapped() {
        tripInProgress.toggle()
        
        if tripInProgress {
            tripButton.setTitle("End Trip!", for: .normal)
            tripButton.setTitleColor(.white, for: .normal)
            tripButton.backgroundColor = UIColor(red: 0.79, green: 0.20, blue: 0.20, alpha: 1.00)
            tripCoordinates.removeAll()
            tripSpeeds.removeAll()
            tripTransitStops.removeAll()
            totalDistance = 0.0
        } else {
            tripButton.setTitle("Start Trip!", for: .normal)
            tripButton.setTitleColor(.white, for: .normal)
            tripButton.backgroundColor = UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1.00)
            
            // Remove the overlays from the map
            mapView.removeOverlays(mapView.overlays)
            
            viewModel.addTrip(
                tripSpeeds: tripSpeeds,
                transitStops: tripTransitStops,
                totalDistance: totalDistance,
                completion: { result in
                    switch result {
                    case .success(let trip_results):
                        DispatchQueue.main.async {
                            self.showTripDetails(trip_results: trip_results)
                        }
                    case .failure(let error):
                        print("Error fetching profile: \(error)")
                }
            })
        }
    }
}

extension GGDashboardView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}
