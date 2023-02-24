//
//  DataManager.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import CoreData

final class DataManager {
    
    private init() {}
    
    static let shared = DataManager()
    
    typealias Coordinate = (latitude: Double, longitude: Double)
    
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TripMap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    /// Core Data Saving support
    func save() {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Trips
    
    @discardableResult
    func createTrip(name: String, image: String) -> Trip? {
        let managedContext = context

        let trip = Trip(context: managedContext)
        trip.name = name
        trip.imageName = image
        trip.finished = false

        do {
            try managedContext.save()
            return trip
        } catch {
            return nil
        }
    }
    
    func getTrip(objectID: NSManagedObjectID) -> Trip? {
        return try? context.existingObject(with: objectID) as? Trip
    }
    
    func getAllTrips() -> [Trip] {
        let requestTrips: NSFetchRequest<Trip> = Trip.fetchRequest()
        var fetchedTrips: [Trip] = []
        do {
            fetchedTrips = try context.fetch(requestTrips)
        } catch let error {
            print("Error fetching trips \(error)")
        }
        
        return fetchedTrips
    }
    
    func updateTripName(trip: Trip, name: String) {
        trip.name = name
   
        do {
            try context.save()
        } catch(_) {
            
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        context.delete(trip)
        save()
    }
    
    func finishTrip(_ trip: Trip) {
        trip.finished = !trip.finished
        DataManager.shared.save()
    }
    
    // MARK: - Pins
    
    func getPin(objectID: NSManagedObjectID) -> Pin? {
        return try? context.existingObject(with: objectID) as? Pin
    }
    
    @discardableResult
    func createPin(
        name: String,
        description: String?,
        emoji: String,
        trip: Trip?,
        coordinate: Coordinate
    ) -> Pin? {
        let pin = Pin(context: context)
        pin.name = name
        pin.pinDescription = description
        pin.lat = coordinate.latitude
        pin.lng = coordinate.longitude
        pin.icon = emoji
        
        if let trip = trip {
            trip.addToPins(pin)
        }
        
        do {
            try context.save()
            return pin
        } catch {
            return nil
        }
    }
    
    func updatePin(_ pin: Pin, name: String, description: String?, icon: String) {
        pin.name = name
        pin.pinDescription = description
        pin.icon = icon
        save()
    }
    
    func getAllPins(trip: Trip? = nil) -> [Pin] {
        var allPins: [Pin] = []
        
        let request = Pin.fetchRequest()
        if let trip = trip {
            request.predicate = NSPredicate(format: "trip = %@", trip)
        }
        
        do {
            allPins = try context.fetch(request)
        } catch let error {
            print("Error fetching pins \(error)")
        }

        return allPins
    }

    func updatePinStatus(at coordinate: (latitude: Double, longitude: Double)) {
        guard let pin = getPinWith(latitude: coordinate.latitude, longitude: coordinate.longitude) else { return
        }
        
        pin.setValue(!pin.visited, forKey: "visited")
        save()
    }
    
    func deletePin(latitude: Double, longitude: Double) {
        guard let pin = getPinWith(latitude: latitude, longitude: longitude) else { return }
        context.delete(pin)
        DataManager.shared.save()
    }
    
    func getPinWith(latitude: Double, longitude: Double) -> Pin? {
        let fetchRequest = Pin.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lng == %lf", latitude, longitude)
        
        do {
            let fetchResponse = try context.fetch(fetchRequest)
            return fetchResponse.first
        } catch {
            return nil
        }
    }

    
    // MARK: - Notes
    
    @discardableResult
    func createNote(trip: Trip?, title: String?, text: String?) -> Note {
        let note = Note(context: DataManager.shared.context)
        note.title = title
        note.text = text
        trip?.addToNotes(note)
        save()
        return note
    }

    @discardableResult
    func createNote(pin: Pin?, title: String?, text: String?) -> Note {
        let note = Note(context: DataManager.shared.context)
        note.title = title
        note.text = text
        pin?.addToNotes(note)
        save()
        return note
    }
    
    func updateNote(note: Note, title: String?, text: String?) {
        note.title = title
        note.text = text
        save()
    }
    
    func deleteNote(note: Note) {
        context.delete(note)
        save()
    }
    
}
