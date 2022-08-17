import Foundation

class BackgroundThread: NSObject {
    
    private var block: (()->Void)!
    private var thread: Thread!
    
    public var name: String?
    
    @objc internal func runBlock() { block() }
    
    internal func start(_ block: @escaping () -> Void) {
        self.block = block
        
        let threadName = String(describing: self)
            .components(separatedBy: .punctuationCharacters)[1]
        
        thread = Thread { [weak self] in
            while (self != nil && !self!.thread.isCancelled) {
                RunLoop.current.run(
                    mode: RunLoop.Mode.default,
                    before: Date.distantFuture)
            }
            Thread.exit()
        }
        thread.name = "\(threadName)-\(UUID().uuidString)"
        thread.start()
        
        
        self.name = threadName
        
        perform(#selector(runBlock),
                on: thread,
                with: nil,
                waitUntilDone: false,
                modes: [RunLoop.Mode.default.rawValue])
    }
    
    public func stop() {
        thread.cancel()
    }
}
