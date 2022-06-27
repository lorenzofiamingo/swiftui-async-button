public enum AsyncButtonOperation {
    
    case loading(Task<Void, Error>)
    case completed(Task<Void, Error>, Result<Void, Error>)
    
    var task: Task<Void, Error> {
        switch self {
        case .loading(let task):
            return task
        case .completed(let task, _):
            return task
        }
    }
}

extension AsyncButtonOperation: Equatable {
    
    public static func == (lhs: AsyncButtonOperation, rhs: AsyncButtonOperation) -> Bool {
        if case .loading(let lhsTask) = lhs, case .loading(let rhsTask) = rhs  {
            return lhsTask == rhsTask
        } else if case .completed(let lhsTask, _) = lhs, case .completed(let rhsTask, _) = rhs  {
            return lhsTask == rhsTask
        } else {
            return false
        }
    }
}
