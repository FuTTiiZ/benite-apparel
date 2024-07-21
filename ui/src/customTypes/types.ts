import { Signal } from '@preact/signals-react'

export type MenuTab = 'clothing' | 'props'

export interface ClothingProperty {
  id: string
  label: string
  type:
    | 'rank'
    | 'badgeNumber'
    | 'politiBack'
    | 'politiFront'
    | 'color'
    | 'footballName'
    | 'footballNumber'
    | 'customImage'
}

export interface Locale {
  [key: string]: string
}

export interface ActiveClothingProperty extends ClothingProperty {
  value: Signal<number | string | CustomImage>
}

export interface ClothingArticle {
  id: string
  label: string
  componentId: number
  properties: ClothingProperty['id'][]
}

export interface ClothingCategory {
  id: number
  name: string
  label: string
}

export interface CustomImage {
  url: string | null
  offsetX: number
  offsetY: number
}
