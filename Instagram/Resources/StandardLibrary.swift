//
//  StandardLibrary.swift
//  Instagram
//
//  Created by Hamza on 3/3/22.
//  Copyright © 2022 Hamza. All rights reserved.
//

import Foundation


public enum Result<Success, Failure: Error> {
    case success(Success), failure(Failure)
}
