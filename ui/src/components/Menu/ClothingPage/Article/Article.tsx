import { Signal } from '@preact/signals-react'
import { MenuData } from '@components/App'

import { fetchNui } from '@utils/fetchNui'

import { ClothingArticle } from '@customTypes/types'

import styles from './Article.module.css'

interface ClothingArticleProps extends ClothingArticle {
  idx: number
  equipped: boolean,
  clothing: Signal<MenuData['clothing']>
}

const Article = ({ id, label, componentId, equipped, clothing, idx }: ClothingArticleProps) => {
  return (
    <li 
      style={{ '--idx': idx+1 } as React.CSSProperties}
      className={`${styles.article} ${equipped && styles.equipped}`}
      onClick={() => {
        if (equipped) return

        clothing.value = { ...clothing.value, [componentId]: id }
        fetchNui('applyDrawable', { id: id })
          .catch(() => console.error('Error applying drawable'))
      }}
    >
      <div style={{ overflow: 'hidden' }}>
        <img src={`assets/img/articles/${id}.png`} alt={`${id}.png`} draggable={false} />
      </div>
      <div style={{ width: '100%', bottom: '5px' }}>
        <h3>{label}</h3>
      </div>
    </li>
  )
}

export default Article