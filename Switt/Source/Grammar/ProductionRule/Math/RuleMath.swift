class RuleMath {
    static func isEmpty(productionRule: ProductionRule) -> Bool {
        switch productionRule {
        case .Empty:
            return true
        default:
            return false
        }
    }
    
    static func sequence(productionRule: ProductionRule) -> [ProductionRule]? {
        switch productionRule {
        case .Sequence(let rules):
            return rules
        default:
            return nil
        }
    }
    
    static func convertToSequence(productionRule: ProductionRule) -> [ProductionRule] {
        switch productionRule {
        case .Sequence(let rules):
            return rules
        default:
            return [productionRule]
        }
    }
    
    static func alternatives(productionRule: ProductionRule) -> [ProductionRule]? {
        switch productionRule {
        case .Alternatives(let rules):
            return rules
        default:
            return nil
        }
    }
    
    static func convertToAlternatives(productionRule: ProductionRule) -> [ProductionRule] {
        switch productionRule {
        case .Alternatives(let rules):
            return rules
        default:
            return [productionRule]
        }
    }
}