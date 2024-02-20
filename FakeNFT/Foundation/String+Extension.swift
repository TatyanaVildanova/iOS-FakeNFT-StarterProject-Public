//
//  String+Extension.swift
//  FakeNFT
//
//  Created by Эмилия on 20.02.2024.
//

import Foundation

extension String {
    var encodeURL: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeURL: String {
        return self.removingPercentEncoding!
    }
}
