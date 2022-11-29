//
//  Date+Ext.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import Foundation

extension Date {
    func toYearMonthDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        
        return dateFormatter.string(from: self)
    }
}
