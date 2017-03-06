if Meteor.isClient
    Template.doc_transactions.onCreated -> 
        @autorun -> Meteor.subscribe('doc_transactions', FlowRouter.getParam('doc_id'))

    Template.doc_transactions.helpers
        transactions: -> 
            Transactions.find { }
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'


if Meteor.isServer
    Meteor.publish 'doc_transactions', (doc_id)->
        Transactions.find
            doc_id: doc_id