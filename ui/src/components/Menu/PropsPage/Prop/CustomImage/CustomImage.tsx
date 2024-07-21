import { CustomImage, Locale } from '@customTypes/types'
import { Signal } from '@preact/signals-react'

import CustomImageSrc from '/assets/img/custom.png'

import { CSSProperties } from 'react'
import styles from './CustomImage.module.css'

interface CustomImageProps {
  primaryColor: string
  value: Signal<CustomImage>
  locale: Locale
}

const CustomImageComponent = ({
  primaryColor,
  value,
  locale,
}: CustomImageProps) => {
  return (
    <div className={styles.print}>
      <input
        type="text"
        placeholder={locale.image_url || ''}
        onChange={({ target }) => {
          try {
            const url = new URL(target.value)
            value.value = { ...value.value, url: url.toString() }
          } catch (error) {
            value.value = {
              ...value.value,
              url: null,
            }
          }
        }}
      />
      <input
        type="range"
        min={-1}
        max={1}
        step={0.02}
        defaultValue={0}
        className={styles.vertical}
        style={{ '--content': `'${locale.vertical_offset}'` } as CSSProperties}
        onChange={({ target }) => {
          value.value = { ...value.value, offsetY: parseFloat(target.value) }
        }}
      />
      <div className={styles.preview} style={{ backgroundColor: primaryColor }}>
        <img
          src={value.value.url || CustomImageSrc}
          alt="Image Preview"
          style={{
            transform: `translate(${value.value.offsetX * 20}%, ${
              value.value.offsetY * 20
            }%)`,
          }}
        />
      </div>
      <input
        type="range"
        min={-1}
        max={1}
        step={0.02}
        defaultValue={0}
        className={styles.horizontal}
        style={
          { '--content': `'${locale.horizontal_offset}'` } as CSSProperties
        }
        onChange={({ target }) => {
          value.value = { ...value.value, offsetX: parseFloat(target.value) }
        }}
      />
    </div>
  )
}

export default CustomImageComponent
