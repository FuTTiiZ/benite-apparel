//import React from 'react'
import { MenuData } from '@components/App'

import { effect, signal, Signal } from '@preact/signals-react'

import { fetchNui } from '@utils/fetchNui'
import { isEnvBrowser, roundTwoDecimals } from '@utils/misc'
import { useNuiEvent } from '@hooks/useNuiEvent'

import styles from './RotationControl.module.css'

interface RotationControlProps {
  characterRotation: Signal<MenuData['characterRotation']>
  locale: MenuData['locale']
}

const characterXCoord = signal<number>(0.2)
const dragged = signal<boolean>(false)

const sensitivity = 0.2
const RotationControl = ({
  characterRotation,
  locale,
}: RotationControlProps) => {
  effect(() => {
    if (isEnvBrowser()) return

    fetchNui('setCharacterRotation', {
      heading: roundTwoDecimals(characterRotation.value),
    }).catch(() => console.error('Error setting character rotation'))
  })

  useNuiEvent(
    'setCharacterCoords',
    ({ coords }: { coords: { x: number; y: number } }) => {
      characterXCoord.value = coords.x
    }
  )

  return (
    <div
      className={styles.rotation}
      style={{ transform: `translateX(${characterXCoord.value * 100}vw)` }}
      onMouseDown={(e) => {
        const field = e.target as HTMLDivElement
        const startX = e.clientX
        let startRotation = characterRotation.value

        document.onmousemove = (e) => {
          const delta =
            ((e.clientX - startX) / field.clientWidth) * 360 * sensitivity
          const rot = startRotation + delta

          characterRotation.value = rot < 0 ? 360 : rot % 360
          if (rot < 0) startRotation = characterRotation.value

          if (!dragged.value) dragged.value = true
        }

        document.onmouseup = () => (document.onmousemove = null)
      }}
    >
      <div
        className={styles.inner}
        style={{
          ...(dragged.value ? { opacity: 0 } : {}),
        }}
      >
        {locale.drag_to_rotate_character}
      </div>
    </div>
  )
}

export default RotationControl
