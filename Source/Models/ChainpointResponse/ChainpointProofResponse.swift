// TODO: David Szurma - Write tests
struct ChainpointProofResponse: Codable {
    
    struct Proof: Codable {
        
        struct Branch: Codable {
            
            let label: String
            let ops: [ Any ]
            
            // swiftlint:disable nesting
            enum CodingKeys: String, CodingKey {
                case label
                case ops
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                label = try container.decode(String.self, forKey: .label)
                ops = try container.decode([Any].self, forKey: CodingKeys.ops)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(label, forKey: .label)
                try container.encode(ops, forKey: .ops)
            }
        }
        
        let context: URL
        let type: String
        let hash: String
        let hashIdNode: String
        let hashSubmittedNodeAt: String // Date
        let hashIdCore: String
        let hashSubmittedCoreAt: String // Date
        let branches: [ChainpointProofResponse.Proof.Branch]
        
        enum CodingKeys: String, CodingKey {
            case context = "@context"
            case type
            case hash
            case hashIdNode
            case hashSubmittedNodeAt
            case hashIdCore
            case hashSubmittedCoreAt
            case branches
        }
    }
    
    let hashIdNode: String
    let proof: ChainpointProofResponse.Proof?
    let anchorsComplete: [String]?

    enum CodingKeys: String, CodingKey {
        case hashIdNode
        case proof
        case anchorsComplete
    }
    
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dataDecodingStrategy = .deferredToData
        return decoder
    }
}

public struct JSONCodingKeys: CodingKey {
    public var stringValue: String
    
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public var intValue: Int?
    
    public init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}
