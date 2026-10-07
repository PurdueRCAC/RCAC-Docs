whatis([[Name : Mathematica]])
whatis([[Version : 15.0]])
whatis([[Short description : Mathematica (Wolfram Language and other tools) provide
a language, software system for technical computing in R&D and education, and computer algebra system.]])

local version      = '15.0'
local app          = 'mathematica'
local contact      = 'carls113'
local license_type = 'proprietary'
local modroot      = '/apps/external/mathematica/' .. version

prepend_path('PATH', modroot .. '/bin')
