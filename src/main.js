import { createApp } from "vue";
import "./style.css";

import { createPinia } from "pinia";
import Vue3Toastify from "vue3-toastify";

import App from "./App.vue";
const pinia = createPinia();

createApp(App).use(pinia).use(Vue3Toastify, { autoClose: 3000 }).mount("#app");
