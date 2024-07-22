<template>
  <nav class="bg-card w-full shadow-md">
    <div class="max-w-screen-xl mx-auto flex items-center justify-between p-4">
      <div class="flex items-center space-x-3 rtl:space-x-reverse">
        <span class="text-2xl font-semibold text-title whitespace-nowrap">
          Lottery
        </span>
      </div>
      <div class="flex md:order-2 space-x-3 md:space-x-0 rtl:space-x-reverse">
        <div
          v-if="isWalletConnected"
                    @click="copyToClipboard"
          class="text-white bg-btn hover:bg-btn1 focus:outline-none font-medium rounded-lg text-sm px-4 py-2 cursor-pointer"
          :aria-label="walletAddress"
        >
          {{ formattedAddress }}
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed } from "vue";
import { useWalletStore } from "../stores/walletStore";
import { getAddress } from "../utils/string";
import { toast } from "vue3-toastify";

const walletStore = useWalletStore();

const isWalletConnected = computed(() => walletStore.isWalletConnected);
const walletAddress = computed(() => walletStore.walletAddress);

// Computed property to format or truncate wallet address
const formattedAddress = computed(() => {
  return isWalletConnected.value
    ? getAddress(walletAddress.value)
    : "Connect Wallet";
});
const copyToClipboard = () => {
  if (walletAddress.value) {
    navigator.clipboard.writeText(walletAddress.value).then(() => {
      toast.success("Wallet address copied to clipboard");
    }).catch(err => {
      console.error("Failed to copy wallet address:", err);
    });
  }
};

</script>
