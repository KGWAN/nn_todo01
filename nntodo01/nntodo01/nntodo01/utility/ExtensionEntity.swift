//
//  ExtensionEntity.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/20/26.
//

import Foundation

extension Work {
    var listTypePlan: TypePlan {
        get { TypePlan(rawValue: self.planType) }
        set { self.planType = newValue.rawValue }
    }
}
