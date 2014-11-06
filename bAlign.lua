SLASH_BALIGN1, SLASH_BALIGN2 = '/balign', '/align'
local ROWS, COLS = 36, 64
local Grid
do
  local _base_0 = {
    toggle = function(self)
      if self.visible then
        self.frame:Hide()
        self.visible = false
      else
        self.frame:Show()
        self.visible = true
      end
    end,
    onUpdate = function(self, _, dt)
      local _list_0 = self.rows
      for _index_0 = 1, #_list_0 do
        local tex = _list_0[_index_0]
        tex:SetTexture(0, 0, 0, .5)
      end
      local _list_1 = self.cols
      for _index_0 = 1, #_list_1 do
        local tex = _list_1[_index_0]
        tex:SetTexture(0, 0, 0, .5)
      end
      local x, y = GetCursorPosition()
      local esc = UIParent:GetScale()
      x = x / (esc * UIParent:GetWidth())
      y = y / (esc * UIParent:GetHeight())
      local xi = math.floor(x * (COLS - 1))
      local yi = math.floor(y * (ROWS - 1))
      self.cols[yi + 1]:SetTexture(1, 0, 0, .5)
      self.rows[xi + 1]:SetTexture(1, 0, 0, .5)
      self.cols[ROWS - yi - 1]:SetTexture(1, 0, 0, .5)
      return self.rows[COLS - xi - 1]:SetTexture(1, 0, 0, .5)
    end,
    addLine = function(self, col)
      do
        local _with_0 = self.frame:CreateTexture(nil, 'BACKGROUND')
        _with_0:SetTexture(unpack(col))
        return _with_0
      end
    end,
    addVLine = function(self, x, col)
      do
        local _with_0 = self:addLine(col)
        _with_0:SetPoint('TOPLEFT', self.frame, 'TOPLEFT', x, 0)
        _with_0:SetWidth(1)
        _with_0:SetHeight(GetScreenHeight())
        return _with_0
      end
    end,
    addHLine = function(self, y, col)
      do
        local _with_0 = self:addLine(col)
        _with_0:SetPoint('BOTTOMLEFT', self.frame, 'BOTTOMLEFT', 0, y)
        _with_0:SetWidth(GetScreenWidth())
        _with_0:SetHeight(1)
        return _with_0
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      do
        local _with_0 = CreateFrame('Frame')
        _with_0:SetFrameStrata('BACKGROUND')
        _with_0:SetAllPoints(UIParent)
        _with_0:SetScript('OnUpdate', (function()
          local _base_1 = self
          local _fn_0 = _base_1.onUpdate
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
        self.frame = _with_0
      end
      self.rows, self.cols = { }, { }
      local xs, ys = self.frame:GetWidth() / COLS, self.frame:GetHeight() / ROWS
      for y = 1, ROWS do
        self.cols[y] = self:addHLine(y * ys, {
          0,
          0,
          0,
          .5
        })
      end
      for x = 1, COLS do
        self.rows[x] = self:addVLine(x * xs, {
          0,
          0,
          0,
          .5
        })
      end
      self.frame:Hide()
      self.visible = false
    end,
    __base = _base_0,
    __name = "Grid"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Grid = _class_0
end
local grid
SlashCmdList.BALIGN = function(msg, eb)
  grid = grid or Grid()
  return grid:toggle()
end
