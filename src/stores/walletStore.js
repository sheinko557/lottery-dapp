import { defineStore } from "pinia";

export const useWalletStore = defineStore("wallet", {
  state: () => ({
    provider: null,
    contractAddress: "0x640ed1af4893cf869cd4bda718c30b76001f4412",
    contract: null,
    walletAddress: null,
    isWalletConnected: false,
  }),
  actions: {
    setProvider(provider) {
      if (provider && typeof provider === "object") {
        this.provider = provider;
      } else {
        console.error("Invalid provider");
      }
    },
    setWalletAddress(address) {
      if (address && typeof address === "string") {
        this.walletAddress = address;
        this.isWalletConnected = true;
      } else {
        this.walletAddress = null;
        this.isWalletConnected = false;
        console.warn("Invalid wallet address");
      }
    },
    setContract(contract) {
      if (contract && typeof contract.methods === "object") {
        this.contract = contract;
      } else {
        console.error("Invalid contract");
      }
    },
  },
});
