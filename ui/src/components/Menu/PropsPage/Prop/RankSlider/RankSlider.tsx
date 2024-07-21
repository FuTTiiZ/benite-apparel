import { Signal } from '@preact/signals-react'

import forward from '@assets/img/forward.svg'
import back from '@assets/img/back.svg'

import styles from './RankSlider.module.css'

interface RankSliderProps {
  value: Signal<number>
}

const ranks = [
  { value: 0, image: 'assets/img/ranks/Dansk_Politikadet.svg' },
  { value: 1, image: 'assets/img/ranks/Dansk_Politibetjent.svg' },
  { value: 2, image: 'assets/img/ranks/Dansk_Politiassistent_1.svg' },
  { value: 3, image: 'assets/img/ranks/Dansk_Politiassistent_2.svg' },
  { value: 4, image: 'assets/img/ranks/Dansk_Politikommissaer.svg' },
  { value: 5, image: 'assets/img/ranks/Dansk_Vicepolitiinspektor.svg' },
  { value: 6, image: 'assets/img/ranks/Dansk_Politiinspektor.svg' },
  { value: 7, image: 'assets/img/ranks/Dansk_Chefpolitiinspektor.svg' },
  { value: 8, image: 'assets/img/ranks/Dansk_Politidirektor.svg' },
  { value: 9, image: 'assets/img/ranks/Dansk_Rigspolitichef.svg' }
]

const RankSlider = ({ value }: RankSliderProps) => {
  return (
    <div className={styles.slider}>
      <div className={styles.images} style={{ ...(value.value === 9 ? { height: '273px' } : {}) }}>
        { ranks.map(r => <img key={r.value} src={r.image} style={{ '--idx': r.value + value.value * -1 } as React.CSSProperties} draggable={false} />) }
      </div>
      <div className={styles.controls}>
        { value.value > ranks[0].value ? <button onClick={() => value.value--}><img src={back} alt="tilbage" draggable={false} /></button> : <div/> }
        { value.value < ranks.slice(-1)[0].value ? <button onClick={() => value.value++}><img src={forward} alt="frem" draggable={false} /></button> : <div/> }
      </div>
    </div>
  )
}

export default RankSlider