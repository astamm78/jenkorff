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
        @setState data: data

  render: ->
    content = switch @state.data
      when null
        `<p>Loading...</p>`
      else
        `(
          <span>
            <h1>{this.state.data.title}</h1>
            <h2>{this.state.data.subhead}</h2>
          </span>
        )`

    `(
      <div>
        {content}
      </div>
    )`


React.renderComponent Test(), document.getElementById('react-content')