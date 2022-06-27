import Foundation

struct AnyLocalizedError: LocalizedError {
    
    let errorDescription: String?
    
    let failureReason: String?
    
    let recoverySuggestion: String?
    
    let helpAnchor: String?
    
    init(erasing localizedError: LocalizedError) {
        errorDescription = localizedError.errorDescription
        failureReason = localizedError.failureReason
        recoverySuggestion = localizedError.recoverySuggestion
        helpAnchor = localizedError.helpAnchor
    }
}
