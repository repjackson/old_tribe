if Meteor.isClient
    Template.buy_button.events
        'click #buy': ->
            self = @
            swal {
                title: "Buy for #{self.price} credits?"
                # text: 'Confirm delete?'
                type: 'info'
                animation: false
                showCancelButton: true
                closeOnConfirm: false
                closeOnCancel: false
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Buy'
                confirmButtonColor: '#da5347'
            }, (isConfirm) ->
                  if isConfirm
                        doc = Docs.findOne FlowRouter.getParam('doc_id')
                        Meteor.call 'buy', doc._id, (err, res)->
                            if err then console.error err
                            else swal 'Bought', 'View your dashboard for details.', 'success'
                  else
                        swal 'Cancelled', 'Purchase Canceled', 'error'
                  return

                
    
    
    Template.buy_button.helpers
        can_buy: ->
            @price < Meteor.user().credits


if Meteor.isServer
    Meteor.methods
        buy: (doc_id)->
            doc = Docs.findOne doc_id
            
            Meteor.users.update @userId,
                $inc: credits: -doc.price
                , ->
                    console.log 'removed my points'
            
            Meteor.users.update doc.author_id,
                $inc: credits: doc.price
                , ->
                    console.log 'added their points'
            
            new_id = Transactions.insert
                to_id: doc.author_id
                doc_id: doc_id
            
            console.log Transactions.findOne new_id
            