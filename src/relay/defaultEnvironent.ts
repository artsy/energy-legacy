import { Environment, RecordSource, Store } from "relay-runtime"
import {
  cacheMiddleware,
  errorMiddleware,
  loggerMiddleware,
  perfMiddleware,
  RelayNetworkLayer,
} from "react-relay-network-modern/node8"
import { metaphysicsUrlMiddleware } from "./middlewares/metaphysicsUrlMiddleware"
import { authMiddleware } from "./middlewares/authMiddleware"

const network = new RelayNetworkLayer(
  [
    // Default to size 100 and ttl 900000 (15 minutes)
    cacheMiddleware({
      size: 100, // max 100 requests
      ttl: 900000, // 15 minutes
    }),
    metaphysicsUrlMiddleware(),
    __DEV__ ? loggerMiddleware() : null,
    __DEV__ ? errorMiddleware() : null,
    __DEV__ ? perfMiddleware() : null,
    authMiddleware(),
  ],
  {
    // `noThrow` is currently marked as "experimental" and may be deprecated in the future.
    // See: https://github.com/relay-tools/react-relay-network-modern#advanced-options-2nd-argument-after-middlewares
    noThrow: true,
  }
) // as second arg you may pass advanced options for RRNL

export const defaultEnvironment = new Environment({
  network: network,
  store: new Store(new RecordSource()),
})
