###* @jsx React.DOM ###

Test = React.createClass
  componentWillMount: ->
    @_getJSON()

  getInitialState: ->
    data: null

  _getJSON: ->
    $.ajax 'test.json',
      type: 'get'
      dataType: 'json'
      success: (data) =>
        console.log data
        @setState data: data

  render: ->
    content = switch @state.data
      when null
        `<p>Loading...</p>`
      else
        projects = @_projectsDisplay()

        `(
          <span>
            {projects}
          </span>
        )`

    `(
      <div className='thumb-container'>
        {content}
      </div>
    )`

  _projectsDisplay: ->
    projects = @state.data.projects

    for project, index in projects
      projectText = @_renderText(project)
      fullSizeImages = @_fullSizeImages(project)
      thumbSource = "images/" + project.id + "/thumb_200x280.jpg"

      `(
        <div key={index} className='thumbnail center-block'>
          <a onClick={this._showModal(project.id)}>
            <p>
              <img src={thumbSource} />
            </p>
          </a>

          <div className="modal modal-fade project-detail" id={project.id}>
            <a onClick={this._hideModal}>
              {fullSizeImages}
              {projectText}
            </a>
          </div>

        </div>
      )`

  _hideModal: ->
    $('.project-detail').removeClass('project-show')

  _showModal: (id) ->
    =>
      $('.project-detail').removeClass('project-show')
      $("#" + id).addClass('project-show')

  _renderText: (project) ->
    for para, index in project.text
      `(
        <p key={index}>
          {para}
        </p>
      )`

  _fullSizeImages: (project) ->
    for image, index in project.images
      url = "images/" + project.id + "/" + image

      `(
        <img key={index} src={url} />
      )`


React.renderComponent Test(), document.getElementById('react-content')

