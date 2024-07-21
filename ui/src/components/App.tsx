import { useEffect, useState } from 'react'

import {
  MenuTab,
  ClothingCategory,
  ClothingArticle,
  ClothingProperty,
  Locale,
} from '@customTypes/types'

import { signal, computed, effect } from '@preact/signals-react'

import { fetchNui } from '@utils/fetchNui'
import { useNuiEvent } from '@hooks/useNuiEvent'
import { isEnvBrowser } from '@utils/misc'
if (isEnvBrowser()) document.body.style.background = 'rgb(30 23 23)'

import NavBar from './NavBar/NavBar'
import Menu from './Menu/Menu'
import CameraControl from './CameraControl/CameraControls'

import beniteLogo from '@assets/img/benite.png'
import styles from './App.module.css'

import { debugData } from '@utils/debugData'

debugData([
  {
    action: 'openMenu',
    data: {
      categories: [
        { id: 11, name: 'jbib', label: 'Trøjer' },
        { id: 9, name: 'task', label: 'Skudsikre Veste' },
        { id: 8, name: 'accs', label: 'Tilbehør' },
      ],
      articles: [
        {
          id: 'shirt',
          label: 'Kortærmet skjorte',
          componentId: 11,
          properties: ['rank'],
        },
        {
          id: 'knit',
          label: 'Striktrøje',
          componentId: 11,
          properties: ['rank'],
        },
        {
          id: 'lvest',
          label: 'Letvest',
          componentId: 9,
          properties: ['badgeNumber', 'politiBack', 'politiFront'],
        },
        {
          id: 'lvestnote',
          label: 'Letvest m. Notesblok',
          componentId: 9,
          properties: [
            'badgeNumber',
            'politiBack',
            'politiFront',
            'bookColor',
            'penColor',
          ],
        },
        {
          id: 'bif',
          label: 'Brøndby Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'fck',
          label: 'FCK Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'ob',
          label: 'OB Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'aab',
          label: 'AAB Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'fcm',
          label: 'FC Midtjylland Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'ach',
          label: 'AC Horsens Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'vff',
          label: 'Viborg FF Trøje',
          componentId: 11,
          properties: ['footballName', 'footballNumber'],
        },
        {
          id: 'customshirt',
          label: 'Custom Trøje',
          componentId: 11,
          properties: ['primaryColor', 'printFront', 'printBack'],
        },
        {
          id: 'customvest',
          label: 'Custom Vest',
          componentId: 8,
          properties: ['primaryColor', 'printFront', 'printBack'],
        },
      ],
      clothing: {
        '11': 'customshirt',
      },
      characterRotation: 90.0,
      locale: {
        tab_title_clothing: 'Beklædning',
        tab_title_properties: 'Detaljer',
        drag_to_rotate_character: 'Træk for at dreje din karakter',
        server_has_no_compatible_clothing:
          'Det ser ikke ud til, at serveren har noget kompatibelt tøj',
        property_jersey_player_name: 'Navn',
        property_jersey_player_number: 'Nummer',
        property_badge_number: 'Markeringsnummer',
        property_police_rank: 'Charge',
        property_police_back: 'Ryglogo',
        property_police_front: 'Frontlogo',
        property_book_color: 'Bogfarve',
        property_pen_color: 'Kuglepensfarve',
        property_primary_color: 'Primær Farve',
        property_print_front: 'Front Print',
        property_print_back: 'Ryg Print',
        image_url: 'Billede URL',
        horizontal_offset: 'Vandret Offset',
        vertical_offset: 'Lodret Offset',
      },
    },
  },
])

export interface MenuData {
  categories: ClothingCategory[]
  articles: ClothingArticle[]
  clothing: Record<number, string>
  properties: ClothingProperty['id'][]
  characterRotation: number
  locale: Locale
}

interface RawMenuData extends MenuData {
  clothing: Record<string, string>
}

const currentTab = signal<MenuTab>('props')
const categories = signal<MenuData['categories']>([])
const articles = signal<MenuData['articles']>([])
const clothing = signal<MenuData['clothing']>({})
const characterRotation = signal<MenuData['characterRotation']>(0.0)
const locale = signal<Locale>({})

const App = () => {
  const [menuOpen, setMenuOpen] = useState(false)
  useNuiEvent('openMenu', (data: RawMenuData) => {
    const clothes: MenuData['clothing'] = {}
    for (const [componentId, drawableId] of Object.entries(data.clothing)) {
      clothes[parseInt(componentId)] = drawableId
    }
    clothing.value = clothes

    categories.value = data.categories
    articles.value = data.articles
    characterRotation.value = data.characterRotation

    if (data?.locale) locale.value = data.locale

    setMenuOpen(true)
  })

  useEffect(() => {
    if (!menuOpen) return

    const keyHandler = (e: KeyboardEvent) => {
      if (!['Escape'].includes(e.code)) return
      fetchNui('closeMenu').catch(() => console.error('Error closing menu'))

      setMenuOpen(false)
    }

    window.addEventListener('keydown', keyHandler)
    return () => window.removeEventListener('keydown', keyHandler)
  }, [menuOpen])

  if (!menuOpen)
    return isEnvBrowser() ? (
      <button onClick={() => setMenuOpen(true)}>Åben Menu</button>
    ) : null

  const properties = computed<MenuData['properties']>(() => [
    ...new Set(
      articles.value
        .filter((v) => clothing.value[v.componentId] === v.id)
        .map((v) => v.properties)
        .flat()
    ),
  ])

  effect(() => {
    if (properties.value.length === 0) currentTab.value = 'clothing'
  })

  return (
    <main className={styles.wrapper}>
      <div className={styles.title}>
        <img src={beniteLogo} alt="benite" draggable={false} />
      </div>

      <div className={styles.panel}>
        <CameraControl
          characterRotation={characterRotation}
          locale={locale.value}
        />
      </div>

      <div className={styles.panel}>
        <NavBar
          currentTab={currentTab}
          properties={properties.value}
          locale={locale.value}
        />

        <Menu
          currentTab={currentTab.value}
          categories={categories.value}
          articles={articles.value}
          clothing={clothing}
          properties={properties.value}
          locale={locale.value}
        />
      </div>
    </main>
  )
}

export default App
