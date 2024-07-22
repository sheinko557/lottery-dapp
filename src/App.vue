<template>
  <div class="bg-background min-h-screen">
    <AppBar />
    <main class="mx-auto max-w-screen-xl p-4 flex flex-col gap-4">
      <WalletConnect v-if="!isWalletConnected" />
      <Admin v-if="isWalletConnected && isAdmin" />
      <Home v-if="isWalletConnected" />
      <History v-if="isWalletConnected && history.length > 0" />
    </main>
  </div>
</template>

<script setup>
import { ref, computed, watch } from "vue";
import AppBar from "./components/AppBar.vue";
import Home from "./components/Home.vue";
import History from "./components/History.vue";
import WalletConnect from "./components/WalletConnect.vue";
import Admin from "./components/Admin.vue";
import { useWalletStore } from "./stores/walletStore";
import "vue3-toastify/dist/index.css";
import { toast } from "vue3-toastify";

const walletStore = useWalletStore();
const isWalletConnected = computed(() => walletStore.isWalletConnected);
const isAdmin = ref(false);
const history = ref([]);

const fetchContractData = async () => {
  try {
    // Check if user is admin
    isAdmin.value = await walletStore.contract.methods
      .isManager(walletStore.walletAddress)
      .call();

    // Fetch history from contract
    history.value = await walletStore.contract.methods.getHistory().call();
  } catch (error) {
    toast.error(`Failed to fetch contract data: ${error.message}`);
    console.error("Error fetching contract data:", error);
  }
};

watch(isWalletConnected, (isConnected) => {
  if (isConnected) {
    fetchContractData();
  }
});
</script>

<style scoped></style>
