//
//  Type.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/27/26.
//

import Foundation

struct Result {
    // init
    let code: String
    let msg: String
    
    init (code: String, msg: String = "") {
        self.code = code
        self.msg = msg
    }
    
    var isSuccess: Bool {
        return code == "0000"
    }
}
