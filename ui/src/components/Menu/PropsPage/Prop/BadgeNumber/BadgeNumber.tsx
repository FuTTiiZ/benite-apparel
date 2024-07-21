import { Signal } from '@preact/signals-react'

import styles from './BadgeNumber.module.css'

interface BadgeNumberProps {
  value: Signal<string>
}

const BadgeNumber = ({ value }: BadgeNumberProps) => {
  return (
    <div className={styles.badge}>
      <div className={styles.inner}>
        <input
          type="text"
          maxLength={5}
          defaultValue={value.value}
          onChange={e => value.value = e.target.value.toUpperCase().slice(0, 5)}
        />
      </div>
    </div>
  )
}

export default BadgeNumber