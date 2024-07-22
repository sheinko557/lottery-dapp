/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx,vue}"],
  theme: {
    extend: {
      colors: {
        background: "#121212",
        title: "#D8D8D8",
        text: "#9D9D9D",
        card: "#1E1E1E",
        btn: "#C38FFF",
        btn1: "#A98DFF",
      },
    },
  },
  plugins: [],
};
