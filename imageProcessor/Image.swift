//
//  Image.swift
//  imageProcessor
//
//  Created by Lauren Shultz on 4/20/18.
//  Copyright © 2018 Lauren Shultz. All rights reserved.
//

import Foundation
import UIKit

class Image
{
    var picture: UIImage!
    var message: String!
    init(pictureIn: UIImage, messageIn: String)
    {
        picture = pictureIn
        message = messageIn
    }
}
