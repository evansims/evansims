import Head from "next/head";

import "tailwindcss/tailwind.css";

function MyApp({ Component, pageProps }) {
  return (
    <>
      <Head>
        <title>Evan Sims</title>

        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="robots" content="index,follow" />
        <meta
          name="description"
          content="Evan is a full stack engineer, designer, and founder from Lexington, Kentucky."
        />
        <meta name="keywords" content="" />
        <meta name="author" content="Evan Sims" />
        <link rel="canonical" href="https://evansims.com" />
        <meta name="copyright" content="2021" />
        <meta name="url" content="https://evansims.com" />

        <meta http-equiv="imagetoolbar" content="no" />
        <meta http-equiv="x-dns-prefetch-control" content="off" />

        <link rel="icon" href="/favicon.ico" />

        <body class="bg-gray-900 text-gray-400 font-sans font-base font-normal leading-relaxed" />
      </Head>

      <Component {...pageProps} />
    </>
  );
}

export default MyApp;
