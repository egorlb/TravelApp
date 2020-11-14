import Foundation

extension Travel {
    func toRealm() -> RLMTravel {
        let rlmTravel = RLMTravel()
        rlmTravel.name = self.name
        rlmTravel.desc = self.description
        rlmTravel.id = self.id
        rlmTravel.userId = self.userId
        for stop in self.stops {
            let rlmStop = RLMStop()
            rlmStop.id = stop.id
            rlmStop.travelId = stop.travelId
            rlmStop.name = stop.name
            rlmStop.spentMoney = stop.spentMoney
            rlmStop.rate = stop.rate
            rlmStop.latitude = Double(stop.location.x)
            rlmStop.longitude = Double(stop.location.y)
            rlmStop.desc = stop.description
            rlmStop.transport = stop.transport
            rlmStop.currency = stop.currency
            rlmTravel.stops.append(rlmStop)
        }
        return rlmTravel
    }
}
