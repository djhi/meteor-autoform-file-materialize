Autoform File
=============

### Description ###
DEPRECATED - Upload and manage files with autoForm for materialize

> **Important** - I no longer use Meteor and won't be updating this project anymore. Please use https://github.com/mozfet/meteor-autoform-file-materialize which will be updated. Thanks to @mozfet for taking over this project.

**Forked from [yogiben:autoform-file](https://github.com/yogiben/meteor-autoform-file)**

![Meteor autoform file](https://raw.githubusercontent.com/yogiben/meteor-autoform-file/master/readme/1.png)

### Quick Start ###
1) Install `meteor add gildaspk:autoform-file-materialize`

2) Create your collectionFS (See [collectionFS](https://github.com/CollectionFS/Meteor-CollectionFS))
```
@Images = new FS.Collection("images",
  stores: [new FS.Store.GridFS("images", {})]
)
```
3) Make sure the correct allow rules & subscriptions are set up on the collectionFS
```
Images.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true
```
and
```
Meteor.publish 'images', ->
  Images.find()
```
and in your router.coffee
```
  @route "profile",
    waitOn: ->
      [
        Meteor.subscribe 'images'
      ]
```
4) Define your schema and set the `autoform` property like in the example below
```
Schemas = {}

@Posts = new Meteor.Collection('posts');

Schemas.Posts = new SimpleSchema
	title:
		type:String
		max: 60

	picture:
		type: String
		autoform:
			afFieldInput:
				type: 'fileUpload'
				collection: 'Images'
        label: 'Choose file' # optional

Posts.attachSchema(Schemas.Posts)
```

The `collection` property is the field name of your collectionFS.

5) Generate the form with `{{> quickform}}` or `{{#autoform}}`

e.g.
```
{{> quickForm collection="Posts" type="insert"}}
```

or

```
{{#autoForm collection="Posts" type="insert"}}
{{> afQuickField name="title"}}
{{> afQuickField name="picture"}}
<button type="submit" class="waves-effect waves-light btn">
  <i class="mdi-content-send.right"></i>
  Insert
</button>
{{/autoForm}}
```
###Security & optimization###
The above example is just a starting point. You should set your own custom `allow` rules and optimize your subscriptions.

The `remove` button delete the file from your CFS collection. Take care to update your document accordingly or you'll get invalid references.

### Customization ###
You can customize the button / remove text.

Defaults:
```
{{> afFieldInput name="picture" label=">" remove-label="Remove" placeholder="Please select a file"}}
```

You can add metadata to your file:

Template
```
{{> afFieldInput name="picture" metadata=metadataHelper}}
```

Helper
```
Templates.myTemplate.helpers({
  metadataHelper: function(){
    return {
      userId: Meteor.userId()
    }
  }
});
```

You can enable drop zone by setting `dropEnabled` to `true` (default is `false`).

Dropzone CSS classes can be defined with `dropClasses` (default is `card-panel grey lighten-4 grey-text text-darken-4`)

Dropzone text can be defined with `dropLabel` (default is `Drop your file here`)
