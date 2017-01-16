@selected_tribe_tags = new ReactiveArray []

Template.tribe_cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tribe_tags', selected_tribe_tags.array()



Template.tribe_cloud.helpers
    all_tags: ->
        user_count = Meteor.users.find( _id: $ne: Meteor.userId() ).count()
        if 0 < user_count < 3 then Tribe_tags.find({ count: $lt: user_count }, {limit:20}) else Tribe_tags.find({}, limit:20)

    tribe_cloud_tag_class: ->
        button_class = switch
            when @index <= 5 then 'large'
            when @index <= 12 then ''
            when @index <= 20 then 'small'
        return button_class

    selected_tribe_tags: -> selected_tribe_tags.list()


Template.tribe_cloud.events
    'click .select_tag': -> selected_tribe_tags.push @name
    'click .unselect_tag': -> selected_tribe_tags.remove @valueOf()
    'click #clear_tags': -> selected_tribe_tags.clear()
