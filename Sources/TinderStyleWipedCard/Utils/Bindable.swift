//
//  Bindable.swift
//  
//
//  Created by ChungHan Hsin on 2021/6/14.
//

import Foundation

class Bindable<T: Equatable> {
    var value: T? {
        willSet {
            if value == newValue {
                
            } else {
                willChangeObserver?(value)
            }
        }
        
        didSet {
            didChangeObserver?(value)
        }
    }
    
    private var willNotChangeObserver: ((_ value: T?) -> Void)?
    private var didChangeObserver: ((_ value: T?) -> Void)?
    private var willChangeObserver: ((_ value: T?) -> Void)?
    
    init(value: T?) {
        self.value = value
    }
    
    func bindWillNotChangeValue(observer: @escaping (_ value: T?) -> Void) {
        self.willNotChangeObserver = observer
    }
    
    func bindDidChangeValue(observer: @escaping (_ value: T?) -> Void) {
        self.didChangeObserver = observer
    }
    
    func bindWillChangeValue(observer: @escaping (_ value: T?) -> Void) {
        self.willChangeObserver = observer
    }
}
