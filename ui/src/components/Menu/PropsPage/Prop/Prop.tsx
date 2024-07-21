import { ActiveClothingProperty, CustomImage, Locale } from '@customTypes/types'
import { MenuData } from '@components/App'

import { Signal, effect } from '@preact/signals-react'
import { fetchNui } from '@utils/fetchNui'
import { isEnvBrowser } from '@utils/misc'

import RankSlider from './RankSlider/RankSlider'
import BadgeNumber from './BadgeNumber/BadgeNumber'
import BackPatch from './BackPatch/BackPatch'
import FrontPatch from './FrontPatch/FrontPatch'
import ColorPicker from './ColorPicker/ColorPicker'
import FootballName from './FootballName/FootballName'
import FootballNumber from './FootballNumber/FootballNumber'
import CustomImageComponent from './CustomImage/CustomImage'

import styles from './Prop.module.css'

interface PropProps extends ActiveClothingProperty {
  clothing: MenuData['clothing']
  primaryColor: Signal<string>
  locale: Locale
}

const Prop = ({
  id,
  type,
  label,
  value,
  clothing,
  primaryColor,
  locale,
}: PropProps) => {
  effect(() => {
    if (value.value === null) return

    if (id === 'primaryColor') primaryColor.value = value.value.toString()

    if (isEnvBrowser()) {
      console.log('Setting property value:', id, value.value)
      return
    }

    fetchNui('setPropertyValue', { id, value: value.value }).catch(() =>
      console.error('Error setting property value')
    )
  })

  return (
    <li className={styles.prop}>
      <h2>{label}</h2>
      {type === 'rank' && <RankSlider value={value as Signal<number>} />}
      {type === 'badgeNumber' && (
        <BadgeNumber value={value as Signal<string>} />
      )}
      {type === 'politiBack' && <BackPatch value={value as Signal<number>} />}
      {type === 'politiFront' && <FrontPatch value={value as Signal<number>} />}
      {type === 'color' && <ColorPicker value={value as Signal<string>} />}
      {type === 'footballName' && (
        <FootballName clothing={clothing} value={value as Signal<string>} />
      )}
      {type === 'footballNumber' && (
        <FootballNumber clothing={clothing} value={value as Signal<number>} />
      )}
      {type === 'customImage' && (
        <CustomImageComponent
          primaryColor={primaryColor.value}
          value={value as Signal<CustomImage>}
          locale={locale}
        />
      )}
    </li>
  )
}

export default Prop
