import ARAnalytics
import Intercom

class ARIntercomProvider: ARAnalyticalProvider {

    init(apiKey: String, appID: String) {
        Intercom.setApiKey(apiKey, forAppId: appID)
        super.init()
    }

    override func setUserProperty(property: String!, toValue value: String!) {
        Intercom.updateUserWithAttributes(["custom_attributes" : [property:value]])
    }
}
