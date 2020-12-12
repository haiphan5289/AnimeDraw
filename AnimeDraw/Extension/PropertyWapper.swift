//
//  PropertyWapper.swift
//  AnimeDraw
//
//  Created by haiphan on 12/12/20.
//
import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
struct Replay<T> {
    private let _event: ReplaySubject<T>
    private let queue: ImmediateSchedulerType
    
    init(bufferSize: Int, queue: ImmediateSchedulerType) {
        self.queue = queue
        self._event = ReplaySubject<T>.create(bufferSize: bufferSize)
    }
    init(queue: ImmediateSchedulerType) {
        self.queue = queue
        self._event = ReplaySubject<T>.create(bufferSize: 1)
    }
    var wrappedValue: T {
        get {
            fatalError("don't implement")
        }
        set {
            _event.onNext(newValue)
        }
    }
    
    var projectedValue: Observable<T> {
        return self._event.asObservable()
    }
}

@propertyWrapper
struct VariableReplay<T> {
    
    private let event: BehaviorRelay<T>
    init(wrappedValue: T) {
        event = BehaviorRelay.init(value: wrappedValue)
    }
    var wrappedValue: T {
        get {
            return event.value
        }
        set {
            return event.accept(newValue)
        }
    }
    
    var projectedValue: Observable<T> {
        return self.event.asObservable()
    }
}
