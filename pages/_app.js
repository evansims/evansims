import Head from "next/head";

import "tailwindcss/tailwind.css";

function MyApp({ Component, pageProps }) {
  return (
    <>
      <Head>
        <title>Evan Sims</title>
        <link rel="icon" href="/favicon.ico" />

        <body class="bg-gray-900 text-gray-400 font-sans font-base font-normal leading-relaxed" />
      </Head>

      <Component {...pageProps} />
    </>
  );
}

export default MyApp;
