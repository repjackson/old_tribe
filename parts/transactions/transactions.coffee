@Transactions = new Meteor.Collection 'transactions'

Transactions.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.from_id = Meteor.userId()
    return


Transactions.helpers
    from: -> Meteor.users.findOne @from_id
    to: -> Meteor.users.findOne @to_id
    when: -> moment(@timestamp).fromNow()

# FlowRouter.route '/', action: (params) ->
#     BlazeLayout.render 'layout',
#         cloud: 'cloud'
#         main: 'docs'


