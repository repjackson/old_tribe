Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        # console.log 'user ' + userId + 'wants to modify doc' + doc._id
        if userId and doc._id == userId
            # console.log 'user allowed to modify own account'
            true


Accounts.onCreateUser (options, user) ->
    user.credits = 10
    user

Meteor.publish 'me', -> 
    Meteor.users.find @userId,
        fields: 
            credits: 1

Meteor.publish 'person', (user_id)-> 
    Meteor.users.find user_id,
        fields: 
            credits: 1




Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.cloudinary_key
    api_secret: Meteor.settings.cloudinary_secret



    


Meteor.publish 'people', (selected_tags)->
    match = {}
    # if selected_tags.length > 0 then match.tags = $all: selected_tags
    match.tags = $all: selected_tags
    match._id = $ne: @userId
    Meteor.users.find match,
        fields: 
            profile: 1
            credits: 1





Docs.allow
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')




Meteor.publish 'docs', (selected_tags, filter)->

    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    # match.tags = $all: selected_tags
    
    if filter then match.type = filter

    Docs.find match,
        limit: 5
        

Meteor.publish 'doc', (id)->
    Docs.find id
    
    
    
Meteor.publish 'tags', (selected_tags, filter)->
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if filter then match.type = filter

    cloud = Docs.aggregate [
        { $match: match }
        { $project: "tags": 1 }
        { $unwind: "$tags" }
        { $group: _id: "$tags", count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]

    # console.log 'filter: ', filter
    # console.log 'cloud: ', cloud

    cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()

