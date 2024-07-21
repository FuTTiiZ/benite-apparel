import { Signal } from '@preact/signals-react'
import { MenuTab } from '@customTypes/types'

import NavBarItem from './NavBarItem/NavBarItem'

import styles from './NavBar.module.css'
import { MenuData } from '@components/App'

interface TabData {
  tabId: MenuTab
  title: string
}

const tabs: TabData[] = [
  { tabId: 'clothing', title: 'tab_title_clothing' },
  { tabId: 'props', title: 'tab_title_properties' },
]

interface NavBarProps {
  currentTab: Signal<MenuTab>
  properties: MenuData['properties']
  locale: MenuData['locale']
}

const NavBar = ({ currentTab, properties, locale }: NavBarProps) => {
  return (
    <nav className={styles.navbar}>
      {tabs.map((v) => (
        <NavBarItem
          key={v.tabId}
          tabId={v.tabId}
          title={locale[v.title]}
          selected={v.tabId === currentTab.value}
          currentTab={currentTab}
          disabled={v.tabId === 'props' && properties.length === 0}
        />
      ))}
    </nav>
  )
}

export default NavBar
