import { Signal } from '@preact/signals-react'

import { Locale, MenuTab } from '@customTypes/types'
import { MenuData } from '@components/App'

import ClothingPage from './ClothingPage/ClothingPage'
import PropsPage from './PropsPage/PropsPage'

import styles from './Menu.module.css'

interface MenuProps {
  currentTab: MenuTab
  categories: MenuData['categories']
  articles: MenuData['articles']
  clothing: Signal<MenuData['clothing']>
  properties: MenuData['properties']
  locale: Locale
}

const Menu = ({
  currentTab,
  categories,
  articles,
  clothing,
  properties,
  locale,
}: MenuProps) => {
  return (
    <div className={styles.menu}>
      {currentTab === 'clothing' && (
        <ClothingPage
          categories={categories}
          articles={articles}
          clothing={clothing}
          locale={locale}
        />
      )}
      {currentTab === 'props' && (
        <PropsPage
          properties={properties}
          clothing={clothing.value}
          locale={locale}
        />
      )}
    </div>
  )
}

export default Menu
