<template>
  <section class="flex flex-col space-y-4">
    <span class="text-2xl font-semibold text-title">History</span>
    <div
      class="overflow-y-auto h-72 bg-card rounded-lg shadow-md p-4 text-text"
    >
      <div v-if="loading" class="flex justify-center items-center h-full">
        <span class="text-sm text-gray-500">Loading...</span>
      </div>
      <div v-else>
        <ul role="list" class="divide-y divide-gray-200 dark:divide-gray-700">
          <li v-if="history.length === 0" class="py-3 sm:py-4 text-center">
            <span class="text-sm text-gray-500 dark:text-gray-400">
              No history available
            </span>
          </li>
          <li
            v-for="(entry, index) in history"
            :key="index"
            class="py-3 sm:py-4"
          >
            <div class="flex items-center">
              <!-- Rounded text for ROUND -->
              <div
                class="w-8 h-8 flex items-center justify-center rounded-full bg-btn text-white font-semibold"
              >
                {{ entry.round }}
              </div>
              <div class="flex-1 min-w-0 ms-4">
                <p
                  class="text-sm font-medium text-gray-900 truncate dark:text-white"
                >
                  {{ entry.winner }}
                </p>
                <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                  Prize Pool: {{ formatEther(entry.prizePool) }} ETH
                </p>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { toast } from "vue3-toastify";
import { useWalletStore } from "../stores/walletStore";

const walletStore = useWalletStore();
const history = ref([]);
const loading = ref(true);

const fetchContractData = async () => {
  loading.value = true;
  try {
    const data = await walletStore.contract.methods.getHistory().call();
    history.value = data.reverse();
  } catch (error) {
    toast.error(`Failed to fetch history: ${error.message}`);
    console.error("Fetch History Error:", error);
  } finally {
    loading.value = false;
  }
};

const formatEther = (wei) => {
  return walletStore.provider.utils.fromWei(wei, "ether");
};

onMounted(() => {
  fetchContractData();
});
</script>
