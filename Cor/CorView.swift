//
//  PopupView.swift
//  Cor
//
//  Created by Corey Roberts on 2/9/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation
import UIKit

/// A banner-esque view that pops up near the lower 
/// end of the device.
public class CorView: UIView {

    required public init() {
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// Cor library default display class
public final class CorEasyView: CorView, Configurable {
    
    
    
    public func configure(withPayload payload: Payload) {
        if let payload = payload as? CorEasyPayload {
            
        }
    }
}
