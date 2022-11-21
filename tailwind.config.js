module.exports = {
  content: ["./pages/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        gray: {
          50: "#fafafa",
          100: "#f5f5f5",
          200: "#eeeeee",
          300: "#e0e0e0",
          400: "#bdbdbd",
          500: "#9e9e9e",
          600: "#757575",
          700: "#616161",
          800: "#424242",
          900: "#212121",
          trans: "rgba(250, 250, 250, 0.5)",
          transLight: "rgba(250, 250, 250, 0.1)",
          transDark: "rgba(100, 100, 100, 0.2)",
        },
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
