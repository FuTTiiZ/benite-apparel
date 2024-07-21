import { Signal } from '@preact/signals-react'
import { MenuTab } from '@customTypes/types'

import styles from './NavBarItem.module.css'

interface NavBarItemProps {
  tabId: MenuTab
  title: string
  selected: boolean
  currentTab: Signal<MenuTab>
  disabled: boolean
}

const NavBarItem = ({ tabId, title, selected, currentTab, disabled }: NavBarItemProps) => {
  return (
    <button
      className={`${styles.item} ${selected && styles.selected} ${disabled && styles.disabled}`}
    >
      <h2
        className={styles.title}
        onClick={() => {
          if (disabled) return
          currentTab.value = tabId
        }}
      >{title}</h2>
      <div className={styles.separator} />
    </button>
  )
}

export default NavBarItem