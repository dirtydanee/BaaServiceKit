// TODO: David Szurma - Write tests
struct ChainpointProofResponse: Decodable {
    
    struct Proof: Decodable {
        
        struct Branch: Decodable {
            
            // TODO: Discuss how to parse ops variable, is it needed at all?
            let label: String
            
            enum CodingKeys: String, CodingKey {
                case label
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
    let anchorsComplete: [String]

    enum CodingKeys: String, CodingKey {
        case hashIdNode
        case proof
        case anchorsComplete
    }
}
