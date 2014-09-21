###* @jsx React.DOM ###

Test = React.createClass
  componentWillMount: ->
    @_getJSON()

  getInitialState: ->
    data: null
    filter: 'ALL'

  _getJSON: ->
    $.ajax 'test.json',
      type: 'get'
      dataType: 'json'
      success: (data) =>
        console.log data
        @setState data: data

  render: ->
    switch @state.data
      when null
        `<p>Loading...</p>`
      else
        thumbDisplay = @_thumbDisplay()

        `(
          <div className='thumb-container'>
            {thumbDisplay}
          </div>
        )`


  _thumbDisplay: ->
    projects = @state.data.projects

    for project, index in projects
      thumbSource = "images/" + project.id + "/thumb_200x280.jpg"

      `(
        <div key={index} className='proj-thumbnail'>
          <a>
            <p>
              <img src={thumbSource} />
            </p>
          </a>
        </div>
      )`

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

