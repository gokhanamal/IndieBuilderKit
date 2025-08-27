//
//  File.swift
//  IndieBuilderKit
//
//  Created by Erkam Kucet on 27.08.2025.
//

import Foundation

public extension Swift.Optional where Wrapped == Bool {
    
    var orTrue: Bool {
        guard let self = self else {
            return true
        }
        return self
    }
    
    var orFalse: Bool {
        guard let self = self else {
            return false
        }
        return self
    }
    
    func isEqualTo(_ bool: Bool?) -> Bool {
        guard let self = self,
              let boolValue = bool else {
            return false
        }
        return self == boolValue
    }
}

public extension Swift.Optional where Wrapped: EmptyValueRepresentable {
    
    var orEmpty: Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.emptyValue
        }
    }
}

public extension Swift.Optional where Wrapped == Int {
    
    func or(_ defaultValue: Int) -> Int {
        guard let self = self else {
            return defaultValue
        }
        return self
    }
    
    var isNilOrZero: Bool {
        guard let self = self else {
            return true
        }
        
        return self == 0
    }
}

public extension Swift.Optional where Wrapped == Decimal {
    
    func or(_ defaultValue: Decimal) -> Decimal {
        guard let self = self else {
            return defaultValue
        }
        return self
    }
    
    var isNilOrZero: Bool {
        guard let self = self else {
            return true
        }
        
        return self == 0
    }
}

public extension Swift.Optional {
    
    var notNil: Bool {
        return self != nil
    }
    
    var isNil: Bool {
        return self == nil
    }
}

public extension Swift.Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        guard let self = self else {
            return true
        }
        return self.isEmpty
    }
}

public extension Swift.Optional where Wrapped == String {
    
    func or(_ defaultValue: String) -> String {
        guard let self = self, !self.isEmpty else {
            return defaultValue
        }
        return self
    }
    
    func isEqualTo(_ string: String?) -> Bool {
        guard let self = self, let string = string else {
            return false
        }
        return self == string
    }
}

public extension Swift.Optional where Wrapped: ZeroValueRepresentable {
    
    var orZero: Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.zeroValue
        }
    }
}

public extension Swift.Optional where Wrapped == String {
    
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    
    var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

extension Optional where Wrapped == String {
    var boolValue: Bool? {
        guard let nonOptionalSelf = self else {
            return nil
        }
        
        switch nonOptionalSelf.lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            return nil
        }
    }
}
