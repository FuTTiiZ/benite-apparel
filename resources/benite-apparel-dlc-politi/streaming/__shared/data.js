const RESOURCE_NAME = document.location.host.slice(8, 22)

const POLITI_RANK_FILES = [
  'Dansk_Politikadet',
  'Dansk_Politibetjent',
  'Dansk_Politiassistent_1',
  'Dansk_Politiassistent_2',
  'Dansk_Politikommissaer',
  'Dansk_Vicepolitiinspektor',
  'Dansk_Politiinspektor',
  'Dansk_Chefpolitiinspektor',
  'Dansk_Politidirektor',
  'Dansk_Rigspolitichef'
]

const POLITI_PATCH_FILES = {
  front: [
    'Patch_Gul',
    'Patch_Hvid'
  ],
  back : [
    'Patch_Back_Gul',
    'Patch_Back_Hvid'
  ]
}