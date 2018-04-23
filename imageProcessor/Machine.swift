//
//  Machine.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/20/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import Foundation

class Machine
{
    var machineId: String!
    var images: [Image]!
    init(machineIdIn: String)
    {
        machineId = machineIdIn
    }
}
