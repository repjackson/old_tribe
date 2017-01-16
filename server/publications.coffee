Meteor.publish 'doc', (id)-> Docs.find id


Meteor.publish 'person', (id)-> Meteor.users.find id

Meteor.publish 'me', ->
    Meteor.users.find @userId,
        fields:
            cloud: 1

# Meteor.publish 'tweetDocs', ->
#     Docs.find
#         $and: [
#             { authorId: @userId }
#             { tags: $in: ['tweet'] }
#         ]



Meteor.publish 'docs', (selected_tags, viewMode, selected_usernames)->
    Counts.publish(this, 'doc_counter', Docs.find(), { noReady: true })

    match = {}
    if not @userId? then match.personal = false
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if viewMode is 'mine' then match.authorId = @userId
    if selected_usernames.length > 0 then match.username = $in: selected_usernames

    Docs.find match,
        limit: 10
        sort: timestamp: -1

