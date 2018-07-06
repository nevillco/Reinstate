//
//  Reinstate+Logging.swift
//  Nimble
//
//  Created by Connor Neville on 7/6/18.
//

public class Reinstate {

    /// Whether logging is enabled for Reinstate operations. Defaults to `true`.
    public static var loggingEnabled = true

    static func log(_ text: String) {
        guard loggingEnabled else {
            return
        }
        print(text)
    }

}
