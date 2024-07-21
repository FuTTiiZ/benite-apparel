//import React from 'react'
import { MenuData } from '@components/App'
import { Signal } from '@preact/signals-react'

import RotationControl from './RotationControl/RotationControl'

import styles from './CameraControls.module.css'

interface CameraControlProps {
  characterRotation: Signal<MenuData['characterRotation']>
  locale: MenuData['locale']
}

const CameraControl = ({ characterRotation, locale }: CameraControlProps) => {
  return (
    <div className={styles.controls}>
      <RotationControl characterRotation={characterRotation} locale={locale} />
    </div>
  )
}

export default CameraControl
