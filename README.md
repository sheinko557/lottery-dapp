# Lottery Simple DApp

## Overview

The Lottery DApp is a decentralized lottery application built using Vue 3, Vite, and Hardhat. It allows users to connect their MetaMask wallet, participate in lottery rounds, and view historical lottery data. The smart contracts are deployed on the Sepolia test network.

## Features

- Connect to MetaMask wallet
- Start new lottery rounds
- Buy lottery tickets
- View current round details
- View lottery history

## Project Structure

- **contract/**: Contains the smart contract for the lottery.
  - `Lottery.sol`: The main smart contract for the lottery.
- **scripts/**: Contains deployment scripts.
  - `deploy.mjs`: Script to deploy the smart contract.
- **src/**: Source code for the frontend application.
  - `App.vue`: Main application component.
  - `main.js`: Entry point for the Vue application.
  - **components/**: Vue components for the application.
    - `AppBar.vue`: Application header component.
    - `Home.vue`: Main page component showing round details.
    - `History.vue`: Component to display lottery history.
    - `WalletConnect.vue`: Component for wallet connection.
- **.env**: Environment variables for configuration.

## Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd lottery
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

## Development

1. **To start the development server:**

   ```bash
   npm run dev
   ```

   This will launch the Vite development server and open the application in your browser.

## Building for Production

1. **To build the application for production:**

   ```bash
   npm run build
   ```

   This will create an optimized production build in the `dist` directory.

## Deploying Smart Contracts

1. **To compile the smart contracts:**

   ```bash 
   npm run contract:compile
   ```

2. **To deploy the smart contracts to the Sepolia test network:**

   ```bash
   npm run contract:deploy
   ```

   Make sure to set up your .env file with the necessary environment variables, such as your Infura/Alchemy project ID and private key.

## Environment Variables

1. Create a `.env` file in the root directory and add the following variables:
   ```bash
   INFURA_PROJECT_ID=your_infura_project_id
   PRIVATE_KEY=your_private_key
   ```
   Replace your_infura_project_id and your_private_key with your actual Infura project ID and private key, respectively.

## Dependencies

- **pinia**: State management library for Vue.
- **vue**: Vue.js framework.
- **vue3-toastify**: Toast notifications for Vue 3.
- **web3**: JavaScript library for interacting with Ethereum.
- **@nomicfoundation/hardhat-toolbox**: Hardhat toolbox for Ethereum development.
- **@vitejs/plugin-vue**: Vite plugin for Vue 3.
- **autoprefixer**: PostCSS plugin for autoprefixing CSS.
- **dotenv**: Module to load environment variables.
- **ethers**: JavaScript library for interacting with Ethereum, used alongside Hardhat.
- **hardhat**: Ethereum development environment.
- **postcss**: CSS post-processing tool.
- **tailwindcss**: Utility-first CSS framework.
- **vite**: Modern build tool for JavaScript projects.
