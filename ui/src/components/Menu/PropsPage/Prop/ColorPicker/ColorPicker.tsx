import { CSSProperties } from 'react'
import { Signal } from '@preact/signals-react'

import styles from './ColorPicker.module.css'

interface ColorPickerProps {
  value: Signal<string>
}

const ColorPicker = ({ value }: ColorPickerProps) => {
  return (
    <div className={styles.picker} style={{ '--accent': value.value } as CSSProperties} >
      <input
        className={styles.color}
        type="color"
        defaultValue={value.value}
        onChange={e => value.value = e.target.value}
      />
    </div>
  )
}

export default ColorPicker