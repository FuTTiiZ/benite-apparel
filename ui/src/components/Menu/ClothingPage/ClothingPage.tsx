import { Signal } from '@preact/signals-react'
import { MenuData } from '@components/App'

import Article from './Article/Article'

//import loading from '@assets/img/loading.svg'
import frown from '@assets/img/frown.svg'

import styles from './ClothingPage.module.css'

interface ClothingPageProps {
  categories: MenuData['categories']
  articles: MenuData['articles']
  clothing: Signal<MenuData['clothing']>
  locale: MenuData['locale']
}

const ClothingPage = ({
  categories,
  articles,
  clothing,
  locale,
}: ClothingPageProps) => {
  return categories.length > 0 ? (
    <>
      {categories.map(({ id, name, label }) => (
        <div key={name} className={styles.category}>
          <h2>{label}</h2>
          <ul className={styles.articles}>
            {articles
              .filter((a) => a.componentId === id)
              .map((article, idx) => (
                <Article
                  key={article.id}
                  {...article}
                  equipped={clothing.value[article.componentId] === article.id}
                  clothing={clothing}
                  idx={idx}
                />
              ))}
          </ul>
        </div>
      ))}
    </>
  ) : (
    <div className={styles.loader}>
      <p>{locale.server_has_no_compatible_clothing}</p>
      <img src={frown} alt=":(" />
    </div>
  )
}

export default ClothingPage
