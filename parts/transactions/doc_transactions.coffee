if Meteor.isClient
    Template.doc_transactions.onCreated -> 
        Meteor.subscribe('doc_transactions', FlowRouter.getParam('doc_id'))

    Template.doc_transactions.helpers
        transactions: -> 
            Transactions.find { }
    
    Template.transaction.helpers
        can_vote: ->
            @from_id is Meteor.userId()

if Meteor.isServer
    Meteor.publishComposite 'doc_transactions', (doc_id)->
        {
            find: ->
                Transactions.find doc_id: doc_id
            children: [
                { find: (transaction) ->
                    Meteor.users.find { _id: transaction.from_id },
                        limit: 1
                        fields: 
                            profile: 1
                            username: 1
                } 
            ]
        }