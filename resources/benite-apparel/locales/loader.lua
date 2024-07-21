local resourceName<const> = GetCurrentResourceName()

local locale<const> = GetResourceMetadata(resourceName, 'language', 0) or 'en-US'
Locale = json.decode(LoadResourceFile(resourceName, 'locales/'.. locale ..'.json'))