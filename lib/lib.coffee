@Tags = new Meteor.Collection 'tags'
@Tribe_tags = new Meteor.Collection 'tribe_tags'


FlowRouter.route '/',
    name: 'home'
    action: ->
        BlazeLayout.render 'layout', 
            cloud: 'cloud'
            main: 'all_people'

FlowRouter.route '/tribe',
    name: 'tribe'
    action: ->
        BlazeLayout.render 'layout', 
            cloud: 'tribe_cloud'
            main: 'tribe_people'


FlowRouter.route '/profile/edit/', action: (params) ->
    BlazeLayout.render 'layout',
        # sub_nav: 'account_nav'
        main: 'edit_profile'

FlowRouter.route '/view/:user_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_profile'

