# ZVER Test

```sh
cd zver
pnpm install
```

Once installed, let's run a LocalFhenix instance:

```sh
pnpm localfhenix:start
```

This will start a LocalFhenix instance in a docker container. If this worked you should see a `Started LocalFhenix successfully` message in your console.

If not, please make sure you have `docker` installed and running on your machine. You can find instructions on how Now that we have a LocalFhenix instance running, we can deploy our contracts to it:

```sh
pnpm compile
pnpm task:deploy
```

Note that this template defaults to use the `localfhenix` network, which is injected into the hardhat configuration.

Finally, we can run the tasks with:

```sh
pnpm task:testZver => 0
```
