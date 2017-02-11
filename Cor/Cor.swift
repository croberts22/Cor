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
    
    func cor(shouldDiscardCorView view: CorView, withPayload payload: CorPayload) -> Bool
    
    func cor(willShowCorView view: CorView, withCorPayload payload: CorPayload)
    func cor(didShowCorView view: CorView, withCorPayload payload: CorPayload)
    
    func cor(willDismissCorView view: CorView, withCorPayload payload: CorPayload)
    func cor(didDismissCorView view: CorView, withCorPayload payload: CorPayload)
    
    func cor(willProcessNextCorPayload payload: CorPayload)
    func cor(didDiscardCorPayload payload: CorPayload)
}

typealias CorClassRegistryData = (type: CorView.Type, settings: CorViewAnimationSettings)
typealias CorNibRegistryData = (nib: UINib, settings: CorViewAnimationSettings)

/// A class that manages a list of items to display.
/// You should retain an instance of this in order to keep state
/// of the messages you want to display. A singleton is deliberately
/// not provided.
public final class Cor {
    
    private lazy var processing: Bool = false
    
    private var queue: [CorPayload] = [CorPayload]()
    
    private lazy var classRegistry: [String : CorClassRegistryData] = [String : CorClassRegistryData]()
    private lazy var nibRegistry: [String : CorNibRegistryData] = [String : CorNibRegistryData]()
    private lazy var presenterMap: NSMapTable<NSString, AnyObject> = NSMapTable<NSString, AnyObject>(keyOptions: [.copyIn], valueOptions: [.weakMemory], capacity: 0)
    
    public var paused: Bool = false {
        didSet {
            if paused == false {
                processNext()
            }
        }
    }
    
    public weak var delegate: CorDelegate?
    
    init() {
        
    }
    
    // MARK: - Public Interface
    public func register(corViewClass classType: CorView.Type, forCorIdentifier identifier: String, animationSettings settings: CorViewAnimationSettings = CorViewAnimationSettings.defaultSettings) {
        classRegistry[identifier] = (classType, settings)
    }
    
    public func register(corViewNib nib: UINib, forCorIdentifier identifier: String, animationSettings settings: CorViewAnimationSettings = CorViewAnimationSettings.defaultSettings) {
        nibRegistry[identifier] = (nib, settings)
    }
    
    // Cor holds Presenters as weak memory, so you should hold onto them somewhere
    public func register(corViewPresenter presenter: AnyObject, forIdentifier identifier: String) {
        if presenter is CorViewPresenter {
            presenterMap.setObject(presenter, forKey: identifier as NSString)
        }
    }
    
    public func add(item: CorPayload) {
        queue.append(item)
        
        if paused == false && processing == false {
            processNext()
        }
    }
    
    // MARK: - Private
    private func processNext() {
        
        if paused == false {
            
            if let next = queue.first {
                
                processing = true
                
                delegate?.cor(willProcessNextCorPayload: next)
                
                if let classData = classRegistry[next.corIdentifier] {
                    
                    let view: CorView = classData.type.init()
                    
                    if let delegate = delegate, delegate.cor(shouldDiscardCorView: view, withPayload: next) {
                        discard()
                        processNext()
                        
                    } else {
                        show(corView: view, withCorPayload: next, animationSettings: classData.settings)
                    }
                    
                } else if let nibData = nibRegistry[next.corIdentifier] {
                    
                    if let view: CorView = nibData.nib.instantiate(withOwner: nil, options: nil).first as? CorView {
                        
                        if let delegate = delegate, delegate.cor(shouldDiscardCorView: view, withPayload: next) {
                            discard()
                            processNext()
                            
                        } else {
                            show(corView: view, withCorPayload: next, animationSettings: nibData.settings)
                        }
                        
                    } else {
                        assertionFailure("Cor: Failure To Instantiate Nib For Identifier")
                    }
                    
                } else {
                    assertionFailure("Cor: Failure To Register Class Or Nib For Identifier")
                }
            
            } else {
                processing = false
            }
            
        } else {
            processing = false
        }
    }
    
    private func discard() {
        
        if queue.isEmpty == false {
            if let delegate = delegate {
                delegate.cor(didDiscardCorPayload: queue.removeFirst())
                
            } else {
                queue.removeFirst()
            }
        }
    }
    
    private func show(corView view: CorView, withCorPayload payload: CorPayload, animationSettings settings: CorViewAnimationSettings) {
        
        if let view = view as? Configurable {
            view.configure(withPayload: payload)
        }
        
        delegate?.cor(willShowCorView: view, withCorPayload: payload)
        
        // TODO: Show the CorView with animation settings
        // Will need to move the below calls into the animation completion most likely
        
        delegate?.cor(didShowCorView: view, withCorPayload: payload)
        
        delegate?.cor(willDismissCorView: view, withCorPayload: payload)
        
        // TODO: Dismiss the CorView with animation settings
        // Will need to move the below calls into the animation completion most likely
        
        delegate?.cor(didDismissCorView: view, withCorPayload: payload)
        discard()
        processNext()
    }
}
