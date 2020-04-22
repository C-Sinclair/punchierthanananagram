import Head from 'next/head'
import fetch from 'isomorphic-unfetch'
import '../public/mvp.css'

const Home = ({ videos }) => {

  return (
    <div className="container">
      <Head>
        <title>PunchierThanAnAnagram</title>
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

Home.getInitialProps = async ctx => {
  const res = await fetch(`/api/videos`)
  const json = await res.json()
  return { videos: json }
}

export default Home