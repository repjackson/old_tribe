Template.edit_price.events
    'change #price': ->
        doc_id = FlowRouter.getParam('doc_id')
        price = $('#price').val()

        int = parseInt price

        Docs.update doc_id,
            $set: price: int