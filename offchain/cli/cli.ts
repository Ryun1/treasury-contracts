#!/usr/bin/env node

import { Command } from "commander";
import { fund } from "./treasury/fund";
import { publish } from "./treasury/publish";
import { sweep } from "./treasury/sweep";
import { withdraw as initialize } from "./treasury/withdraw";
import { pause, resume } from "./vendor/adjudicate";
import { withdraw } from "./vendor/withdraw";

const program = new Command();

program
  .name("treasury-funds")
  .description("Treasury funds CLI tool")
  .version("1.0.0");

program
  .command("publish")
  .description("Initiate/publish treasury and vendor contracts")
  .action(async () => {
    await publish();
  });

program
  .command("initialize")
  .description("Initialize treasury by withdrawing funds")
  .action(async () => {
    await initialize();
  });

program
  .command("fund")
  .description("Fund a vendor utxo from the treasury")
  .action(async () => {
    await fund();
  });

program
  .command("sweep")
  .description("Sweep funds to treasury from the treasury")
  .action(async () => {
    await sweep();
  })

program
  .command("pause")
  .description("Pause one or more payouts in a vendor contract")
  .action(async () => {
    await pause();
  });

program
  .command("resume")
  .description("Resume one or more payouts in a vendor contract")
  .action(async () => {
    await resume();
  });

program
  .command("withdraw")
  .description("Withdraw one or more payouts in a vendor contract")
  .action(async () => {
    await withdraw();
  });

program.parse(process.argv);
