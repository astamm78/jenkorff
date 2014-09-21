###* @jsx React.DOM ###

Gallery = React.createClass
  componentWillMount: ->
    @_getJSON()

  getInitialState: ->
    data: null
    filter: 'All'
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
        sectionLinks = @_sectionLinks()
        caseStudyLinks = @_caseStudyLinks()
        selectedProject = @_selectedProject()
        thumbDisplay = @_thumbDisplay()

        `(
          <div id="content-top">
            {sectionLinks}
            {caseStudyLinks}

            {selectedProject}

            <div className='thumb-container'>
              {thumbDisplay}
            </div>
          </div>
        )`


  _sectionLinks: ->
    listItems = @_listLinks()

    `(
      <ul className='filters'>
        {listItems}
      </ul>
    )`

  _caseStudyLinks: ->
    caseLinks = @_caseLinks()

    `(
      <ul className='case-studies'>
        <li><strong>CASE STUDIES:</strong></li>
        {caseLinks}
      </ul>
    )`

  _listLinks: ->
    links = [
        "All", "Branding", "Creative Direction", "Custom Illustration",
        "Custom Lettering", "Design", "Strategy", "Website Design", "Website Production"
      ]

    for link, index in links
      selected = "active-" + ( @state.filter == link )
      `<li key={index}><a onClick={this._filterProjects(link)} className={selected}>{link}</a></li>`

  _filterProjects: (filter) ->
    =>
      @setState
        filter: filter
        selectedProject: null
        mainImage: null

  _filteredProjects: (filter) ->
    for project in @state.data.projects when @_projectHasCategory(project)
      project

  _projectHasCategory: (project) ->
    $.inArray(@state.filter, project.categories) != -1

  _caseLinks: ->
    links = [
        ["Hubbard One", "017"], ["Believe High School Networks", "006"], ["Trayt", "019"], ["WSFS", "015"]
      ]

    for link, index in links
      selected = "active-" + ( @state.selectedProject != null && @state.selectedProject == link[1] )
      `<li key={index}><a onClick={this._setCase(link[1])} className={selected}>{link[0]}</a></li>`

  _setCase: (id) ->
     =>
      @setState
        selectedProject: id
        mainImage: @_selectedCaseStudy(id).images[0]

      scroll()

  _selectedCaseStudy: (id) ->
    for project in @state.data.projects when project.id == id
      return project

  _thumbDisplay: ->
    projects = switch @state.filter
      when 'All' then @state.data.projects
      else
        @_filteredProjects(@state.filter)

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
              <div className="selected-images">
                {mainImage}
                <br />
                {selectedThumbs}
              </div>
              {text}
              <p>
                <a onClick={this._closeSelected}>Close</a>
              </p>
            </div>
          )`

  _mainImage: (project) ->
    url = "images/" + project.id + "/" + @state.mainImage
    `<img src={url} className='main-project-image'/>`

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
          <a key={index} onClick={this._setMainImage(image)} className="selected-thumbs" >
            <img  src={url} height="50" />
          </a>
        )`

    else
      ``

  _setMainImage: (image) ->
    =>
      @setState mainImage: image


React.renderComponent Gallery(), document.getElementById('react-content')

