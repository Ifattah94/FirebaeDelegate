//
//  FirebaseFirestoreService.swift
//  FirebaeDelegate
//
//  Created by C4Q on 11/20/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FireStoreCollections: String {
    case pins
}


class FirestoreService {
    private init() {}
    
     static let manager = FirestoreService()
    
     private let db = Firestore.firestore()
    
    func createPin(pin: Pin, completion: @escaping (Result<(), Error>) -> ()) {
        let fields = pin.fieldsDict
        
        db.collection(FireStoreCollections.pins.rawValue).addDocument(data: fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func getAllPins(completion: @escaping (Result<[Pin], Error>) -> ()) {
        db.collection(FireStoreCollections.pins.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let pins = snapshot?.documents.compactMap({
                    (snapshot) -> Pin? in
                    let pin = Pin(from: snapshot.data())
                    return pin
                })
                
                completion(.success(pins ?? []))
            }
        }
    }
    
    
    
    
}
