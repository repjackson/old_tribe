Template.person.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'active' else ''

    is_in_tribe: ->
        Meteor.user().tribe and @_id in Meteor.user().tribe


Template.person.events
    'click .person_tag': ->
        if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()
        
    'click .add_to_tribe': ->
        Meteor.users.update Meteor.userId(), 
            $addToSet: tribe: @_id
        
    'click .remove_from_tribe': ->
        Meteor.users.update Meteor.userId(), 
            $pull: tribe: @_id
        
        
        
        