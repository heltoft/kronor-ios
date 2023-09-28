//
//  EmbeddedPaymentStatechart.swift
//  kronor-ios
//
//  Created by lorenzo on 2023-01-04.
//

import Foundation
import StateMachine
import KronorApi

final class EmbeddedPaymentStatechart : StateMachineBuilder {
    
    enum State : Equatable  {
        case initializing
        case creatingPaymentRequest
        case waitingForPaymentRequest
        case paymentRequestInitialized
        case waitingForPayment
        case paymentRejected
        case paymentCompleted
        case errored (error: KronorApi.KronorError)
    }
    
    enum Event : Equatable  {
        case initialize
        case paymentRequestCreated (waitToken: String)
        case paymentRequestWillBeCreatedElsewhere
        case paymentRequestInitialized
        case paymentAuthorized
        case paymentRejected
        case cancel
        case retry
        case cancelFlow
        case error (error: KronorApi.KronorError)
        case waitForCancel
    }
    
    enum SideEffect {
        case createPaymentRequest
        case openEmbeddedSite
        case subscribeToPaymentStatus (waitToken: String)
        case notifyPaymentSuccess
        case notifyPaymentFailure
        case resetState
        case cancelAndNotifyFailure
        case cancelAfterDeadline
    }
    
    typealias EmbeddedPaymentStateMachine = StateMachine<State, Event, SideEffect>
    

    static func makeStateMachine() -> EmbeddedPaymentStateMachine {
        makeStateMachineWithInitialState(initial: .initializing)
    }
    
    static func makeStateMachineWithInitialState(initial: State) -> EmbeddedPaymentStateMachine {
        EmbeddedPaymentStateMachine {
            initialState(initial)
            
            state(.initializing) {
                on(.initialize) {
                    transition(to: .creatingPaymentRequest, emit: .createPaymentRequest)
                }

                on(.paymentRequestInitialized) {
                    return transition(to: .paymentRequestInitialized, emit: .openEmbeddedSite)
                }

                // In case the session was completed while trying to create a new one
                on(.paymentAuthorized) {
                    transition(to: .paymentCompleted, emit: .notifyPaymentSuccess)
                }

                // If a previous payment in the session was rejected, we just try to create a new payment request
                on(.paymentRejected) {
                    transition(to: .paymentRequestInitialized, emit: .openEmbeddedSite)
                }
            }
      
            state(.creatingPaymentRequest) {
                
                on (.paymentRequestCreated) {
                    guard case let .paymentRequestCreated(waitToken) = $1 else { return dontTransition() }
                    
                    return transition(to: .waitingForPaymentRequest,
                                      emit: .subscribeToPaymentStatus(waitToken: waitToken))
                }
                
                on (.paymentRequestWillBeCreatedElsewhere) {
                    return transition(to: .paymentRequestInitialized, emit: .openEmbeddedSite)
                }

                on (.error) {
                    transition(to: .errored(error: $1.associatedValue as! KronorApi.KronorError))
                }
            }

            state(.waitingForPaymentRequest) {

                on(.paymentRequestInitialized) {
                    return transition(to: .paymentRequestInitialized, emit: .openEmbeddedSite)
                }

                on (.error) {
                    transition(to: .errored(error: $1.associatedValue as! KronorApi.KronorError))
                }

                on(.cancel) {
                    transition(to: .paymentRejected, emit: .cancelAndNotifyFailure)
                }
                // In case the session was completed while trying to cancel
                on(.paymentAuthorized) {
                    transition(to: .paymentCompleted, emit: .notifyPaymentSuccess)
                }
                on(.paymentRejected) {
                    transition(to: .paymentRejected)
                }
            }

            state(.paymentRequestInitialized) {
                on(.paymentAuthorized) {
                    transition(to: .paymentCompleted, emit: .notifyPaymentSuccess)
                }
                on(.paymentRejected) {
                    transition(to: .paymentRejected)
                }
                on (.error) {
                    transition(to: .errored(error: $1.associatedValue as! KronorApi.KronorError))
                }
                on(.cancel) {
                    transition(to: .paymentRejected, emit: .cancelAndNotifyFailure)
                }
                on(.waitForCancel) {
                    transition(to: .waitingForPaymentRequest, emit: .cancelAfterDeadline)
                }
            }

            state(.waitingForPayment) {
                on(.paymentAuthorized) {
                    transition(to: .paymentCompleted, emit: .notifyPaymentSuccess)
                }
                on(.paymentRejected) {
                    transition(to: .paymentRejected)
                }
                on (.error) {
                    transition(to: .errored(error: $1.associatedValue as! KronorApi.KronorError))
                }
                on(.cancel) {
                    transition(to: .paymentRejected, emit: .cancelAndNotifyFailure)
                }
                on(.waitForCancel) {
                    transition(to: .waitingForPaymentRequest, emit: .cancelAfterDeadline)
                }
            }

            state(.paymentRejected) {
                on(.cancelFlow) {
                    dontTransition(emit: .notifyPaymentFailure)
                }
                on(.retry) {
                    transition(to: .initializing, emit: .resetState)
                }
            }
        }
    }
}

extension EmbeddedPaymentStatechart.State: StateMachineHashable  {
    enum HashableIdentifier {
        case initializing
        case creatingPaymentRequest
        case waitingForPaymentRequest
        case paymentRequestInitialized
        case waitingForPayment
        case paymentRejected
        case paymentCompleted
        case errored
    }

    var hashableIdentifier: HashableIdentifier {
        switch self {
        case .initializing:
            return .initializing
        case .creatingPaymentRequest:
            return .creatingPaymentRequest
        case .waitingForPaymentRequest:
            return .waitingForPaymentRequest
        case .paymentRequestInitialized:
            return .paymentRequestInitialized
        case .waitingForPayment:
            return .waitingForPayment
        case .paymentRejected:
            return .paymentRejected
        case .paymentCompleted:
            return .paymentCompleted
        case .errored:
            return .errored
        }
    }

    var associatedValue: Any {
        switch self {
        case let .errored(value):
            return value
        default:
            return ()
        }
    }
}

extension EmbeddedPaymentStatechart.Event: StateMachineHashable  {
    enum HashableIdentifier {
        case initialize
        case paymentRequestCreated
        case paymentRequestWillBeCreatedElsewhere
        case paymentRequestInitialized
        case paymentAuthorized
        case paymentRejected
        case error
        case cancel
        case cancelFlow
        case retry
        case waitForCancel
    }

    var hashableIdentifier: HashableIdentifier {
        switch self {
        case .initialize:
            return .initialize
        case .paymentRequestCreated:
            return .paymentRequestCreated
        case .paymentRequestWillBeCreatedElsewhere:
            return .paymentRequestWillBeCreatedElsewhere
        case .paymentRequestInitialized:
            return .paymentRequestInitialized
        case .paymentAuthorized:
            return .paymentAuthorized
        case .paymentRejected:
            return .paymentRejected
        case .error:
            return .error
        case .cancel:
            return .cancel
        case .cancelFlow:
            return .cancelFlow
        case .retry:
            return .retry
        case .waitForCancel:
            return .waitForCancel
        }
    }

    var associatedValue: Any {
        switch self {
        case let .error(value):
            return value
        default:
            return ()
        }
    }
}
