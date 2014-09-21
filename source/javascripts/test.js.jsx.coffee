###* @jsx React.DOM ###

Test = React.createClass
  componentWillMount: ->
    @_getJSON()

  getInitialState: ->
    data: null
    filter: 'ALL'
    selectedProject: null

  _getJSON: ->
    $.ajax 'jen_korff_data.json',
      type: 'get'
      dataType: 'json'
      success: (data) =>
        @setState data: data

  render: ->
    switch @state.data
      when null
        `<p>Loading...</p>`
      else
        thumbDisplay = @_thumbDisplay()
        selectedProject = @_selectedProject()

        `(
          <div id="content-top">
            {selectedProject}

            <div className='thumb-container'>
              {thumbDisplay}
            </div>
          </div>
        )`


  _thumbDisplay: ->
    projects = @state.data.projects

    for project, index in projects
      thumbSource = "images/" + project.id + "/thumb_200x280.jpg"

      `(
        <div key={index} className='proj-thumbnail'>
          <a onClick={this._setProjectDetail(project)}>
            <p>
              <img src={thumbSource} />
            </p>
          </a>
        </div>
      )`

  _closeSelected: ->
    @setState
      selectedProject: null
      mainImage: null

    scroll()

  _setProjectDetail: (project) ->
    =>
      @setState
        selectedProject: project.id
        mainImage: project.images[0]

      scroll()

  _selectedProject: ->
    projects = @state.data.projects

    switch @state.selectedProject
      when null then ``
      else
        for project, index in projects when project.id == @state.selectedProject
          mainImage = @_mainImage(project)
          selectedThumbs = @_selectedThumbs(project)
          text = @_renderText(project)

          `(
            <div key={index} className='jumbotron'>
              {mainImage}
              <br />
              {selectedThumbs}
              {text}
              <p>
                <a onClick={this._closeSelected}>Close</a>
              </p>
            </div>
          )`

  _mainImage: (project) ->
    url = "images/" + project.id + "/" + @state.mainImage
    `<img src={url} />`

  _renderText: (project) ->
    for para, index in project.text
      html = $.parseHTML( para )
      parsedHTML = @_parsedHTML(html)

      `(
        <p key={index}>
          {parsedHTML}
        </p>
      )`

  _parsedHTML: (html) ->
    for tag, index in html
      if tag.nodeName == "I"
        `(
          <span key={index}>
            <em>{$(tag).html()}</em>
          </span>
        )`
      else
        `(
          <span key={index}>
            {$(tag).text()}
          </span>
        )`

  _selectedThumbs: (project) ->
    if project.images.length > 1
      for image, index in project.images
        url = "images/" + project.id + "/" + image

        `(
          <a key={index} onClick={this._setMainImage(image)}>
            <img  src={url} height="50" />
          </a>
        )`

    else
      ``

  _setMainImage: (image) ->
    =>
      @setState mainImage: image


React.renderComponent Test(), document.getElementById('react-content')

