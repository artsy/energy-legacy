import React from "react"
import { LoadFailureView } from "./LoadFailureView"

// Taken from https://relay.dev/docs/guided-tour/rendering/error-states/#when-using-uselazyloadquery
interface RetryErrorBoundaryProps {
  failureView?: React.FC<{ error: Error; retry: () => void }>
}
interface RetryErrorBoundaryState {
  error: Error | null
}

export class ErrorBoundary extends React.Component<RetryErrorBoundaryProps, RetryErrorBoundaryState> {
  static getDerivedStateFromError(error: Error | null): RetryErrorBoundaryState {
    return { error }
  }

  state = { error: null }

  _retry = () => {
    this.setState({ error: null })
  }

  render() {
    const { children, failureView } = this.props
    const { error } = this.state

    if (error) {
      if (failureView) {
        return failureView({ error, retry: this._retry })
      }
      return <LoadFailureView error={error} onRetry={this._retry} />
    }

    return children
  }
}
