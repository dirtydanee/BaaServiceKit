import Foundation

public struct Config {
    
    struct Calendar: Decodable {
        let height: Int
        let auditResponse: String
    }
    
    let version: String
    let proofExpireMinutes: Int
    let getProofsMaxRest: Int
    let postHashesMax: Int
    let postVerifyProofsMax: Int
    let time: String
    let calendar: Config.Calendar
    
    init(chainpointConfigResponse: ChainpointConfigResponse) {
        self.version = chainpointConfigResponse.version
        self.proofExpireMinutes = chainpointConfigResponse.proofExpireMinutes
        self.getProofsMaxRest = chainpointConfigResponse.getProofsMaxRest
        self.postHashesMax = chainpointConfigResponse.postHashesMax
        self.postVerifyProofsMax = chainpointConfigResponse.postVerifyProofsMax
        self.time = chainpointConfigResponse.time
        self.calendar = Config.Calendar(height: chainpointConfigResponse.calendar.height,
                                        auditResponse: chainpointConfigResponse.calendar.auditResponse)
    }
}
