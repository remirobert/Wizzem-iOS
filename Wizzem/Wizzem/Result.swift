//
//  Result.swift
//  Wizzem
//
//  Created by Remi Robert on 09/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

enum Result {
    case 👍
    case 👎(statusCode: Int?, error: NSError?)
}
