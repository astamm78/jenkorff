###* @jsx React.DOM ###

Test = React.createClass
  render: ->
    `(
      <div>
        {this.props.title}
      </div>
    )`

React.renderComponent Test(title: "Hello World"), document.getElementById('post-list')
