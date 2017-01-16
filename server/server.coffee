Docs.allow
    insert: (userId, doc)-> doc.authorId is Meteor.userId()
    update: (userId, doc)-> doc.authorId is Meteor.userId()
    remove: (userId, doc)-> doc.authorId is Meteor.userId()



Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        # console.log 'user ' + userId + 'wants to modify doc' + doc._id
        if userId and doc._id == userId
            # console.log 'user allowed to modify own account'
            true

Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.cloudinary_key
    api_secret: Meteor.settings.cloudinary_secret





Meteor.publish 'me', -> 
    Meteor.users.find @userId,
        fields: 
            tribe: 1
            tags: 1
            profile: 1

# Meteor.publish 'usernames', () -> 
#     Meteor.users.find()


Meteor.publish 'tags', (selected_tags)->
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    match._id = $ne: @userId


    cloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: "$tags" }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'cloud, ', cloud
    cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()
    


Meteor.publish 'people', (selected_tags)->
    match = {}
    # if selected_tags.length > 0 then match.tags = $all: selected_tags
    match.tags = $all: selected_tags
    match._id = $ne: @userId
    Meteor.users.find match,
        fields: 
            tribe: 1
            profile: 1
            tags: 1




Meteor.publish 'user_profile', ->
    Meteor.users.find @userId

