AutoForm.addInputType 'fileUpload', template: 'afFileUpload'

getIcon = (file)->
	if file
		file = file.toLowerCase()
		icon = 'file-o'
		if file.indexOf('youtube.com') > -1
			icon = 'youtube'
		else if file.indexOf('vimeo.com') > -1
			icon = 'vimeo-square'
		else if file.indexOf('.pdf') > -1
			icon = 'file-pdf-o'
		else if file.indexOf('.doc') > -1 || file.indexOf('.docx') > -1
			icon = 'file-word-o'
		else if file.indexOf('.ppt') > -1
			icon = 'file-powerpoint-o'
		else if file.indexOf('.avi') > -1 || file.indexOf('.mov') > -1 || file.indexOf('.mp4') > -1
			icon = 'file-movie-o'
		else if file.indexOf('.png') > -1 || file.indexOf('.jpg') > -1 || file.indexOf('.gif') > -1 || file.indexOf('.bmp') > -1
			icon = 'file-image-o'
		else if file.indexOf('http://') > -1 || file.indexOf('https://') > -1
			icon = 'link'
		icon

getTemplate = (file)->
	file = file.toLowerCase()
	template = 'fileThumbIcon'
	if file.indexOf('.jpg') > -1 || file.indexOf('.png') > -1 || file.indexOf('.gif') > -1
		template = 'fileThumbImg'
	template

getCollection = (context) ->
	if typeof context.atts.collection == 'string'
		context.atts.collection = FS._collections[context.atts.collection] or window[context.atts.collection]
	return context.atts.collection

Template.afFileUpload.created = ->
	@file = new ReactiveVar undefined
	@fileUpload = new ReactiveVar undefined
	@fileUploaded = new ReactiveVar undefined
	return

Template.afFileUpload.rendered = ->
	@file.set undefined
	@fileUpload.set undefined
	@fileUploaded.set true
	return

Template.afFileUpload.destroyed = ->
	name = @data.name
	@file.set undefined
	@fileUpload.set undefined
	@fileUploaded.set undefined
	return

uploadFile = (event, template) ->
	FS.Utility.eachFile event, (fileObj) =>
		file = new FS.File fileObj
		file.metadata = file.metadata or {}
		collection = getCollection(template.data)

		if @atts.metadata
			_.extend file.metadata, @atts.metadata

		collection.insert file, (error, image) =>
			if error
				console.log err
			else
				$('input[name="' + @atts.name + '"]').val image._id
				template.file.set image
				template.fileUpload.set fileObj.name
				template.fileUploaded.set false

				collection = getCollection(@)
				cursor = collection.find image._id

				liveQuery = cursor.observe
					changed: (newImage) ->
						if newImage.isUploaded()
							template.fileUploaded.set true
							liveQuery.stop()
							return

Template.afFileUpload.events
	"change .file-upload": uploadFile
	'dropped [data-action="file-dropped"]': uploadFile

	'click .file-path': (event, template)->
		template.$('.file-upload').click()
		return

	'click .file-upload-clear': (event, template)->
		name = $(event.currentTarget).attr('file-input')
		$('input[name="' + name + '"]').val('')
		template.fileUploaded.set true
		template.fileUpload.set undefined
		template.file.set undefined
		@value = undefined
		return

Template.afFileUpload.helpers
	collection: ->
		getCollection(@)
	label: ->
		@atts.label or 'Choose file'
	buttonlabel: ->
		@atts.buttonlabel or 'Choose file'
	dropLabel: ->
		@atts.dropLabel or 'Drop your file here'
	dropEnabled: ->
		@atts.dropEnabled
	dropClasses: ->
		@atts.dropClasses or 'card-panel grey lighten-4 grey-text text-darken-4'
	removeLabel: ->
		@atts['remove-label'] or 'Remove'
	fileUploadAtts: ->
		atts = _.clone(this.atts)
		delete atts.collection
		delete atts.buttonlabel
		delete atts.metadata
		atts
	fileUpload: ->
		template = Template.instance()

		name = @atts.name
		collection = getCollection(@)

		if template.file.get()
			file = template.file.get()._id
		else if @value
			file = @value
		else
			return null

		if file != '' && file
			if file.length == 17
				cfsFile = collection.findOne _id:file
				if cfsFile
					unless template.file.get()
						template.file.set cfsFile
						template.fileUploaded.set true

					filename = cfsFile.name()
					src = cfsFile.url()
				else
					# No subscription
					filename = template.fileUpload.get()
					if filename
						obj =
							template: 'fileThumbIcon'
							data:
								src: filename
								icon: getIcon filename
						return obj
			else
				filename = file
				src = filename

		if filename
			obj =
				template: getTemplate filename
				data:
					src: src
					icon: getIcon filename
			obj

	fileUploadSelected: (name)->
		template = Template.instance()
		template.fileUpload.get()

	isUploaded: (name,collection) ->
		template = Template.instance()
		template.fileUploaded.get()
