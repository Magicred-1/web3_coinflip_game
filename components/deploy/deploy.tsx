const hre = require("hardhat");
import { ethers } from "ethers";

async function sleep() {
    return new Promise((resolve) => setTimeout(resolve, 1000));
}

async function main() {
    const initialAmount = ethers.utils.parseEther("0.001");
    const CoinFlip = await hre.ethers.getContractFactory("CoinFlip");

    const contract = await CoinFlip.deploy({ value: initialAmount });

    await contract.deployed();

    console.log("CoinFlip deployed to:", contract.address);
