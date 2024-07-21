import { CSSProperties } from 'react'
import { Signal } from '@preact/signals-react'

import styles from './FrontPatch.module.css'

interface FrontPatchProps {
  value: Signal<number>
}


const images = [
  'assets/img/patches/politi_front_yellow.png',
  'assets/img/patches/politi_front_grey.png'
]

const FrontPatch = ({ value }: FrontPatchProps) => {
  return (
    <div className={styles.patch} style={(value.value === 0 ? {
      '--theme': '#bac60769',
      '--accent': '#141414'
    } : {
      '--theme': '#141414',
      '--accent': '#bac60769'
    }) as CSSProperties}>
      <div
        className={styles.images}
        onClick={e => {
          value.value = (1 + value.value) % 2
          
          const target = e.target as HTMLElement
          target.classList.add(styles['just-changed'])
        }}
        onMouseLeave={e => 
          (e.target as HTMLElement).classList.remove(styles['just-changed'])
        }
      >
        <img src={images[value.value]} alt="POLITI Gul" draggable={false} />
        <img src={images[(1 + value.value) % 2]} alt="POLITI Grå" draggable={false} />
      </div>
    </div>
  )
}

export default FrontPatch