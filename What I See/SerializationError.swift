//
//  SerializationError.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
