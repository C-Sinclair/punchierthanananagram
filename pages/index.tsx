import Head from 'next/head'
import firebase from 'firebase/app'
import "firebase/functions"
import init from '../util/firebase/firebase'

init()

const Home = props => {
  console.log("props", props)
  return (
    <div className="container">
      <Head>
        <title>PunchierThanAnAnagram</title>
        <link rel="stylesheet" href="/mvp.css" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main>
        {/* { videos.map((video, index) => (
          <div key={index}>{video}</div>
        ))} */}
      </main>

      <footer>
        <p>Hi Joe</p>
      </footer>
    </div>
  )
}

Home.getInitialProps = async function() {
  const getData = firebase.functions().httpsCallable("getData")
  const result = await getData({})
  return { result: result.data.data }
}

export default Home