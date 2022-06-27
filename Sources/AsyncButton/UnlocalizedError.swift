import Foundation

struct UnlocalizedError: LocalizedError {
    
    let errorDescription: String?
    
    init(error: Error) {
        self.errorDescription = error.localizedDescription
    }
}
