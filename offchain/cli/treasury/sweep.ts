import { Blaze, Provider, Wallet } from "@blaze-cardano/sdk";
import { Treasury } from "src";
import {
  getBlazeInstance,
  getConfigs,
  selectUtxo,
  transactionDialog
} from "../shared";

import { loadTreasuryScript } from "../../src/shared";

export async function sweep(
  blazeInstance: Blaze<Provider, Wallet> | undefined = undefined,
): Promise<void> {
  if (!blazeInstance) {
    blazeInstance = await getBlazeInstance();
  }
  const { configs, scripts } = await getConfigs(blazeInstance);

  const { scriptAddress: treasuryScriptAddress, ...rest } = loadTreasuryScript(
    blazeInstance.provider.network,
    configs.treasury,
  );

  const utxos = await blazeInstance.provider.getUnspentOutputs(
    treasuryScriptAddress,
  );
  const utxo = await selectUtxo(utxos);

  // make user sweep all the funds from the selected utxo
  const sweepAmount = utxo.output().amount().coin();

  // todo add support for metadata in sweep
  const tx = await Treasury.sweep({
    configsOrScripts: { configs, scripts },
    input: utxo,
    blaze: blazeInstance,
    amount: sweepAmount,
  });

  const finalTx = await tx.complete();
  await transactionDialog(
    blazeInstance.provider.network,
    finalTx.toCbor().toString(),
    false,
  );
}
