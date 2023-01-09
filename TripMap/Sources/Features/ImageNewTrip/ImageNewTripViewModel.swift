//
//  ImageNewTripViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit

final class ImageNewTripViewModel {
    
    // MARK: - Private Properties

    private let images: [String] = (1...13).map { String($0) }
    
    private let tripName: String

    // MARK: - Public Properties

    var numberOfImages: Int {
        return images.count
    }

    // MARK: - Public Methods

    init(tripName: String) {
        self.tripName = tripName
    }
    
    func getImage(at index: Int) -> UIImage? {
        return UIImage(named: images[index])
    }
    
    func didSelectImage(at index: Int, completion: @escaping (Trip?) -> Void) {
        createTrip(image: images[index], completion: completion)
    }
    
    // MARK: - Private Methods

    private func createTrip(image: String, completion: @escaping (Trip?) -> Void) {
        let managedContext = DataManager.shared.context

        let trip = Trip(context: managedContext)
        trip.name = tripName
        trip.imageName = image
        trip.finished = false

        do {
            try managedContext.save()
            completion(trip)
        } catch {
            completion(nil)
            print("erro ao salvar")
        }
    }
}
