//
//  OCKInsightItem.swift
//  ZombieKit
//
//  Created by Michael Henry on 10/5/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import CareKit

extension OCKInsightItem {
    
    static func emptyInsightsMessage() -> OCKInsightItem {
        let text = "You have not entered any data, or reports are in process. (Or you're a zombie?)"
        
        return OCKMessageItem(title: "No Insights", text: text, tintColor: UIColor.darkOrange(), messageType: .tip)
    }
    
}
