export SLASH_BALIGN1, SLASH_BALIGN2 = '/balign', '/align'

ROWS, COLS = 36, 64

class Grid
  new: =>
    @frame = with CreateFrame 'Frame'
      \SetFrameStrata 'BACKGROUND'
      \SetAllPoints UIParent
      \SetScript 'OnUpdate', @\onUpdate
    @rows, @cols = {}, {}
    xs, ys = @frame\GetWidth! / COLS, @frame\GetHeight! / ROWS
    @cols[y] = @addHLine y * ys, {0, 0, 0, .5} for y = 1, ROWS
    @rows[x] = @addVLine x * xs, {0, 0, 0, .5} for x = 1, COLS
    @frame\Hide!
    @visible = false

  toggle: =>
     if @visible
      @frame\Hide!
      @visible = false
    else
      @frame\Show!
      @visible = true

  onUpdate: (_, dt) =>
    tex\SetTexture 0, 0, 0, .5 for tex in *@rows
    tex\SetTexture 0, 0, 0, .5 for tex in *@cols
    x, y = GetCursorPosition!
    esc = UIParent\GetScale!
    x /= esc * UIParent\GetWidth!
    y /= esc * UIParent\GetHeight!
    xi = math.floor(x * (COLS - 1))
    yi = math.floor(y * (ROWS - 1))
    @cols[yi + 1]\SetTexture 1, 0, 0, .5
    @rows[xi + 1]\SetTexture 1, 0, 0, .5
    @cols[ROWS - yi - 1]\SetTexture 1, 0, 0, .5
    @rows[COLS - xi - 1]\SetTexture 1, 0, 0, .5

  addLine: (col) =>
    with @frame\CreateTexture nil, 'BACKGROUND'
      \SetTexture unpack(col)

  addVLine: (x, col) =>
    with @addLine col
      \SetPoint 'TOPLEFT', @frame, 'TOPLEFT', x, 0
      \SetWidth 1
      \SetHeight GetScreenHeight!

  addHLine: (y, col) =>
    with @addLine col
      \SetPoint 'BOTTOMLEFT', @frame, 'BOTTOMLEFT', 0, y
      \SetWidth GetScreenWidth!
      \SetHeight 1

local grid

SlashCmdList.BALIGN = (msg, eb) ->
  grid or= Grid!
  grid\toggle!
