import XCTest
@testable import BaaServiceKit

class ConfigTests: XCTestCase {
    
    func testConfigModel() throws {
        let file = Bundle(for: type(of: self)).url(forResource: "ConfigResponse", withExtension: "json")!
        
        let data = try Data(contentsOf: file)
        let configResponse = try ChainpointConfigResponse.jsonDecoder.decode(ChainpointConfigResponse.self, from: data)
        
        XCTAssertEqual(configResponse.version, "1.5.1")
        XCTAssertEqual(configResponse.proofExpireMinutes, 1440)
        XCTAssertEqual(configResponse.getProofsMaxRest, 250)
        XCTAssertEqual(configResponse.postHashesMax, 1000)
        XCTAssertEqual(configResponse.postVerifyProofsMax, 1000)
        XCTAssertEqual(configResponse.time, "2018-07-19T20:07:17.101Z")
        XCTAssertEqual(configResponse.calendar.height, 1772299)
        XCTAssertEqual(configResponse.calendar.auditResponse, "1532028600104:8ce99803cee84fc452725b2c0496b750d6bba87d86d308696d6cf326b1b18aca")
        
        let configModel = Node.Configuration(chainpointConfigResponse: configResponse)
        XCTAssertEqual(configModel.version, configResponse.version)
        XCTAssertEqual(configModel.proofExpiration, TimeInterval(configResponse.proofExpireMinutes))
        XCTAssertEqual(configModel.maxProofRetrieval, configResponse.getProofsMaxRest)
        XCTAssertEqual(configModel.maxHashPostal, configResponse.postHashesMax)
        XCTAssertEqual(configModel.maxVerifyProofsPostal, configResponse.postVerifyProofsMax)
        XCTAssertEqual(configModel.systemTime, configResponse.time)
        XCTAssertEqual(configModel.calendar.height, configResponse.calendar.height)
        XCTAssertEqual(configModel.calendar.auditResponse, configResponse.calendar.auditResponse)
    }
}
