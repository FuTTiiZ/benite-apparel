import { MenuData } from '@components/App'
import {
  ClothingProperty,
  ActiveClothingProperty,
  Locale,
  CustomImage,
} from '@customTypes/types'

import { computed, signal } from '@preact/signals-react'

import Prop from './Prop/Prop'

import CustomImageSrc from '/assets/img/custom.png'

import styles from './PropsPage.module.css'

interface PropsPageProps {
  properties: MenuData['properties']
  clothing: MenuData['clothing']
  locale: Locale
}

const clothingProperties: Record<
  ClothingProperty['id'],
  ActiveClothingProperty
> = {
  footballName: {
    id: 'footballName',
    type: 'footballName',
    label: 'property_jersey_player_name',
    value: signal<string>('Benite'),
  },
  footballNumber: {
    id: 'footballNumber',
    type: 'footballNumber',
    label: 'property_jersey_player_number',
    value: signal<number>(10),
  },
  rank: {
    id: 'rank',
    type: 'rank',
    label: 'property_police_rank',
    value: signal<number>(0),
  },
  badgeNumber: {
    id: 'badgeNumber',
    type: 'badgeNumber',
    label: 'property_badge_number',
    value: signal<string>('A0000'),
  },
  politiBack: {
    id: 'politiBack',
    type: 'politiBack',
    label: 'property_police_back',
    value: signal<number>(0),
  },
  politiFront: {
    id: 'politiFront',
    type: 'politiFront',
    label: 'property_police_front',
    value: signal<number>(0),
  },
  bookColor: {
    id: 'bookColor',
    type: 'color',
    label: 'property_book_color',
    value: signal<string>('#941010'),
  },
  penColor: {
    id: 'penColor',
    type: 'color',
    label: 'property_pen_color',
    value: signal<string>('#101094'),
  },
  primaryColor: {
    id: 'primaryColor',
    type: 'color',
    label: 'property_primary_color',
    value: signal<string>('#121212'),
  },
  printFront: {
    id: 'printFront',
    type: 'customImage',
    label: 'property_print_front',
    value: signal<CustomImage>({
      url: CustomImageSrc,
      offsetX: 0,
      offsetY: 0,
    }),
  },
  printBack: {
    id: 'printBack',
    type: 'customImage',
    label: 'property_print_back',
    value: signal<CustomImage>({
      url: CustomImageSrc,
      offsetX: 0,
      offsetY: 0,
    }),
  },
}

const primaryColor = signal<string>('#121212')

const createPropComponent = (
  id: ClothingProperty['id'],
  clothing: MenuData['clothing'],
  locale: Locale
) => {
  const property = clothingProperties[id]
  return (
    <Prop
      key={id}
      id={id}
      type={property.type}
      label={locale[property.label]}
      value={property.value}
      clothing={clothing}
      primaryColor={primaryColor}
      locale={locale}
    />
  )
}

const PropsPage = ({ properties, clothing, locale }: PropsPageProps) => {
  // This is done to ensure the correct order
  const activeProperties = computed(() =>
    Object.keys(clothingProperties).filter((propertyId) =>
      properties.includes(propertyId)
    )
  )

  return (
    <div className={styles.list}>
      <ul>
        {activeProperties.value
          .filter((_, i) => i % 2 === 0)
          .map((p) => createPropComponent(p, clothing, locale))}
      </ul>
      <ul>
        {activeProperties.value
          .filter((_, i) => i % 2 === 1)
          .map((p) => createPropComponent(p, clothing, locale))}
      </ul>
    </div>
  )
}

export default PropsPage
