import UIKit

extension RLMTravel {
    func toObject() -> Travel {
        let travel = Travel(userId: self.userId, id: self.id, name: self.name, description: self.desc)
        for rlmStop in self.stops {
            let stop = Stop(id: rlmStop.id, travelId: rlmStop.travelId)
            stop.name = rlmStop.name
            stop.spentMoney = rlmStop.spentMoney
            stop.rate = rlmStop.rate
            stop.location = CGPoint(x: rlmStop.latitude, y: rlmStop.longitude)
            stop.description = rlmStop.desc
            stop.transport = rlmStop.transport
            stop.currency = rlmStop.currency
            travel.stops.append(stop)
        }
        return travel
    }
}
