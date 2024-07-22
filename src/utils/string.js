export const getAddress = (address) => {
  // Optionally format the address to display in the UI
  return `${address.slice(0, 6)}...${address.slice(-4)}`;
};
