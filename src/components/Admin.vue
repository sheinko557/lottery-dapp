<template>
  <section class="flex flex-col space-y-4">
    <span class="text-2xl font-semibold text-title">Manager</span>
    <div class="bg-card rounded-lg shadow-md p-4 text-text flex justify-around">
      <button
        type="button"
        @click="startRound"
        :disabled="loading"
        class="text-white bg-btn hover:bg-btn1 focus:outline-none font-medium rounded-lg text-sm px-4 py-2 cursor-pointer"
      >
        Start Round
      </button>
      <button
        type="button"
        @click="endRound"
        :disabled="loading"
        class="text-white bg-btn hover:bg-btn1 focus:outline-none font-medium rounded-lg text-sm px-4 py-2 cursor-pointer"
      >
        End Round
      </button>
      <button
        type="button"
        @click="pickWinner"
        :disabled="loading"
        class="text-white bg-btn hover:bg-btn1 focus:outline-none font-medium rounded-lg text-sm px-4 py-2 cursor-pointer"
      >
        Pick Winner
      </button>
    </div>
  </section>
</template>

<script setup>
import { ref } from "vue";
import { useWalletStore } from "../stores/walletStore";
import { toast } from "vue3-toastify";

const walletStore = useWalletStore();
const loading = ref(false);

const startRound = async () => {
  loading.value = true;
  try {
    const gasPrice = await walletStore.provider.eth.getGasPrice();

    const gas = await walletStore.contract.methods
      .startRound()
      .estimateGas({ from: walletStore.walletAddress });

    await walletStore.contract.methods
      .startRound()
      .send({ from: walletStore.walletAddress, gas, gasPrice });

    toast.success("Round started successfully!");
  } catch (error) {
    toast.error(`Failed to start round: ${error.message}`);
    console.error("Start Round Error:", error);
  } finally {
    loading.value = false;
  }
};

const endRound = async () => {
  loading.value = true;
  try {
    const gasPrice = await walletStore.provider.eth.getGasPrice();

    const gas = await walletStore.contract.methods
      .endRound()
      .estimateGas({ from: walletStore.walletAddress });
    await walletStore.contract.methods
      .endRound()
      .send({ from: walletStore.walletAddress, gas, gasPrice });
    toast.success("Round ended successfully!");
  } catch (error) {
    toast.error(`Failed to end round: ${error.message}`);
    console.error("End Round Error:", error);
  } finally {
    loading.value = false;
  }
};

const pickWinner = async () => {
  loading.value = true;
  try {
    const gasPrice = await walletStore.provider.eth.getGasPrice();

    const gas = await walletStore.contract.methods
      .pickWinner()
      .estimateGas({ from: walletStore.walletAddress });
    await walletStore.contract.methods
      .pickWinner()
      .send({ from: walletStore.walletAddress, gas, gasPrice });
    toast.success("Winner picked successfully!");
  } catch (error) {
    toast.error(`Failed to pick winner: ${error.message}`);
    console.error("Pick Winner Error:", error);
  } finally {
    loading.value = false;
  }
};
</script>
