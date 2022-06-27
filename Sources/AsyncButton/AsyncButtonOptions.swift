//
//  File.swift
//  
//
//  Created by Lorenzo Fiamingo on 27/06/22.
//

import Foundation

public struct AsyncButtonOptions: OptionSet {
    
    public let rawValue: Int
    
    public static let disableButtonOnLoading       = AsyncButtonOptions(rawValue: 1 << 0)
    public static let showProgressViewOnLoading    = AsyncButtonOptions(rawValue: 1 << 1)
    public static let showAlertOnError             = AsyncButtonOptions(rawValue: 1 << 2)
    public static let disallowParallelOperations   = AsyncButtonOptions(rawValue: 1 << 3)
    public static let enableNotificationFeedback   = AsyncButtonOptions(rawValue: 1 << 4)
    public static let enableTintFeedback           = AsyncButtonOptions(rawValue: 1 << 5)
    
    public static let all: AsyncButtonOptions = [.disableButtonOnLoading, .showProgressViewOnLoading, .showAlertOnError, .disallowParallelOperations, .enableNotificationFeedback, .enableTintFeedback]
    public static let automatic: AsyncButtonOptions = [.disableButtonOnLoading, .showProgressViewOnLoading, .showAlertOnError, .disallowParallelOperations, .enableNotificationFeedback]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
