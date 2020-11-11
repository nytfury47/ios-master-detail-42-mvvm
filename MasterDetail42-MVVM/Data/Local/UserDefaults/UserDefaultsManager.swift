//
//  UserDefaultsManager.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import Foundation

// MARK: - UserDefaultsManager

class UserDefaultsManager {
    
    // MARK: - Constants
    
    private let kDefaults = UserDefaults.standard
    private let kIsListLayout = "IsListLayout"
    private let kLastVisit = "LastVisit"
    
    // MARK: - Variables And Properties
    
    private var _isListLayout: Bool!
    private var _lastVisit: String!
    private var _currentDateTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    static let shared = UserDefaultsManager()
    
    var isListLayout: Bool {
        get { return _isListLayout }
        set {
            _isListLayout = newValue
            kDefaults.set(_isListLayout, forKey: kIsListLayout)
        }
    }
    
    var lastVisit: String {
        get {
            let ret = _lastVisit ?? _currentDateTime
            kDefaults.set(_currentDateTime, forKey: kLastVisit)
            return ret
        }
        set {
            _lastVisit = newValue
            kDefaults.set(_lastVisit, forKey: kLastVisit)
        }
    }
    
    // MARK: - Class methods
    
    private init() {
        loadAll()
    }
    
    private func loadAll() {
        _isListLayout = kDefaults.bool(forKey: kIsListLayout)
        _lastVisit = kDefaults.string(forKey: kLastVisit)
    }
    
    func saveAll() {
        kDefaults.set(_isListLayout, forKey: kIsListLayout)
        kDefaults.set(_lastVisit, forKey: kLastVisit)
    }
    
    func resetAll() {
        kDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        kDefaults.synchronize()
        loadAll()
    }
    
}
