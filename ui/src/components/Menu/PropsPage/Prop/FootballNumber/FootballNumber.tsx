import { Signal, computed } from '@preact/signals-react'

import { MenuData } from '@components/App'

import styles from './FootballNumber.module.css'
import { CSSProperties } from 'react'

interface FootballNumberProps {
  clothing: MenuData['clothing']
  value: Signal<number>
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

const FootballNumber = ({ value, clothing }: FootballNumberProps) => {
  const team = computed<string>(() => clothing['11'] || 'none' )

  return (
    <input
      type="text"
      maxLength={2}
      className={styles.number}
      defaultValue={value.value.toString()}
      onChange={e => {
        e.target.value = ((e.target.value || '').match(/\d*/g) || []).join('')
        value.value = parseInt(e.target.value)
      }}

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

export default FootballNumber