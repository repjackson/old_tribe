Template.tribe_people.onCreated ->
    @autorun -> Meteor.subscribe('tribe_people', selected_tribe_tags.array())


Template.tribe_people.helpers
    tribe_people: -> 
        Meteor.users.find { _id: $ne: Meteor.userId() }, 
            limit: 10

    tag_class: -> if @valueOf() in selected_tribe_tags.array() then 'primary' else ''


