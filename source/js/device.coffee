# All device models should inherit from this.
class Device
  constructor: ->
    @_options = @defaults()
    @_optionInfo = @options()
    @_inputs = null
    null

  # The name that the user sees when choosing between models.
  #
  # Subclasses must override this method.
  #
  # @return {String} the model's name
  name: ->
    throw new Error 'name not implemented'

  # Metadata about the model's customization options.
  #
  # Subclasses must override this method.
  #
  # @return {Array<Object>} the device's options; each option has the
  #   properties 'id' (property name for the option), 'label' (text in the
  #   label for the option), 'type' (input type)
  options: ->
    throw new Error 'options not implemented'

  # Default values for the model's customization options.
  #
  # Subclasses must override this method.
  #
  # @return {Object<String, Object>} an object whose properties are the IDs of
  #   all the options returned by {Device#options}; the associated values are
  #   the default values for the options
  defaults: ->
    throw new Error 'defaults not implemented'

  # Builds the model's preview SVG.
  #
  # @return {Pwnvg} the SVG element representing the model
  build: ->
    throw new Error 'build not implemented'

  # The current value for an option.
  #
  # @param {id} name the option's ID
  # @return {Object} the option's value
  option: (id) ->
    unless id of @_options
      throw new Error "Option not found: #{id}"
    @_options[id]

  # Called when the model is selected.
  _onSelected: ->
    @_rebuildOptionsDom()
    @_readOptions()
    @_redraw()

  # Called when the user changes a model option.
  _onOptionChange: ->
    @_readOptions()
    @_redraw()

  # Rebuilds the model's SVG preview.
  _redraw: ->
    svgContainer = document.getElementById 'preview'
    svgContainer.innerHTML = ''
    pwnvg = @build()
    console.log pwnvg
    svgContainer.appendChild pwnvg.svg

  # Re-populates the model options container with this model's options.
  #
  # @return undefined
  _rebuildOptionsDom: ->
    container = document.getElementById 'model-options'
    container.innerHTML = ''
    defaults = @defaults()
    @_inputs = {}
    for option in @_optionInfo
      p = document.createElement 'p'
      label = document.createElement 'label'
      label.textContent = option.label
      label.setAttribute 'for', "model-option-#{option.id}"
      p.appendChild label
      input = document.createElement 'input'
      input.setAttribute 'id', "model-option-#{option.id}"
      input.setAttribute 'value', defaults[option.id]
      input.setAttribute 'type', option.type
      input.value = @_options[option.id]
      p.appendChild input
      @_inputs[option.id] = input
      container.appendChild p
    return

  # Reads the current options from the DOM.
  #
  # @return undefined
  _readOptions: ->
    for option in @_optionInfo
      value = @_inputs[option.id].value
      if option.type is 'number'
        value = parseFloat value
      @_options[option.id] = value
    return

  # Adds a device to the list of devices.
  #
  # @param [Class] klass a constructor for a class that inherits from Device
  # @return undefined
  @register: (klass) ->
    device = new klass()
    @_devices[device.name()] = device
    return

  # Called after all device models are loaded, to set up the page's DOM.
  @wire: ->
    list = document.getElementById 'model-select'
    list.addEventListener 'change', (event) =>
      @_onModelChange list.value

    options = document.getElementById 'model-options'
    options.addEventListener 'change', (event) =>
      @_onOptionChange()

    names = []
    for name of @_devices
      names.push name
    names.sort()

    for name in names
      option = document.createElement 'option'
      option.textContent = name
      option.setAttribute 'value', name
      list.appendChild option
    @_onModelChange list.value

  # Called when the user selects a device model from the dropdown.
  #
  # @param {String} name the newly selected model name
  # @return undefined
  @_onModelChange: (name) ->
    @_currentDevice = @_devices[name]
    @_currentDevice._onSelected()
    return

  # Called when the user changes a model option.
  @_onOptionChange: ->
    return if @_currentDevice is null
    @_currentDevice._onOptionChange()

  # List of devices.
  #
  # @private
  # This is used by class methods.
  @_devices: {}

  # The currently selected device model.
  #
  # @private
  # This is used by class methods.
  @_currentDevice: null

window.Device = Device
window.addEventListener 'load', ->
  Device.wire()
