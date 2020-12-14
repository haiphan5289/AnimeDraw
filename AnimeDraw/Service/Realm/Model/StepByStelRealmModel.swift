//
//  StepByStelRealmModel.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import Foundation
import RealmSwift


class StepByStepReaml: Object {
    @objc dynamic var product:Data?

    init(_ model: StepModel) {
        super.init()
        do {
            product = try model.toData()
        } catch let err {
            print("\(err.localizedDescription)")
        }

    }
    required init() {
        super.init()
    }
}
