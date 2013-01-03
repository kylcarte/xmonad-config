
module My.Decor
  ( normal
  , urgent
  , focused
  , borders
  , myXPConfig
  , myDzenPP
  , mySMConfig
  , myFont
  , myBorderWidth
  , dzenColor
  , ColorScheme(..)
  ) where

import XMonad.Prompt
import XMonad.Hooks.DynamicLog

import My.NamedSubmap

import Data.Word (Word32)
import System.IO (hPutStrLn)

myBorderWidth :: Word32
myBorderWidth = 1
myFont        = "-*-terminus-medium-r-normal-*-12-*-*-*-*-*-*-*"
--myFont        = "Droid Sans Mono:size=8"

normal  = CS { fg = "#ffffff" , bg = "#000000" }
urgent  = CS { fg = "#ffffff" , bg = "#ff0000" }
focused = CS { fg = "#f0f0f0" , bg = "#333333" }
borders = CS { fg = "#433ffe" , bg = "#010062" }

myDzenPP hs = myMod defaultPP
 where
    myMod pp = pp
      { ppCurrent = clickWS (dzenColor "lightgreen" "" . ppCurrent pp)
      , ppVisible = clickWS (ppVisible pp)
      , ppHidden = clickWS (dzenColor "gray" "" . ppHidden pp)
      , ppOutput = sequence_ . mapM hPutStrLn hs
      , ppUrgent = clickWS (dzenColor (fg urgent) (bg urgent) . ppUrgent pp)
      }

goToWS ws = "xdotool key 'super+" ++ ws ++ "'"
clickable c s = "^ca(1," ++ c ++ ")" ++ s ++ "^ca()"
clickWS f ws = case ws of
  "M" -> clickable "xdotool key 'super+shift+m'" $ f ws
  _   -> clickable (goToWS ws) $ f ws

myXPConfig = defaultXPConfig
  { font = myFont
  , bgColor = bg normal
  , fgColor = fg normal
  , fgHLight = fg focused
  , bgHLight = bg focused
  , borderColor = fg borders
  , promptBorderWidth = 1
  , historySize = 100
  }

mySMConfig = defaultSMConfig
  { gap = 50
  , fontWidth = 6.5
  , dzenFont  = Just myFont
  }

data ColorScheme = CS
  { fg :: String
  , bg :: String
  }

