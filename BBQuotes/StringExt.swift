//
//  StringExt.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 31/03/26.
//

extension String {
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.removeSpaces().lowercased()
    }
}
