//
//  UITableView+Ext.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/02.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
