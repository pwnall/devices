# Generic iPad drawing algorithm.
class IpadBase extends Device
  constructor: ->
    super()

  options: ->
    [
      { id: 'width', label: 'Width', type: 'number' },
      { id: 'height', label: 'Height', type: 'number' },
      { id: 'cornerRadius', label: 'Corner Radius', type: 'number' },
      { id: 'screenWidth', label: 'Screen Width', type: 'number' },
      { id: 'screenHeight', label: 'Screen Height', type: 'number' },
      { id: 'screenElevation', label: 'Screen Elevation', type: 'number' },
      { id: 'screenOffset', label: 'Screen Offset', type: 'number' },
      { id: 'buttonDiameter', label: 'Button Diameter', type: 'number' },
      { id: 'buttonElevation', label: 'Button Elevation', type: 'number' },
      { id: 'buttonOffset', label: 'Button Offset', type: 'number' },
      { id: 'cameraDiameter', label: 'Camera Diameter', type: 'number' },
      { id: 'cameraDrop', label: 'Camera Drop', type: 'number' },
      { id: 'cameraOffset', label: 'Camera Offset', type: 'number' },
      { id: 'alsDiameter', label: 'ALS Diameter', type: 'number' },
      { id: 'alsDrop', label: 'ALS Drop', type: 'number' },
      { id: 'alsOffset', label: 'ALS Offset', type: 'number' },
      { id: 'als2Offset', label: 'ALS 2 Offset', type: 'number' },
      { id: 'bezelRadius', label: 'Bezel Radius', type: 'number' },
    ]

  build: ->
    bezel = @option 'bezelRadius'
    width = @option 'width'
    height = @option 'height'
    corner = @option 'cornerRadius'
    buttonElevation = @option 'buttonElevation'
    buttonOffset = @option 'buttonOffset'
    screenWidth = @option 'screenWidth'
    screenElevation = @option 'screenElevation'
    if screenElevation is 0
      screenElevation = 2 * buttonElevation
    screenOffset = @option 'screenOffset'
    cameraOffset = @option 'cameraOffset'
    alsOffset = @option 'alsOffset'
    als2Offset = @option 'als2Offset'

    x0 = bezel
    x1 = bezel + width
    y0 = bezel
    bottom = bezel + height
    xMid = bezel + width / 2
    screenY1 = bottom - screenElevation
    screenY0 = screenY1 - @option('screenHeight')
    if screenOffset is 0
      screenX0 = xMid - screenWidth / 2
      screenX1 = xMid + screenWidth / 2
    else if screenOffset < 0
      screenX1 = x1 + screenOffset
      screenX0 = screenX1 - screenWidth
    else
      screenX0 = x0 + screenOffset
      screenX1 = screenX0 + screenWidth
    if buttonOffset > 0
      buttonX = x0 + buttonOffset
    else
      buttonX = x1 + buttonOffset
    if alsOffset > 0
      alsX = x0 + alsOffset
    else
      alsX = x1 + alsOffset
    if als2Offset is 0
      als2X = 0
    else if als2Offset > 0
      als2X = x0 + als2Offset
    else
      als2X = x1 + als2Offset
    if cameraOffset > 0
      cameraX = x0 + cameraOffset
    else
      cameraX = x1 + cameraOffset

    pwnvg = new Pwnvg 0, 0, width + 2 * bezel, height + 2 * bezel
    pwnvg.roundedRect(bezel, bezel, width + bezel, height + bezel, corner).
        addClass('bezel').strokeWidth(bezel).stroke('#000').fill('none')
    pwnvg.rect(screenX0, screenY0, screenX1, screenY1).
        addClass('screen').fill('#000').
        strokeWidth('1px').nonScalingStroke().stroke('#000').fill('none')
    if @option('cameraDiameter') isnt 0
      pwnvg.circle(cameraX, x0 + @option('cameraDrop'),
          @option('cameraDiameter') / 2).addClass('camera').fill('#000')
    pwnvg.circle(alsX, x0 + @option('alsDrop'), @option('alsDiameter') / 2).
        addClass('als')
    if als2Offset isnt 0
      pwnvg.circle(als2X, x0 + @option('alsDrop'), @option('alsDiameter') / 2).
          addClass('als2')
    pwnvg.circle(buttonX, bottom - buttonElevation,
        @option('buttonDiameter') / 2).addClass('button').strokeWidth('1px').
        nonScalingStroke().stroke('#000').fill('none')
    pwnvg


# iPad 1 dimensions.
class Ipad extends IpadBase
  name: ->
    'Apple iPad'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad WiFi, page 41 in R8
    {
      width: 189.7
      height: 242.9
      cornerRadius: 10.4
      screenWidth: 149
      screenHeight: 198.1
      screenElevation: 0
      screenOffset: 0
      buttonDiameter: 11.2
      buttonElevation: 11.6
      buttonOffset: 94.9
      cameraDiameter: 0
      cameraDrop: 0
      cameraOffset: 0
      alsDiameter: 1.2
      alsDrop: 6.7
      alsOffset: 94.9
      als2Offset: 0
      bezelRadius: 2.2
    }
Device.register Ipad

