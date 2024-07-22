<template>
  <section class="flex flex-col space-y-4">
    <span class="text-2xl font-semibold text-title">Home</span>
    <div class="bg-card rounded-lg shadow-md p-4 text-text">
      <div class="flex border-b border-gray-700 pb-2 mb-2">
        <div class="w-1/4 font-semibold">Round</div>
        <div class="w-1/4 font-semibold">Prize Pool</div>
        <div class="w-1/4 font-semibold">Players</div>
        <div class="w-1/4 font-semibold">Status</div>
      </div>
      <div class="flex">
        <div class="w-1/4">{{ round }}</div>
        <div class="w-1/4">{{ prizePool }} ETH</div>
        <div class="w-1/4">{{ players.length }}</div>
        <div
          :class="['w-1/4', status == 1 ? 'text-green-500' : 'text-red-500']"
        >
          {{ status == 1 ? "RUNNING" : "NOT RUNNING" }}
        </div>
      </div>
      <div class="mt-4">
        <p
          id="helper-text-explanation"
          class="text-sm text-gray-500 dark:text-gray-400"
        >
          Ticket fee should be 0.005 ether
        </p>
        <button
          @click="buyTicket"
          :disabled="loading || status != 1"
          class="relative inline-flex items-center justify-center p-0.5 mb-2 mt-4 overflow-hidden text-sm font-medium text-title rounded-lg group bg-gradient-to-br from-btn to-btn1 group-hover:from-btn group-hover:to-btn1 hover:text-white focus:outline-none"
        >
          <span
            class="relative px-5 py-2.5 transition-all ease-in duration-75 bg-card rounded-md group-hover:bg-opacity-0 cursor-pointer"
          >
            Buy Ticket
          </span>
        </button>
        <div v-if="loading" class="text-sm text-gray-500">Processing...</div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { toast } from "vue3-toastify";
import { useWalletStore } from "../stores/walletStore";

const walletStore = useWalletStore();
const round = ref(0);
const prizePool = ref(0);
const status = ref("");
const players = ref([]);
const loading = ref(false);

const fetchContractData = async () => {
  loading.value = true;
  try {
    round.value = await walletStore.contract.methods.currentRound().call();
    const prize = await walletStore.contract.methods.getPrizePool().call();
    prizePool.value = walletStore.provider.utils.fromWei(prize, "ether");
    players.value = await walletStore.contract.methods.getPlayers().call();
    status.value = await walletStore.contract.methods.status().call();
  } catch (error) {
    toast.error(`Failed to fetch contract data: ${error.message}`);
    console.error("Fetch Contract Data Error:", error);
  } finally {
    loading.value = false;
  }
};

const buyTicket = async () => {
  loading.value = true;
  try {
    const ticketPrice = walletStore.provider.utils.toWei("0.005", "ether");
    const gas = await walletStore.contract.methods.enter().estimateGas({
      from: walletStore.walletAddress,
      value: ticketPrice,
    });

    await walletStore.contract.methods.enter().send({
      from: walletStore.walletAddress,
      value: ticketPrice,
      gas,
    });

    toast.success("Ticket purchased successfully!");
    await fetchContractData();
  } catch (error) {
    toast.error(`Failed to buy ticket: ${error.message}`);
    console.error("Buy Ticket Error:", error);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchContractData();
});
</script>
