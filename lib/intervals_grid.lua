-- Isomorphic grid interface adapted from intervals.lua (iii) for norns grid API.
-- Column 1: velocity (row 1 = loudest, row 8 = quietest)
-- Columns 2-16: 5-semitone-per-row isomorphic layout, range G2-G#6
--
-- Usage:
--   local IntervalsGrid = include "mi-eng/lib/intervals_grid"
--   IntervalsGrid.init(note_on_cb, note_off_cb)
--     note_on_cb(note, vel)  called on key press
--     note_off_cb()          called when all keys released

local g = grid.connect()
local held = {}
local vel_idx = 4
local velocities = {127, 112, 96, 80, 64, 32, 16, 1}
local display = {[0]=9, 0, 4, 0, 4, 4, 0, 4, 0, 4, 0, 4}

local function grid_note(x, y) return x + y * 5 + 36 end

local function grid_redraw()
  g:all(0)
  for y = 1, 8 do
    for x = 2, 16 do
      g:led(x, 9-y, display[grid_note(x, y) % 12])
    end
  end
  for x, row in pairs(held) do
    for y, _ in pairs(row) do g:led(x, y, 15) end
  end
  g:led(1, vel_idx, 15)
  g:refresh()
end

local IntervalsGrid = {}

function IntervalsGrid.init(note_on, note_off)
  g.key = function(x, y, z)
    if x == 1 then
      if z == 1 then
        vel_idx = y
        grid_redraw()
      end
    else
      local n = grid_note(x, 9-y)
      if z == 1 then
        held[x] = held[x] or {}
        held[x][y] = true
        note_on(n, velocities[vel_idx])
      else
        if held[x] then
          held[x][y] = nil
          if not next(held[x]) then held[x] = nil end
        end
        if not next(held) then note_off() end
      end
      grid_redraw()
    end
  end
  grid_redraw()
end

return IntervalsGrid