# iPad 2 dimensions.
class Ipad2 extends IpadBase
  name: ->
    'Apple iPad 2'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad 2 WiFi, page 39 in R8
    {
      width: 185.8
      height: 241.3
      cornerRadius: 6.7
      screenWidth: 149
      screenHeight: 198.1
      screenElevation: 0
      screenOffset: 0
      buttonDiameter: 11.3
      buttonElevation: 10.8
      buttonOffset: 92.9
      cameraDiameter: 2.7
      cameraDrop: 11.1
      cameraOffset: 92.9
      alsDiameter: 1.2
      alsDrop: 6.7
      alsOffset: 92.9
      als2Offset: 0
      bezelRadius: 2.2
    }
Device.register Ipad2

# iPad 3 dimensions.
class Ipad3 extends IpadBase
  name: ->
    'Apple iPad 3rd Gen'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad 3 WiFi, page 37 in R8
    {
      width: 185.8
      height: 241.3
      cornerRadius: 6.7
      screenWidth: 149
      screenHeight: 198.1
      screenOffset: 0
      screenElevation: 0
      buttonDiameter: 11.3
      buttonElevation: 10.8
      buttonOffset: 92.9
      cameraDiameter: 2.7
      cameraDrop: 11.1
      cameraOffset: 92.9
      alsDiameter: 1.2
      alsDrop: 6.7
      alsOffset: 92.9
      als2Offset: 0
      bezelRadius: 2.0
    }
Device.register Ipad3

# iPad 4 dimensions.
class Ipad4 extends IpadBase
  name: ->
    'Apple iPad 4th Gen'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad 4 WiFi, page 35 in R8
    {
      width: 185.8
      height: 241.3
      cornerRadius: 6.7
      screenWidth: 149
      screenHeight: 198.1
      screenOffset: 0
      screenElevation: 0
      buttonDiameter: 11.3
      buttonElevation: 10.8
      buttonOffset: 92.9
      cameraDiameter: 2.4
      cameraDrop: 11.1
      cameraOffset: 92.9
      alsDiameter: 1.2
      alsDrop: 6.7
      alsOffset: 92.9
      als2Offset: 0
      bezelRadius: 1.6
    }
Device.register Ipad4

# iPad mini dimensions.
class IpadMini extends IpadBase
  name: ->
    'Apple iPad Mini'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad mini WiFi, page 33 in R8
    {
      width: 134.7
      height: 200.1
      cornerRadius: 6.7
      screenWidth: 121.3
      screenHeight: 161.2
      screenOffset: -6.7
      screenElevation: 19.4
      buttonDiameter: 10
      buttonElevation: 9.6
      buttonOffset: -67.4
      cameraDiameter: 2.4
      cameraDrop: 10.7
      cameraOffset: -67.4
      alsDiameter: 1.2
      alsDrop: 10.7
      alsOffset: -71.8
      als2Offset: 0
      bezelRadius: 0.5
    }
Device.register IpadMini

# iPad mini 2 dimensions.
class IpadMini2 extends IpadBase
  name: ->
    'Apple iPad Mini 2/3'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad mini WiFi, page 29 in R8
    {
      width: 134.7
      height: 200.1
      cornerRadius: 6.7
      screenWidth: 121.3
      screenHeight: 161.2
      screenOffset: -6.7
      screenElevation: 19.4
      buttonDiameter: 10
      buttonElevation: 9.6
      buttonOffset: -67.4
      cameraDiameter: 2.5
      cameraDrop: 10.7
      cameraOffset: -67.4
      alsDiameter: 1.2
      alsDrop: 10.7
      alsOffset: -71.7
      als2Offset: 0
      bezelRadius: 0.5
    }
Device.register IpadMini2

# iPad Air dimensions.
class IpadAir extends IpadBase
  name: ->
    'Apple iPad Air'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad Air WiFi, page 31 in R8
    {
      width: 169.5
      height: 240
      cornerRadius: 6.7
      screenWidth: 149
      screenHeight: 198.1
      screenOffset: -10.3
      screenElevation: 21
      buttonDiameter: 10.7
      buttonElevation: 10.1
      buttonOffset: -84.7
      cameraDiameter: 2.5
      cameraDrop: 11.1
      cameraOffset: -84.7
      alsDiameter: 1.2
      alsDrop: 11.1
      alsOffset: -89.1
      als2Offset: 0
      bezelRadius: 0.8
    }
Device.register IpadAir

# iPad Air 2 dimensions.
class IpadAir2 extends IpadBase
  name: ->
    'Apple iPad Air 2'
  defaults: ->
    # https://developer.apple.com/resources/cases/Case-Design-Guidelines.pdf
    # iPad mini WiFi, page 27 in R8
    {
      width: 169.47
      height: 240
      cornerRadius: 7.80
      screenWidth: 153.71
      screenHeight: 203.11
      screenOffset: -10.3
      screenElevation: 21
      buttonDiameter: 10.7
      buttonElevation: 10.1
      buttonOffset: -84.74
      cameraDiameter: 2.45
      cameraDrop: 11.07
      cameraOffset: -84.74
      alsDiameter: 2
      alsDrop: 5.14
      alsOffset: -153.03
      als2Offset: -16.44
      bezelRadius: 0.8
    }
Device.register IpadAir2

