Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tags', selected_tags.array()




Template.cloud.helpers
    all_tags: ->
        user_count = Meteor.users.find( _id: $ne: Meteor.userId() ).count()
        if 0 < user_count < 3 then Tags.find({ count: $lt: user_count }, {limit:20}) else Tags.find({}, limit:20)

    cloud_tag_class: ->
        button_class = switch
            when @index <= 5 then 'large'
            when @index <= 12 then ''
            when @index <= 20 then 'small'
        return button_class

    selected_tags: -> selected_tags.list()


Template.cloud.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()