//
//  ViewController.swift
//  TripMap
//
//  Created by Victor Catão on 16/05/22.
//

import UIKit
import MapKit
import Lottie

final class MapViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let viewModel: MapViewModel
    private var didUpdateLocation = false
    private var didShowAnnotations = false
    private lazy var locationManager = CLLocationManager()
    private lazy var mapView = MKMapView(frame: .zero)
    private lazy var fakeLoadingView = UIView()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        button.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageEdgeInsets = .init(top: 18, left: 18, bottom: 18, right: 18)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 30
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = .init(top: 10, left: 8, bottom: 15, right: 15)
        
        return button
    }()
    
    
    // MARK: - LifeCycle
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLocationManager()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showTutorialIfNeeded()
    }
    
    // MARK: - Private Methods
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupView() {
        // Back Button
        self.navigationItem.setHidesBackButton(true, animated:false)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        view.backgroundColor = .white
        view.layer.cornerRadius = 22

        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        
        if let imgBackArrow = UIImage(systemName: "arrowshape.backward.fill") {
            imageView.image = imgBackArrow
        }
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        setUpMapView()
        setUpFilterView()
        setUpLocationView()
        setUpFakeLoadingView()
    }
    
    private func setUpMapView() {
        view.addSubview(mapView)
        
        mapView
            .pin(.top, to: view.topAnchor)
            .pin(.leading, to: view.leadingAnchor)
            .pin(.trailing, to: view.trailingAnchor)
            .pin(.bottom, to: view.bottomAnchor)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        longPress.minimumPressDuration = 1.0
        
        mapView.addGestureRecognizer(longPress)
        
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PinAnnotationView")
    }
    
    private func setUpFilterView() {
        view.addSubview(filterButton)
        filterButton
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            .pin(.height, relation: .equalToConstant, constant: 60)
            .pin(.width, relation: .equalToConstant, constant: 60)
    }
    
    
    private func setUpLocationView() {
        view.addSubview(locationButton)
        locationButton
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: filterButton.topAnchor, constant: -8)
            .pin(.height, relation: .equalToConstant, constant: 60)
            .pin(.width, relation: .equalToConstant, constant: 60)
    }
    
    private func setUpFakeLoadingView() {
        view.addSubview(fakeLoadingView)
        fakeLoadingView.backgroundColor = .white
        
        let lottieAnimationView = LottieAnimationView()
        let animation = LottieAnimation.named("loading-pins")
        lottieAnimationView.animation = animation
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
        
        fakeLoadingView.addSubview(lottieAnimationView)
        
        lottieAnimationView
            .pin(.leading, to: fakeLoadingView.leadingAnchor, constant: 16)
            .pin(.centerY, to: fakeLoadingView.centerYAnchor)
            .pin(.trailing, to: fakeLoadingView.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 200)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.fakeLoadingView.alpha = 0
            } completion: { complete in
                if complete { self?.fakeLoadingView.removeFromSuperview() }
            }
        }
        
        fakeLoadingView
            .pin(.leading, to: view.leadingAnchor)
            .pin(.top, to: view.topAnchor)
            .pin(.trailing, to: view.trailingAnchor)
            .pin(.bottom, to: view.bottomAnchor)
    }
    
    private func reloadData() {
        setupPinMaps()
    }
    
    private func setupPinMaps() {
        mapView.removeAnnotations(mapView.annotations)
        
        for pin in viewModel.pinObjects {
            let annotation = PinAnnotationView.Annotation(emoji: pin.icon ?? "", name: pin.name ?? "", pinDescription: pin.pinDescription, visited: pin.visited)
            annotation.coordinate = .init(latitude: pin.lat, longitude: pin.lng)
            annotation.title = pin.name
            mapView.addAnnotation(annotation)
        }
        
        if didShowAnnotations == false {
            mapView.showAnnotations(mapView.annotations, animated: true)
            didShowAnnotations = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }

        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let newPinViewModel = viewModel.createNewPinViewModel(coordinates: newCoordinates)
        let newPinViewController = NewPinViewController(viewModel: newPinViewModel)
        newPinViewController.delegate = self
        present(UINavigationController(rootViewController: newPinViewController), animated: true)
    }
    
    @objc
    func didTapFilterButton() {
        let mapFilterViewController = MapFilterViewController(viewModel: viewModel.createMapFilterViewModel())
        mapFilterViewController.delegate = self
        present(UINavigationController(rootViewController: mapFilterViewController), animated: true)
    }
    
    @objc
    func didTapLocationButton() {
        guard mapView.userLocation.coordinate.longitude != 0 else { return }
        
        let userLatitude = mapView.userLocation.coordinate.latitude
        let userLongitude = mapView.userLocation.coordinate.longitude
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let center = CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }
    
    @objc
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !didUpdateLocation, viewModel.pinObjects.isEmpty else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        didUpdateLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pinAnnotation = annotation as? PinAnnotationView.Annotation else { return nil }
        
        let annotationView = (mapView.dequeueReusableAnnotationView(withIdentifier: "PinAnnotationView") as? PinAnnotationView)
            ?? PinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        
        annotationView.setUpWith(annotation: pinAnnotation)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        guard let myAnnotation = view.annotation as? PinAnnotationView.Annotation else { return }
        let alert = UIAlertController(title: myAnnotation.name, message: myAnnotation.pinDescription, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "map_route".localized, style: .default, handler: { _ in
            guard let coordinate = view.annotation?.coordinate else { return }
            self.openRouteOptions(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }))
        
        alert.addAction(UIAlertAction(title: "see_note".localized, style: .default, handler: { [weak self] _ in
            guard let self,
                  let latitude = view.annotation?.coordinate.latitude,
                  let longitude = view.annotation?.coordinate.longitude,
                  let pin = self.viewModel.getPinWith(latitude: latitude, longitude: longitude) else { return }
            
            let viewController = NotesListViewController(viewModel: NotesListViewModel(pin: pin))
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "change_visited".localized, style: .default, handler: { _ in
            guard let coordinate = view.annotation?.coordinate else { return }
            self.viewModel.updateStatus(for: coordinate)
            self.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "edit_pin", style: .default, handler: { [weak self] _ in
            guard let self,
                  let latitude = view.annotation?.coordinate.latitude,
                  let longitude = view.annotation?.coordinate.longitude else { return }
            self.editPin(latitude: latitude, longitude: longitude)
        }))
        
        alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { [weak self] _ in
            guard let self,
                  let latitude = view.annotation?.coordinate.latitude,
                  let longitude = view.annotation?.coordinate.longitude else { return }
            self.deletePin(name: myAnnotation.name, latitude: latitude, longitude: longitude)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func deletePin(name: String, latitude: Double, longitude: Double) {
        let alertController = UIAlertController(title: name,
                                                message: "confirmation_delete_pin".localized,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))

        alertController.addAction(
            UIAlertAction.init(title: "yes".localized, style: .default, handler: { _ in
                self.viewModel.deletePin(latitude: latitude, longitude: longitude)
                self.reloadData()
            })
        )

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func editPin(latitude: Double, longitude: Double) {
        let newPinViewModel = viewModel.createEditPinViewModel(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        let newPinViewController = NewPinViewController(viewModel: newPinViewModel)
        newPinViewController.delegate = self
        present(UINavigationController(rootViewController: newPinViewController), animated: true)
    }
    
    private func openRouteOptions(latitude: Double, longitude: Double) {
        let alert = UIAlertController(title: "map_route".localized, message: "select_an_option".localized, preferredStyle: .actionSheet)
        
        if let wazeURL = URL(string: "waze://"), UIApplication.shared.canOpenURL(wazeURL) {
            alert.addAction(UIAlertAction(title: "Waze", style: .default, handler: { _ in
                let urlStr = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                UIApplication.shared.open(URL(string: urlStr)!)
            }))
        }
        
        if let googleMapsURL = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(googleMapsURL) {
            alert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
                let urlStr = "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"
                UIApplication.shared.open(URL(string: urlStr)!)
            }))
        }
        
        if let appleMapsURL = URL(string: "maps://"), UIApplication.shared.canOpenURL(appleMapsURL) {
            alert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
                let urlStr = "maps://?ll=\(latitude),\(longitude)"
                UIApplication.shared.open(URL(string: urlStr)!)
            }))
        }
        
        present(alert, animated: true)
    }
    
    private func showTutorialIfNeeded() {
        guard UserDefaults.standard.bool(forKey: "userDidSeeMapTutorial") == false else { return }

        let tutorialViewcontroller = MapTutorialViewController()
        tutorialViewcontroller.modalPresentationStyle = .overFullScreen
        present(tutorialViewcontroller, animated: true)
    }
    
}

// MARK: - MapFilterViewControllerDelegate

extension MapViewController: MapFilterViewControllerDelegate {
    func didApplyFilter(_ filter: MapFilterViewModel.Filter) {
        viewModel.setFilter(filter)
        reloadData()
    }
}

// MARK: - NewPinViewControllerDelegate

extension MapViewController: NewPinViewControllerDelegate {
    func didCreateNewPin(_ pin: Pin) {
        viewModel.didCreateNewPin(pin)
        reloadData()
    }
}
