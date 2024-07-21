import { Signal, computed } from '@preact/signals-react'

import { MenuData } from '@components/App'

import styles from './FootballName.module.css'
import { CSSProperties } from 'react'

interface FootballNameProps {
  clothing: MenuData['clothing']
  value: Signal<string>
}

const teamColors: Record<string, string[]> = {
  ach: ['#292821', '#FFEB55'],
  bif: ['#1052A0', '#F8F800'],
  fck: ['#0E316B', '#F2F2F2'],
  fcm: ['#AC0000', '#171717'],
  ob:  ['#004EA6', '#FDFDFD'],
  vff: ['#EDEDED', '#007F5E'],
  aab: ['#EEEEEE', '#E10428'],
  none: ['#FFFFFF', 'transparent']
}

const FootballName = ({ value, clothing }: FootballNameProps) => {
  const team = computed<string>(() => clothing['11'] || 'none' )

  return (
    <input
      type="text"
      maxLength={12}
      className={styles.name}
      defaultValue={value.value}
      onChange={e => value.value = e.target.value.toUpperCase().slice(0, 12)}

      style={{
        '--color': teamColors[team.value][0],
        '--color2': teamColors[team.value][1],
        textShadow: `0 0 25px ${teamColors[team.value][0]}69`,
        boxShadow: `
          0 0 60px ${teamColors[team.value][1]} inset,
          0 0 10px 2px ${teamColors[team.value][0]} inset,
          0 -10px 10px -10px ${teamColors[team.value][0]}69,
          0 10px 10px -10px ${teamColors[team.value][0]}69
        `
      } as CSSProperties}

    />
  )
}

export default FootballName