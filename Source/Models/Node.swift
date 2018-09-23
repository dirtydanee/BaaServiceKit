import Foundation

public struct Node: CustomDebugStringReflectable {

    public struct Configuration: CustomDebugStringReflectable {

        public struct Calendar: Decodable, CustomDebugStringReflectable {
            public let height: Int
            public let auditResponse: String
        }

        public let version: String
        public let proofExpiration: TimeInterval
        public let maxProofRetrieval: Int
        public let maxHashPostal: Int
        public let maxVerifyProofsPostal: Int
        public let systemTime: String
        public let calendar: Calendar
    }

    public let publicURL: URL
    public let configuation: Node.Configuration
}

extension Node.Configuration {
    init(chainpointConfigResponse: ChainpointConfigResponse) {
        self.version = chainpointConfigResponse.version
        self.proofExpiration = TimeInterval(chainpointConfigResponse.proofExpireMinutes)
        self.maxProofRetrieval = chainpointConfigResponse.getProofsMaxRest
        self.maxHashPostal = chainpointConfigResponse.postHashesMax
        self.maxVerifyProofsPostal = chainpointConfigResponse.postVerifyProofsMax
        self.systemTime = chainpointConfigResponse.time
        self.calendar = Calendar(height: chainpointConfigResponse.calendar.height,
                                 auditResponse: chainpointConfigResponse.calendar.auditResponse)
    }
}
