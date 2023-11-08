import mudConfig from "contracts/mud.config";
import { SetupResult, setup } from "./mud/setup";
import { derived, get, writable, type Writable } from "svelte/store";
import { mount as mountDevTools } from "@latticexyz/dev-tools";
import { ComponentValue } from "@latticexyz/recs";
import { ClientComponents } from "./mud/createClientComponents";

export const mud = writable() as Writable<SetupResult>;

setup().then((mudSetupResult) => {
  // mud.set(mudSetupResult);

  const { network } = mudSetupResult;

  mountDevTools({
    config: mudConfig,
    publicClient: network.publicClient,
    walletClient: network.walletClient,
    latestBlock$: network.latestBlock$,
    storedBlockLogs$: network.storedBlockLogs$,
    worldAddress: network.worldContract.address,
    worldAbi: network.worldContract.abi,
    write$: network.write$,
    recsWorld: network.world,
  });
});

function MakeComponentValueStore<T extends keyof ClientComponents>(
  componentName: T,
  initValue?: Partial<ComponentValue<ClientComponents[T]["schema"]>>
) {
  const componentValue = writable<
    ComponentValue<ClientComponents[T]["schema"]>
  >(initValue ?? {});

  let subscribed = false;
  mud.subscribe(($mud) => {
    if (!$mud || subscribed) return;

    $mud.components[componentName].update$.subscribe((update) => {
      console.log(componentName, update);
      const [newValue] = update.value;
      if (!newValue) return;
      componentValue.set(newValue);
    });

    subscribed = true;
  });

  return componentValue;
}

export const counter = MakeComponentValueStore("Counter", { value: 0 });
export const wakeupObjectiveEntities =
  MakeComponentValueStore("WakeupObjectives");
