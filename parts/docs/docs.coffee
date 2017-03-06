@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.points = 0
    doc.group_id = 'CiD3esYNw4oRdL5PW'
    doc.down_voters = []
    doc.up_voters = []
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
    # Meteor.call 'generate_authored_cloud'
), fetchPrevious: true


Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

FlowRouter.route '/', action: (params) ->
    BlazeLayout.render 'layout',
        cloud: 'cloud'
        main: 'docs'

Meteor.methods
    add: (tags=[])->
        id = Docs.insert
            tags: tags
        return id


if Meteor.isClient
    Template.docs.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array())

    Template.docs.helpers
        docs: -> 
            Docs.find { }, 
                sort:
                    tag_count: 1
                limit: 5
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'


    
    Template.view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
    
        when: -> moment(@timestamp).fromNow()

    Template.view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
        'click .edit': -> FlowRouter.go("/edit/#{@_id}")

    Template.docs.events
        'click #add': ->
            Meteor.call 'add', (err,id)->
                FlowRouter.go "/edit/#{id}"

