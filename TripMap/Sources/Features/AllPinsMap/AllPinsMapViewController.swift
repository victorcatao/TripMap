//
//  AllPinsMapViewController.swift
//  TripMap
//
//  Created by Victor Catão on 09/01/23.
//

import UIKit
import MapKit

final class AllPinsMapViewController: UIViewController {
    
    // MARK: - Private Properties

    private let viewModel: AllPinsMapViewModel
    private var didUpdateLocation = false
    private var didShowAnnotations = false
    private lazy var locationManager = CLLocationManager()
    private lazy var mapView = MKMapView(frame: .zero)
    
    private class MyPointAnnotation: MKPointAnnotation {
        var pinTintColor: UIColor?
    }

    // MARK: - LifeCycle

    init(viewModel: AllPinsMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupLocationManager()
        reloadData()
    }
    
    // MARK: - Private Methods

    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupMapView() {
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
    }
    
    @objc private func didLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let alert = UIAlertController(title: "Novo pin", message: "Qual o nome?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { [weak self] _ in
            guard let textField = alert.textFields!.first else { return }
            self?.viewModel.savePin(
                name: textField.text!,
                latitude: newCoordinates.latitude,
                longitude: newCoordinates.longitude
            )
            self?.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alert.addTextField { textField in
            textField.placeholder = "Ex.: Torre Eiffel"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func reloadData() {
        setupPinMaps()
    }
    
    private func setupPinMaps() {
        mapView.removeAnnotations(mapView.annotations)
        
        for pin in viewModel.pinObjects {
            let annotation = MyPointAnnotation()
            annotation.coordinate = .init(latitude: pin.lat, longitude: pin.lng)
            annotation.title = pin.name
            annotation.subtitle = pin.visited ? "Visitado" : "Não visitado"
            annotation.pinTintColor = pin.visited ? .lightGray : .red
            mapView.addAnnotation(annotation)
        }
        
        if didShowAnnotations == false {
            mapView.showAnnotations(mapView.annotations, animated: true)
            didShowAnnotations = true
        }
    }

}

// MARK: - MKMapViewDelegate

extension AllPinsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !didUpdateLocation, viewModel.pinObjects.isEmpty else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        didUpdateLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation as? MyPointAnnotation != nil else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? MyPointAnnotation {
            annotationView?.markerTintColor = annotation.pinTintColor
        }
        
        annotationView?.canShowCallout = false
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let myAnnotation = view.annotation as? MyPointAnnotation else { return }
        let alert = UIAlertController(title: myAnnotation.title, message: "Selecione uma opção", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Traçar rota", style: .default, handler: { _ in
            guard let coordinate = view.annotation?.coordinate else { return }
            let urlStr = "waze://?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes"
            UIApplication.shared.open(URL(string: urlStr)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Ver nota", style: .default, handler: { [weak self] _ in
            guard let self,
                  let latitude = view.annotation?.coordinate.latitude,
                  let longitude = view.annotation?.coordinate.longitude,
                  let pin = self.viewModel.getPinWith(latitude: latitude, longitude: longitude) else { return }
            
            let viewController = NoteViewController(viewModel: NoteViewModel(pin: pin))
            self.present(UINavigationController(rootViewController: viewController), animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Alterar visitado", style: .default, handler: { _ in
            guard let coordinate = view.annotation?.coordinate else { return }
            self.viewModel.updateStatus(for: coordinate)
            self.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Deletar", style: .destructive, handler: { [weak self] _ in
            guard let self,
            let latitude = view.annotation?.coordinate.latitude,
            let longitude = view.annotation?.coordinate.longitude else { return }
            self.viewModel.deletePin(latitude: latitude, longitude: longitude)
            self.reloadData()
        }))
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        
        self.present(alert, animated: true)
    }
}
