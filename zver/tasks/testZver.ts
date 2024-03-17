import { ZVER } from "../types";
import { task } from "hardhat/config";
import type { TaskArguments } from "hardhat/types";

function delay(time) {
  return new Promise(resolve => setTimeout(resolve, time));
}

task("task:testZver")
  .setAction(async function (_taskArguments: TaskArguments, hre) {
    const { fhenixjs, ethers, deployments } = hre;
    const [signer] = await ethers.getSigners();

    if ((await ethers.provider.getBalance(signer.address)).toString() === "0") {
      await fhenixjs.getFunds(signer.address);
    }

    // const amountToAdd = Number(taskArguments.amount);
    const ZVER = await deployments.get("ZVER");

    const contract = await ethers.getContractAt("ZVER", ZVER.address);

    let contractWithSigner = contract.connect(signer) as unknown as Counter;

    const INSTR_ADD = 0;
    const INSTR_MUL = 1;
    const PUSH_CONST = 2;
    const PUSH_PRIV = 3;
    const PUSH_PUB = 4;

    try {
      console.log('Testing ZVER contract...');

      let tx = await contractWithSigner.addPubConst(Number(2*16 - 10)); // -10
      let receipt = await tx.wait();
      console.log('addPubConst');

      tx = await contractWithSigner.addInstr(PUSH_CONST, Number(0));
      receipt = await tx.wait();
      console.log('addInstr');

      tx = await contractWithSigner.addInstr(PUSH_PRIV, Number(0));
      receipt = await tx.wait();
      console.log('addInstr');

      tx = await contractWithSigner.addInstr(PUSH_PRIV, Number(1));
      receipt = await tx.wait();
      console.log('addInstr');

      tx = await contractWithSigner.addInstr(INSTR_MUL, Number(0));
      receipt = await tx.wait();
      console.log('addInstr');

      tx = await contractWithSigner.addInstr(INSTR_ADD, Number(0));
      receipt = await tx.wait();
      console.log('addInstr');
  
      let encryptedAmount = await fhenixjs.encrypt_uint32(2);
      tx = await contractWithSigner.addPrivInput(encryptedAmount);
      receipt = await tx.wait();
      console.log('addPrivInput');

      encryptedAmount = await fhenixjs.encrypt_uint32(5);
      tx = await contractWithSigner.addPrivInput(encryptedAmount);
      receipt = await tx.wait();
      console.log('addPrivInput');

      tx = await contractWithSigner.runZver();
      receipt = await tx.wait();
      console.log('runZver: ', receipt.transactionHash);
  
      const result = await contract.getDecrVer();
      console.log(`Verification Result: ${result.toString()}`);
    
    } catch (e) {
      console.log(`Error: ${e}`);
      return;
    }
  });
