Template.all_people.onCreated ->
    @autorun -> Meteor.subscribe('people', selected_tags.array())


Template.all_people.helpers
    people: -> 
        Meteor.users.find { _id: $ne: Meteor.userId() }, 
            limit: 10

    tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else ''


