//
//  Cor.swift
//  Cor
//
//  Created by Corey Roberts on 2/9/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol CorDelegate: class {
    
    func cor(shouldDiscardCorView view: CorView, withPayload payload: Payload) -> Bool
    
    func cor(willShowCorView view: CorView, withPayload payload: Payload)
    func cor(didShowCorView view: CorView, withPayload payload: Payload)
    
    func cor(willDismissCorView view: CorView, withPayload payload: Payload)
    func cor(didDismissCorView view: CorView, withPayload payload: Payload)
}

typealias CorClassRegistryData = (type: CorView.Type, settings: CorViewAnimationSettings)
typealias CorNibRegistryData = (nib: UINib, settings: CorViewAnimationSettings)

/// A class that manages a list of items to display.
/// You should retain an instance of this in order to keep state
/// of the messages you want to display. A singleton is deliberately
/// not provided.
public final class Cor {
    
    private lazy var paused: Bool = false
    
    private var queue: [Payload] = [Payload]()
    
    private lazy var classRegistry: [String : CorClassRegistryData] = [String : CorClassRegistryData]()
    private lazy var nibRegistry: [String : CorNibRegistryData] = [String : CorNibRegistryData]()
    private lazy var presenterMap: NSMapTable<NSString, AnyObject> = NSMapTable<NSString, AnyObject>(keyOptions: [.copyIn], valueOptions: [.weakMemory], capacity: 0)
    
    
    public weak var delegate: CorDelegate?
    
    init() {
        
    }
    
    // MARK: - Public Interface
    public func register(corViewClass classType: CorView.Type, forIdentifier identifier: String, animationSettings settings: CorViewAnimationSettings = CorViewAnimationSettings.defaultSettings) {
        classRegistry[identifier] = (classType, settings)
    }
    
    public func register(corViewNib nib: UINib, forIdentifier identifier: String, animationSettings settings: CorViewAnimationSettings = CorViewAnimationSettings.defaultSettings) {
        nibRegistry[identifier] = (nib, settings)
    }
    
    // Cor holds Presenters as weak memory, so you should hold onto them somewhere
    public func register(corViewPresenter presenter: AnyObject, forIdentifier identifier: String) {
        if presenter is CorViewPresenter {
            presenterMap.setObject(presenter, forKey: identifier as NSString)
        }
    }
    
    // Will continue animating current view if already started
    public func pausePayloadExecution() {
        paused = true
    }
    
    public func continuePayloadExecution() {
        paused = false
        processNext()
    }
    
    public func add(item: Payload) {
        queue.append(item)
    }
    
    // MARK: - Private
    private func processNext() {
        
        if paused == false {
            
            if queue.isEmpty == false {
                queue.removeFirst()
            }
            
            if let next = queue.first {
                
                if let classData = classRegistry[next.identifier] {
                    
                    let view: CorView = classData.type.init()
                    
                    if let delegate = delegate, delegate.cor(shouldDiscardCorView: view, withPayload: next) {
                        processNext()
                        
                    } else {
                        show(corView: view, withPayload: next, animationSettings: classData.settings)
                    }
                    
                } else if let nibData = nibRegistry[next.identifier] {
                    
                    if let view: CorView = nibData.nib.instantiate(withOwner: nil, options: nil).first as? CorView {
                        
                        if let delegate = delegate, delegate.cor(shouldDiscardCorView: view, withPayload: next) {
                            processNext()
                            
                        } else {
                            show(corView: view, withPayload: next, animationSettings: nibData.settings)
                        }
                        
                    } else {
                        assertionFailure("Cor: Failure To Instantiate Nib For Identifier")
                    }
                    
                } else {
                    assertionFailure("Cor: Failure To Register Class Or Nib For Identifier")
                }
            }
        }
    }
    
    private func show(corView view: CorView, withPayload payload: Payload, animationSettings settings: CorViewAnimationSettings) {
        
        delegate?.cor(willShowCorView: view, withPayload: payload)
        
        // TODO: Show the CorView with animation settings
        // Will need to move the below calls into the animation completion most likely
        
        delegate?.cor(didShowCorView: view, withPayload: payload)
        
        delegate?.cor(willDismissCorView: view, withPayload: payload)
        
        // TODO: Dismiss the CorView with animation settings
        // Will need to move the below calls into the animation completion most likely
        
        delegate?.cor(didDismissCorView: view, withPayload: payload)
        processNext()
    }
}
