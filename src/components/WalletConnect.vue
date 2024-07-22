<template>
  <div
    v-if="!isWalletConnected"
    class="bg-card rounded-lg shadow-md p-4 text-text text-center"
  >
    <h2 class="text-xl font-semibold text-title mb-4">Connect Your Wallet</h2>
    <p class="text-sm text-gray-500 dark:text-gray-400 mb-4">
      Please connect your wallet to access the lottery features.
    </p>
    <!-- Show this message if MetaMask is not installed -->
    <p v-if="!isMetaMaskInstalled" class="text-sm text-red-500 mb-4">
      MetaMask is not installed. Please install MetaMask to continue.
    </p>
    <!-- Show this message while connecting -->
    <p v-if="loading" class="text-sm text-gray-500 mb-4">
      Connecting to MetaMask...
    </p>
    <!-- Connect Wallet button -->
    <button
      type="button"
      @click="connectWallet"
      :disabled="!isMetaMaskInstalled || loading"
      class="text-white bg-btn hover:bg-btn1 focus:outline-none font-medium rounded-lg text-sm px-4 py-2 cursor-pointer"
    >
      Connect Wallet
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from "vue";
import Web3 from "web3";
import { abi } from "../utils/abi";
import { toast } from "vue3-toastify";
import { useWalletStore } from "../stores/walletStore";

const walletStore = useWalletStore();
const isMetaMaskInstalled = ref(false);
const loading = ref(false);
const isWalletConnected = computed(() => walletStore.isWalletConnected);

// Check if MetaMask is installed
const checkMetaMaskInstallation = () => {
  isMetaMaskInstalled.value = window.ethereum && window.ethereum.isMetaMask;
};

// Function to connect to MetaMask wallet
const connectWallet = async () => {
  if (!isMetaMaskInstalled.value) {
    toast.error(
      "MetaMask is not installed. Please install MetaMask to continue."
    );
    console.error("MetaMask is not installed.");
    return;
  }

  loading.value = true;
  const web3 = new Web3(window.ethereum || window.web3.currentProvider);

  walletStore.setProvider(web3);
  try {
    const accounts = await walletStore.provider.eth.requestAccounts();
    walletStore.setWalletAddress(accounts[0]);
    const contract = new web3.eth.Contract(abi, walletStore.contractAddress);
    walletStore.setContract(contract);
    toast.success("Wallet connected successfully!");
  } catch (error) {
    toast.error(`Failed to connect wallet: ${error.message}`);
    console.error("Failed to connect wallet:", error);
  } finally {
    loading.value = false;
  }
};

const handleAccountsChanged = (accounts) => {
  if (accounts.length === 0) {
    // No accounts available, user has disconnected
    walletStore.setWalletAddress(null);
    walletStore.setProvider(null);
    walletStore.setContract(null);
    toast.info("Wallet disconnected.");
  } else {
    // Account changed, update wallet address
    walletStore.setWalletAddress(accounts[0]);
  }
};
// Watch for wallet connection changes
watch(isWalletConnected, (connected) => {
  if (connected) {
    // Listen for MetaMask account changes
    if (window.ethereum) {
      window.ethereum.on("accountsChanged", handleAccountsChanged);
    }
  } else {
    // Clean up event listener
    if (window.ethereum) {
      window.ethereum.removeListener("accountsChanged", handleAccountsChanged);
    }
  }
});
// Check MetaMask installation status when component mounts
onMounted(() => {
  checkMetaMaskInstallation();
  if (isWalletConnected.value && window.ethereum) {
    window.ethereum.on("accountsChanged", handleAccountsChanged);
  }
});
</script>
