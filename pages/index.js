import Head from 'next/head'
import fetch from 'node-fetch'

const Home = ({ videos }) => {
  
  return (
    <div className="container">
      <Head>
        <title>PunchierThanAnAnagram</title>
        <link rel="stylesheet" href="/mvp.css" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        { videos.map((video, index) => (
          <div key={index}>{video}</div>
        ))}
      </main>

      <footer>
        <p>Hi Joe</p>
      </footer>
    </div>
  )
}

export const getStaticProps = async () => {
  const res = await fetch('/api/videos')
  const json = await res.json()
  return { 
    props: {
      videos: json 
    }
  }
}

export default Home