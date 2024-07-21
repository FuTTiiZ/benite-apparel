if ResourceName ~= 'benite-apparel' then
  Log(1, 'Error: Resource has been renamed!')
  Log(1, '  Benite Apparel WILL NOT work properly')
  Log(1, '  This resource must be named "benite-apparel"')
end

GameBuild = GetGameBuildNumber() == 0 and GetConvarInt('sv_enforceGameBuild', GetGameBuildNumber()) or GetGameBuildNumber()
if GameBuild == 0 then
  Log(1, 'Error: Unable to get game build!')
  Log(1, '  Benite Apparel WILL NOT work properly')
  Log(1, '  Make sure, you are specifying a game version with sv_enforceGameBuild')
end