//
//  StepByStelRealmModel.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import Foundation
import RealmSwift


class StepByStepReaml: Object {
    @objc dynamic var product: Data?
    @objc dynamic var isStep: Bool = false

    init(model: StepModel, isStep: Bool) {
        super.init()
        do {
            product = try model.toData()
            self.isStep = isStep
        } catch let err {
            print("\(err.localizedDescription)")
        }

    }
    required init() {
        super.init()
    }
}
